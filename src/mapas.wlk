// mapas.wlk
import src.gameManager.*
import wollok.game.*
import sistemaSeleccionador.*
import turnero.*

class TarjetaMapa {
    const property mapita
    const property mapa
    var property position = game.at(2, 1)
    
    method image() = mapita
}

const mapa1 = new TarjetaMapa(mapita = "mapa1r.png", mapa = "mapa3.png") 
const mapa2 = new TarjetaMapa(mapita = "mapa2r.png", mapa = "mapa1.png") 
const mapa3 = new TarjetaMapa(mapita = "mapa3r.png", mapa = "mapa4.png") 
const mapa4 = new TarjetaMapa(mapita = "mapa4r.png", mapa = "mapa2.png")

object selectorDeMapas inherits SistemaDeSeleccion(elementos = [mapa1, mapa2, mapa3, mapa4]){
    override method accionAlSeleccionar(mapaElegido) {
        configurador.mapaElegido(mapaElegido.mapa())
        configurador.mostrarSeleccionDeHechicero()
    }
}

object mapa{
    var property image = null
    var property position = game.at(0, 0)

    method establecerFondoMapa(imagen){
        self.image(imagen) 
        game.addVisual(self)  
    }
}

