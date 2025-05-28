# 🐄 Sistema de Gestión de Ganado

Aplicación de escritorio en Ruby con interfaz GTK3 para registrar, editar y eliminar animales. Diseñada con arquitectura en capas, principios SOLID y almacenamiento en JSON.

## 🧱 Estructura del Proyecto

- animal.rb: Modelo de datos.
- animal_repository.rb: Manejo de archivos JSON.
- animal_service.rb: Lógica de negocio.
- main_window.rb: Interfaz gráfica con GTK3.
- main.rb: Punto de entrada.

## 🚀 Funcionalidades

- Crear, editar y eliminar animales
- Validación de fecha de nacimiento
- Interfaz editable directamente
- Persistencia en data/animals.json

## ▶ Requisitos

- Ruby 2.7+
- GTK3 (gem install gtk3)
