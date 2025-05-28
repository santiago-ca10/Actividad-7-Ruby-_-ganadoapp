require 'gtk3'
# Se importa la biblioteca GTK3 para construir la interfaz gráfica

class MainWindow < Gtk::Window
  def initialize(service)
    super()
    set_title("Gestión de Ganado")
    set_default_size(600, 400)
    set_border_width(10)
    # Configuración inicial de la ventana: título, tamaño y bordes

    @service = service
    # Se guarda el servicio que maneja la lógica de negocio

    @list_store = Gtk::ListStore.new(Integer, String, String, String)
    # Modelo de datos para la tabla: ID, Nombre, Fecha de nacimiento, Historial

    tree_view = Gtk::TreeView.new(@list_store)
    # Se crea la vista en forma de tabla (tree view)

    %w[ID Nombre Nacimiento Historial].each_with_index do |title, index|
      renderer = Gtk::CellRendererText.new
      renderer.editable = index != 0
      # Solo las columnas distintas de ID son editables

      renderer.wrap_width = 300 if index == 3
      # El historial puede ser largo, se aplica ajuste de texto

      renderer.signal_connect("edited") do |_, path, text|
        update_cell(path, index, text)
      end
      # Al editar una celda, se llama al método que actualiza los datos

      column = Gtk::TreeViewColumn.new(title, renderer, text: index)
      tree_view.append_column(column)
      # Se crea y agrega cada columna al tree_view
    end

    vbox = Gtk::Box.new(:vertical, 10)
    vbox.pack_start(tree_view, expand: true, fill: true, padding: 5)
    # Se agrega la tabla a una caja vertical

    add_button = Gtk::Button.new(label: "Agregar Animal")
    add_button.signal_connect("clicked") { add_animal_dialog }
    # Botón para agregar un nuevo animal

    delete_button = Gtk::Button.new(label: "Eliminar Seleccionado")
    delete_button.signal_connect("clicked") do
      selection = tree_view.selection
      if iter = selection.selected
        id = iter[0]
        @service.delete_animal(id)
        load_animals
      end
    end
    # Botón para eliminar el animal seleccionado en la tabla

    buttons_box = Gtk::Box.new(:horizontal, 10)
    buttons_box.pack_start(add_button, expand: true, fill: true, padding: 5)
    buttons_box.pack_start(delete_button, expand: true, fill: true, padding: 5)
    # Caja horizontal con los botones de agregar y eliminar

    vbox.pack_start(buttons_box, expand: false, fill: false, padding: 5)
    # Se agregan los botones debajo de la tabla

    add(vbox)
    load_animals
    show_all
    # Se carga todo en la ventana y se muestra
  end

  def load_animals
    @list_store.clear
    @service.get_animals.each do |animal|
      iter = @list_store.append
      iter[0] = animal.id
      iter[1] = animal.name
      iter[2] = animal.birth_date.to_s
      iter[3] = animal.history
    end
    # Carga todos los animales desde el servicio y los muestra en la tabla
  end

  def update_cell(path, column_index, text)
    iter = @list_store.get_iter(path)
    id = iter[0]
    animal = @service.get_animals.find { |a| a.id == id }

    case column_index
    when 1
      animal.name = text.strip
    when 2
      if valid_date?(text.strip)
        animal.birth_date = Date.parse(text.strip)
      else
        show_error("La fecha debe tener el formato YYYY-MM-DD.")
        return
      end
    when 3
      animal.history = text.strip
    end

    @service.update_animal(animal)
    load_animals
    # Al editar una celda, actualiza el animal correspondiente y recarga la tabla
  end

  def add_animal_dialog
    dialog = Gtk::Dialog.new(title: "Nuevo Animal", parent: self,
                             flags: :modal, buttons: [
                               ["Cancelar", :cancel],
                               ["Agregar", :ok]
                             ])
    # Crea una ventana emergente para agregar un nuevo animal

    name_entry = Gtk::Entry.new
    birth_entry = Gtk::Entry.new
    history_entry = Gtk::Entry.new

    box = dialog.content_area
    box.add(Gtk::Label.new("Nombre (opcional)"))
    box.add(name_entry)
    box.add(Gtk::Label.new("Fecha nacimiento (YYYY-MM-DD) *"))
    box.add(birth_entry)
    box.add(Gtk::Label.new("Historial (opcional)"))
    box.add(history_entry)
    dialog.show_all

    if dialog.run == :ok
      name = name_entry.text.strip
      birth = birth_entry.text.strip
      history = history_entry.text.strip

      if birth.empty?
        show_error("La fecha de nacimiento es obligatoria.")
      elsif !valid_date?(birth)
        show_error("La fecha debe tener el formato YYYY-MM-DD.")
      else
        @service.create_animal(name, birth, history)
        load_animals
      end
    end

    dialog.destroy
    # Si el usuario acepta, valida y crea el nuevo animal; luego destruye la ventana
  end

  def show_error(message)
    error_dialog = Gtk::MessageDialog.new(
      parent: self,
      flags: :modal,
      type: :error,
      buttons_type: :close,
      message: message
    )
    error_dialog.run
    error_dialog.destroy
    # Muestra un mensaje de error al usuario
  end

  def valid_date?(str)
    Date.iso8601(str)
    true
  rescue ArgumentError
    false
    # Verifica si una fecha es válida con el formato ISO (YYYY-MM-DD)
  end
end
