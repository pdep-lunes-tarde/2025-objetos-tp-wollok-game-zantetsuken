import src.gameManager.*
import wollok.game.*
import turnero.*



// Creamos una CLASE base para las tarjetas de mapa
class TarjetaMapa {
    const property imagen
    var property position = game.at(0, 0)
    
    // Aquí forzamos el tamaño. Queremos que ocupe 3x3 celdas.
    method width() = 3 
    method height() = 3
    method image() = imagen
}

// Ahora creamos las instancias de los mapas usando la nueva CLASE
// (Ya no son los objetos grandes de antes, son tarjetas de 3x3 celdas)

const mapaPuente = new TarjetaMapa(imagen = "puente.jpg") 
const mapaCastillo = new TarjetaMapa(imagen = "castillo.jpg") 
const mapaGalaxy = new TarjetaMapa(imagen = "galaxia.jpg") 
const mapaInfierno= new TarjetaMapa(imagen = "inferno.jpg")

object fondoSeleccionMapa {
    const property image = "fondoBack.jpg"
    const property position = game.at(0, 0) 
}
