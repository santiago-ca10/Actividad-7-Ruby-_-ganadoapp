class AnimalService
  def initialize(repository)
    @repository = repository
    # Se inyecta una instancia del repositorio de animales.
    # Permite desacoplar la lógica de negocio del acceso a datos.
  end

  def create_animal(name, birth_date, history)
    id = @repository.next_id
    # Solicita al repositorio el próximo ID disponible para un nuevo animal

    animal = Animal.new(id: id, name: name, birth_date: birth_date, history: history)
    # Crea una nueva instancia de Animal con los datos proporcionados

    @repository.save(animal)
    # Guarda el nuevo animal en el repositorio
  end

  def update_animal(animal)
    @repository.save(animal)
    # Guarda el animal actualizado. El repositorio sabrá si debe reemplazar uno existente
  end

  def delete_animal(id)
    @repository.delete(id)
    # Elimina el animal con el ID indicado
  end

  def get_animals
    @repository.all
    # Devuelve todos los animales almacenados
  end
end

