package main

import (
	"fmt"
	"log"
	"os"

	"github.com/fefe221/arko-backend/models"
	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt" // Biblioteca de criptografia
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"github.com/gin-contrib/cors"
)

var DB *gorm.DB

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

	// Chamamos a criação do admin logo após o migrate
	createAdmin()
}

func createAdmin() {
	var user models.User
	// Verifica se já existe QUALQUER usuário no banco
	result := DB.First(&user)

	if result.Error == gorm.ErrRecordNotFound {
		fmt.Println("Criando usuário administrador inicial...")
		
		// 1. Criptografa a senha "admin123"
		hashedPassword, err := bcrypt.GenerateFromPassword([]byte("admin123"), bcrypt.DefaultCost)
		if err != nil {
			log.Fatal("Erro ao criptografar senha")
		}

		// 2. Cria o objeto do usuário
		admin := models.User{
			Username: "admin",
			Password: string(hashedPassword),
		}

		// 3. Salva no banco
		DB.Create(&admin)
		fmt.Println("Admin criado com sucesso! Usuário: admin | Senha: admin123")
	} else {
		fmt.Println("Usuário administrador já existe. Pulando criação.")
	}
}

func main() {
	initDatabase()
	r := gin.Default()
	

	r.Use(cors.Default())

	// Rota de Login
	r.POST("/login", func(c *gin.Context) {
		var input struct {
			Username string `json:"username"`
			Password string `json:"password"`
		}

		// 1. Pega os dados do JSON enviado pelo Flutter
		if err := c.ShouldBindJSON(&input); err != nil {
			c.JSON(400, gin.H{"error": "Dados inválidos"})
			return
		}

		// 2. Busca o usuário no banco
		var user models.User
		if err := DB.Where("username = ?", input.Username).First(&user).Error; err != nil {
			c.JSON(401, gin.H{"error": "Usuário ou senha incorretos"})
			return
		}

		// 3. Verifica a senha usando Bcrypt
		err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(input.Password))
		if err != nil {
			c.JSON(401, gin.H{"error": "Usuário ou senha incorretos"})
			return
		}

		// 4. Se chegou aqui, login deu certo! (Por enquanto retornamos sucesso)
		// Em breve geraremos o Token JWT real aqui.
		c.JSON(200, gin.H{"message": "Login realizado com sucesso!", "user": user.Username})
	})

	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{"message": "Arko API Online!"})
	})

	r.Run(":8080")
}
