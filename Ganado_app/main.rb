puts "Iniciando aplicación..."
# Mensaje informativo al iniciar

require_relative 'app/models/animal'
require_relative 'app/repositories/animal_repository'
require_relative 'app/services/animal_service'
require_relative 'app/ui/main_window'
# Se cargan todos los archivos necesarios: modelo, repositorio, servicio y UI

repo = AnimalRepository.new
# Se instancia el repositorio (gestiona datos JSON)

service = AnimalService.new(repo)
# Se instancia el servicio y se le inyecta el repositorio

win = MainWindow.new(service)
# Se crea la ventana principal y se le inyecta el servicio

win.signal_connect("destroy") { Gtk.main_quit }
# Cuando se cierre la ventana, termina el ciclo principal de GTK

Gtk.main
# Inicia el bucle principal de eventos de GTK (muestra la ventana y espera interacciones)

