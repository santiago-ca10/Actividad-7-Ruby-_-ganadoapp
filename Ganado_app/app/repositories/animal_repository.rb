require 'json'
# Se importa la librería JSON para leer y escribir datos en formato JSON

require_relative '../models/animal'
# Se incluye el archivo donde se define la clase Animal

class AnimalRepository
  FILE_PATH = 'data/animals.json'
  # Ruta al archivo JSON donde se almacenan los datos de los animales

  def initialize
    File.write(FILE_PATH, '[]') unless File.exist?(FILE_PATH)
    # Si el archivo no existe, lo crea con un arreglo vacío (JSON válido)

    @animals = load_animals
    # Carga los animales desde el archivo JSON al iniciar el repositorio
  end

  def all
    @animals
    # Devuelve la lista completa de animales cargados en memoria
  end

  def save(animal)
    index = @animals.find_index { |a| a.id == animal.id }
    # Busca si ya existe un animal con el mismo ID

    if index
      @animals[index] = animal
      # Si existe, lo actualiza
    else
      @animals << animal
      # Si no existe, lo agrega a la lista
    end

    persist
    # Guarda los cambios en el archivo JSON
  end

  def delete(id)
    @animals.reject! { |a| a.id == id }
    # Elimina el animal cuyo ID coincide con el proporcionado

    persist
    # Guarda la lista actualizada en el archivo
  end

  def next_id
    max_id = @animals.map(&:id).max || 0
    # Busca el ID más alto entre los animales actuales. Si no hay animales, usa 0

    max_id + 1
    # Retorna el siguiente ID disponible
  end

  private

  def load_animals
    JSON.parse(File.read(FILE_PATH)).map do |data|
      # Lee el archivo JSON, lo convierte a un arreglo de hashes

      Animal.new(**data.transform_keys(&:to_sym))
      # Convierte cada hash en un objeto Animal. Usa `transform_keys` para convertir strings a símbolos
    end
  end

  def persist
    File.write(FILE_PATH, JSON.pretty_generate(@animals.map(&:to_h)))
    # Convierte los objetos Animal a hashes y los guarda en el archivo con formato legible
  end
end

