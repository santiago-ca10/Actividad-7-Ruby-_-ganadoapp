require 'date' 
# Se requiere la librería 'date' para manejar correctamente fechas (como la fecha de nacimiento del animal)

class Animal
  attr_accessor :id, :name, :birth_date, :history
  # Se crean atributos accesibles para lectura y escritura: id, nombre, fecha de nacimiento e historial médico

  def initialize(id:, name:, birth_date:, history:)
    # Método constructor que inicializa un nuevo objeto Animal con los datos requeridos

    @id = id
    # Asigna el ID único del animal (puede ser un número entero o cadena, según se configure en el sistema)

    @name = name
    # Asigna el nombre del animal

    @birth_date = Date.parse(birth_date.to_s)
    # Convierte el parámetro birth_date a tipo Date para asegurar consistencia de formato

    @history = history
    # Asigna el historial médico (puede ser una cadena o lista de eventos, según el diseño)
  end

  def to_h
    {
      id: @id,
      name: @name,
      birth_date: @birth_date.to_s,
      history: @history
    }
    # Convierte los datos del animal a un Hash, útil para serializar en JSON u otros formatos
  end
end

