// mapas.wlk
import src.gameManager.*
import wollok.game.*
import turnero.*

// Creamos una CLASE base para las tarjetas de mapa
class TarjetaMapa {
    const property mapita
    const property mapa
    var property position = game.at(0, 0)
    
    // Aquí forzamos el tamaño. Queremos que ocupe 3x3 celdas.
    method width() = 3 
    method height() = 3
    method image() = mapita
}

// Ahora creamos las instancias de los mapas usando la nueva CLASE
// con los nombres de imagen actualizados
const mapaPuente = new TarjetaMapa(mapita = "mapa1r.png", mapa = "mapa3.png") 
const mapaCastillo = new TarjetaMapa(mapita = "mapa2r.png", mapa = "mapa1.png") 
const mapaGalaxy = new TarjetaMapa(mapita = "mapa3r.png", mapa = "mapa4.png") 
const mapaInfierno = new TarjetaMapa(mapita = "mapa4r.png", mapa = "mapa2.png")

// <<<--- NUEVOS OBJETOS PARA LA SELECCIÓN ---<<<

// Objeto que manejará la lógica de la selección circular
object selectorDeMapas {
    const property mapas = [mapaPuente, mapaCastillo, mapaGalaxy, mapaInfierno]
    var property indiceActual = 0
    
    method mapaActual() = mapas.get(indiceActual)
    
    method siguienteMapa() {
        // Usamos el módulo para crear el bucle infinito
        indiceActual = (indiceActual + 1) % mapas.size()
    }
    
    method anteriorMapa() {
        // Lógica para ir hacia atrás en el bucle
        indiceActual = (indiceActual - 1 + mapas.size()) % mapas.size()
    }
}

object fondoSeleccionMapa{
    var property image = "selectorDeMapas2.gif"
    var property position = game.at(0, 0)
}
object mapa{
    var property image = null
    var property position = game.at(0, 0)

    method establecerFondoMapa(imagen){
        self.image(imagen) // 1. Asigna la imagen recibida a la propiedad 'image'
        game.addVisual(self)  
    }
}

class visualGenerico{
    var property image = null
    var property position = game.at(0, 0)

    method mostrarConImagen(imagen){
        self.image(imagen) // 1. Asigna la imagen recibida a la propiedad 'image'
        game.addVisual(self)  
    }
}
