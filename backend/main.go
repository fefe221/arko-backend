package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/fefe221/arko-backend/models"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB
var jwtSecret = []byte("sua_chave_secreta_ultra_segura_da_arko")

// --- MIDDLEWARE DE AUTENTICAÇÃO ---
func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		// O Flutter enviará: Authorization: Bearer <TOKEN>
		tokenString := c.GetHeader("Authorization")

		if tokenString == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Acesso negado. Token não fornecido."})
			c.Abort()
			return
		}

		// Validamos o Token
		token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
			return jwtSecret, nil
		})

		if err != nil || !token.Valid {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Sessão inválida ou expirada."})
			c.Abort()
			return
		}

		c.Next() // Token OK, pode seguir para a rota
	}
}

func initDatabase() {
	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=disable",
		os.Getenv("DB_HOST"), os.Getenv("DB_USER"), os.Getenv("DB_PASSWORD"),
		os.Getenv("DB_NAME"), os.Getenv("DB_PORT"),
	)

	var err error
	DB, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal("Falha ao conectar no banco de dados:", err)
	}

	DB.AutoMigrate(&models.User{}, &models.Project{}, &models.Image{}, &models.Lead{})
	createAdmin()
}

func createAdmin() {
	var user models.User
	if err := DB.Where("username = ?", "admin").First(&user).Error; err == gorm.ErrRecordNotFound {
		hashedPassword, _ := bcrypt.GenerateFromPassword([]byte("admin123"), bcrypt.DefaultCost)
		admin := models.User{Username: "admin", Password: string(hashedPassword)}
		DB.Create(&admin)
		fmt.Println("Admin principal criado!")
	}
}

func main() {
	initDatabase()
	r := gin.Default()


	r.Use(cors.New(cors.Config{
    AllowOrigins:     []string{"*"}, // Em produção, trocaremos pelo domínio da Arkō
    AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
    AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
    ExposeHeaders:    []string{"Content-Length"},
    AllowCredentials: true,
    MaxAge:           12 * time.Hour,
	}))



	// ROTA PÚBLICA: Login
	r.POST("/login", func(c *gin.Context) {
		var input struct {
			Username string `json:"username"`
			Password string `json:"password"`
		}
		if err := c.ShouldBindJSON(&input); err != nil {
			c.JSON(400, gin.H{"error": "Dados inválidos"})
			return
		}

		var user models.User
		if err := DB.Where("username = ?", input.Username).First(&user).Error; err != nil {
			c.JSON(401, gin.H{"error": "Usuário ou senha incorretos"})
			return
		}

		if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(input.Password)); err != nil {
			c.JSON(401, gin.H{"error": "Usuário ou senha incorretos"})
			return
		}

		token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
			"user_id": user.ID,
			"exp":     time.Now().Add(time.Hour * 24).Unix(),
		})

		tokenString, _ := token.SignedString(jwtSecret)
		c.JSON(200, gin.H{"token": tokenString})
	})

	// --- GRUPO PROTEGIDO: GESTÃO DE COLABORADORES ---
	adminRoutes := r.Group("/admin")
	adminRoutes.Use(AuthMiddleware())
	{
		// Listar Colaboradores
		adminRoutes.GET("/users", func(c *gin.Context) {
			var users []models.User
			DB.Select("id", "username").Find(&users)
			c.JSON(200, users)
		})

		// Criar Novo Colaborador
		adminRoutes.POST("/users", func(c *gin.Context) {
			var input struct {
				Username string `json:"username"`
				Password string `json:"password"`
			}
			if err := c.ShouldBindJSON(&input); err != nil {
				c.JSON(400, gin.H{"error": "Dados inválidos"})
				return
			}

			hashedPassword, _ := bcrypt.GenerateFromPassword([]byte(input.Password), bcrypt.DefaultCost)
			newUser := models.User{Username: input.Username, Password: string(hashedPassword)}
			
			if err := DB.Create(&newUser).Error; err != nil {
				c.JSON(400, gin.H{"error": "Usuário já existe"})
				return
			}
			c.JSON(201, gin.H{"message": "Colaborador criado!"})
		})
		// --- Rota para Excluir Colaborador ---
		// O ":id" é um parâmetro dinâmico que o Gin captura da URL
		adminRoutes.DELETE("/users/:id", func(c *gin.Context) {
    	id := c.Param("id") // Captura o ID da URL

    	// Executa o Delete no Banco. 
    	// Como usamos gorm.Model (ou DeletedAt), o GORM faz um "Soft Delete" (marca como excluído mas não remove fisicamente)
    	if err := DB.Delete(&models.User{}, id).Error; err != nil {
       		 c.JSON(http.StatusInternalServerError, gin.H{"error": "Erro ao excluir usuário"})
        return
    }

    c.JSON(http.StatusOK, gin.H{"message": "Usuário removido com sucesso"})
})
	}

	r.Run(":8080")
}
