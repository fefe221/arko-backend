package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"time"

	"github.com/fefe221/arko-backend/models"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB
var jwtSecret = []byte("sua_chave_secreta_ultra_segura_da_arko")

func CORSMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT, DELETE, PATCH")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		c.Next()
	}
}

func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		tokenString := c.GetHeader("Authorization")
		if tokenString == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Acesso negado"})
			c.Abort()
			return
		}
		token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
			return jwtSecret, nil
		})
		if err != nil || !token.Valid {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Sessão expirada"})
			c.Abort()
			return
		}
		c.Next()
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
		log.Fatal("Erro DB:", err)
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
	}
}

func main() {
	initDatabase()
	r := gin.Default()
	r.Use(CORSMiddleware())

	uploadDir := "./uploads"
	os.MkdirAll(uploadDir, 0755)
	r.Static("/uploads", uploadDir)

	r.POST("/login", func(c *gin.Context) {
		var input struct {
			Username string `json:"username"`
			Password string `json:"password"`
		}
		c.ShouldBindJSON(&input)
		var user models.User
		if err := DB.Where("username = ?", input.Username).First(&user).Error; err != nil {
			c.JSON(401, gin.H{"error": "Não autorizado"})
			return
		}
		if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(input.Password)); err != nil {
			c.JSON(401, gin.H{"error": "Senha incorreta"})
			return
		}
		token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
			"user_id": user.ID,
			"exp":     time.Now().Add(time.Hour * 24).Unix(),
		})
		tokenString, _ := token.SignedString(jwtSecret)
		c.JSON(200, gin.H{"token": tokenString})
	})

	// Rota pública para listar projetos (sem autenticação)
	r.GET("/projects", func(c *gin.Context) {
		var projects []models.Project
		DB.Preload("Images").Find(&projects)
		c.JSON(200, projects)
	})

	// Rota pública para capturar leads das landing pages
	r.POST("/leads", func(c *gin.Context) {
		var input struct {
			Name    string `json:"name"`
			Email   string `json:"email"`
			Phone   string `json:"phone"`
			Source  string `json:"source"`
			Message string `json:"message"`
		}
		if err := c.ShouldBindJSON(&input); err != nil {
			c.JSON(400, gin.H{"error": "Dados inválidos"})
			return
		}
		lead := models.Lead{
			Name:    input.Name,
			Email:   input.Email,
			Phone:   input.Phone,
			Source:  input.Source,
			Message: input.Message,
		}
		if err := DB.Create(&lead).Error; err != nil {
			c.JSON(500, gin.H{"error": "Erro ao salvar lead"})
			return
		}
		c.JSON(201, lead)
	})

	admin := r.Group("/admin")
	admin.Use(AuthMiddleware())
	{
		admin.GET("/projects", func(c *gin.Context) {
			var projects []models.Project
			DB.Preload("Images").Find(&projects)
			c.JSON(200, projects)
		})

		admin.POST("/projects", func(c *gin.Context) {
			form, _ := c.MultipartForm()
			p := models.Project{
				Title:       c.PostForm("title"),
				Description: c.PostForm("description"),
				Location: 	 c.PostForm("location"),
				Category: c.PostForm("category"),

			}
			DB.Create(&p)
			files := form.File["images"]
			for _, file := range files {
				name := uuid.New().String() + filepath.Ext(file.Filename)
				c.SaveUploadedFile(file, filepath.Join(uploadDir, name))
				DB.Create(&models.Image{ProjectID: p.ID, URL: "/uploads/" + name})
			}
			c.JSON(201, p)
		})

		admin.DELETE("/projects/:id", func(c *gin.Context) {
			id := c.Param("id")
			DB.Where("project_id = ?", id).Delete(&models.Image{})
			DB.Delete(&models.Project{}, id)
			c.JSON(200, gin.H{"status": "deleted"})
		})

		admin.GET("/users", func(c *gin.Context) {
			var users []models.User
			DB.Select("id", "username").Find(&users)
			c.JSON(200, users)
		})

		// ROTA CORRIGIDA: Adicionado o POST para criação de usuários
		admin.POST("/users", func(c *gin.Context) {
			var input struct {
				Username string `json:"username"`
				Password string `json:"password"`
			}
			if err := c.ShouldBindJSON(&input); err != nil {
				c.JSON(400, gin.H{"error": "Dados inválidos"})
				return
			}
			hashedPassword, _ := bcrypt.GenerateFromPassword([]byte(input.Password), bcrypt.DefaultCost)
			user := models.User{Username: input.Username, Password: string(hashedPassword)}
			if err := DB.Create(&user).Error; err != nil {
				c.JSON(500, gin.H{"error": "Erro ao criar usuário"})
				return
			}
			c.JSON(201, user)
		})

		admin.DELETE("/users/:id", func(c *gin.Context) {
			DB.Delete(&models.User{}, c.Param("id"))
			c.JSON(200, gin.H{"status": "deleted"})
		})

		admin.GET("/leads", func(c *gin.Context) {
			var leads []models.Lead
			DB.Order("created_at desc").Find(&leads)
			c.JSON(200, leads)
		})

		admin.PATCH("/leads/:id/status", func(c *gin.Context) {
			var input struct {
				Status string `json:"status"`
			}
			if err := c.ShouldBindJSON(&input); err != nil || input.Status == "" {
				c.JSON(400, gin.H{"error": "Status inválido"})
				return
			}
			if err := DB.Model(&models.Lead{}).
				Where("id = ?", c.Param("id")).
				Update("status", input.Status).Error; err != nil {
				c.JSON(500, gin.H{"error": "Erro ao atualizar lead"})
				return
			}
			c.JSON(200, gin.H{"status": "ok"})
		})
	}

	r.Run(":8080")
}
