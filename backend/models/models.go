package models

import (
	"gorm.io/gorm"
	"time"
)

type User struct {
	ID        uint           `gorm:"primaryKey" json:"id"`
	Username  string         `gorm:"unique" json:"username"`
	Password  string         `json:"password,omitempty"` // Removido o "-" para permitir POST
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `gorm:"index" json:"-"`
}
// ... restante dos modelos (Project, Image, Lead) permanecem iguais ...

// Project: Os projetos arquitetônicos da Arkō
type Project struct {
	ID          uint           `gorm:"primaryKey" json:"id"`
	Title       string         `gorm:"not null" json:"title"`
	Description string         `json:"description"`
	Location    string         `json:"location"`
	Category    string         `json:"category"`
	MainImage   string         `json:"main_image"`
	Images      []Image        `json:"images"` // Relacionamento 1:N
	CreatedAt   time.Time      `json:"created_at"`
	UpdatedAt   time.Time      `json:"updated_at"`
	DeletedAt   gorm.DeletedAt `gorm:"index" json:"-"`
}

// Image: Galeria de fotos de um projeto
type Image struct {
	ID        uint           `gorm:"primaryKey" json:"id"`
	ProjectID uint           `json:"project_id"`
	URL       string         `json:"url"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `gorm:"index" json:"-"`
}

// Lead: Captação de clientes das LPs
type Lead struct {
	ID        uint           `gorm:"primaryKey" json:"id"`
	Name      string         `json:"name"`
	Email     string         `json:"email"`
	Phone     string         `json:"phone"`
	Source    string         `json:"source"`
	Message   string         `json:"message"`
	Status    string         `gorm:"default:'novo'" json:"status"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `gorm:"index" json:"-"`
}
