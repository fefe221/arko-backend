package models

import (
	"gorm.io/gorm"
	"time"
)

// User: Para a área administrativa
type User struct {
    // Definimos o ID manualmente para controlar a tag JSON
    ID        uint           `gorm:"primaryKey" json:"id"` 
    Username  string         `gorm:"unique" json:"username"`
    Password  string         `json:"-"` // A senha nunca sai para o front
    CreatedAt time.Time      `json:"created_at"`
    UpdatedAt time.Time      `json:"updated_at"`
    DeletedAt gorm.DeletedAt `gorm:"index" json:"-"`
}

// Project: Os projetos arquitetônicos da Arkō
type Project struct {
	gorm.Model
	Title       string  `gorm:"not null" json:"title"`
	Description string  `json:"description"`
	Category    string  `json:"category"`
	MainImage   string  `json:"main_image"`
	Images      []Image `json:"images"` // Relacionamento 1:N
}

// Image: Galeria de fotos de um projeto
type Image struct {
	gorm.Model
	ProjectID uint   `json:"project_id"`
	URL       string `json:"url"`
}

// Lead: Captação de clientes das LPs
type Lead struct {
	gorm.Model
	Name    string `json:"name"`
	Email   string `json:"email"`
	Phone   string `json:"phone"`
	Source  string `json:"source"`
	Message string `json:"message"`
	Status  string `gorm:"default:'novo'" json:"status"`
}
