package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/fefe221/arko-backend/models" // AJUSTE PARA SEU USUÁRIO SE NECESSÁRIO
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB
var jwtSecret = []byte("sua_chave_secreta_ultra_segura_da_arko")

func initDatabase() {
	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=disable",
		os.Getenv("DB_HOST"),
		os.Getenv("DB_USER"),
		os.Getenv("DB_PASSWORD"),
		os.Getenv("DB_NAME"),
		os.Getenv("DB_PORT"),
	)

	var err error
	DB, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal("Falha ao conectar no banco de dados:", err)
	}

	DB.AutoMigrate(&models.User{}, &models.Project{}, &models.Image{}, &models.Lead{})
	fmt.Println("Banco de dados sincronizado!")

	createAdmin()
}

func createAdmin() {
	var user models.User
	result := DB.First(&user)

	if result.Error == gorm.ErrRecordNotFound {
		hashedPassword, _ := bcrypt.GenerateFromPassword([]byte("admin123"), bcrypt.DefaultCost)
		admin := models.User{
			Username: "admin",
			Password: string(hashedPassword),
		}
		DB.Create(&admin)
		fmt.Println("Admin criado com sucesso!")
	}
}

func main() {
	initDatabase()

	r := gin.Default()

	// Configuração do CORS para o Flutter Web conseguir acessar
	r.Use(cors.Default())

	r.POST("/login", func(c *gin.Context) {
		var input struct {
			Username string `json:"username"`
			Password string `json:"password"`
		}

		if err := c.ShouldBindJSON(&input); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Dados inválidos"})
			return
		}

		var user models.User
		if err := DB.Where("username = ?", input.Username).First(&user).Error; err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Usuário ou senha incorretos"})
			return
		}

		if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(input.Password)); err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Usuário ou senha incorretos"})
			return
		}

		// Geração do Token JWT
		token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
			"user_id": user.ID,
			"exp":     time.Now().Add(time.Hour * 24).Unix(),
		})

		tokenString, err := token.SignedString(jwtSecret)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Erro ao gerar token"})
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"message": "Login realizado!",
			"token":   tokenString,
		})
	})

	r.GET("/ping", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"message": "Arko API Online!"})
	})

	fmt.Println("Servidor rodando na porta 8080")
	r.Run(":8080")
}
