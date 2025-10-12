import src.gameManager.*
import wollok.game.*
import turnero.*
object seleccionador {
	var posicion = new Position(x=2, y=2)
	method image() = "seleccionadorCuadradoA.png"

	method position() = posicion

	method position(nuevaPosicion) {
        posicion = nuevaPosicion
    }
	
	method moverse(direccion) {
		const nuevaPosicion = direccion.siguientePosicion(posicion)

		posicion = self.posicionCorregida(nuevaPosicion)
	}

	method posicionCorregida(posicionACorregir) {
        const nuevaY = wraparound.aplicarA(posicionACorregir.y(), turnero.enemigos().get(0), turnero.enemigos().size())
        return new Position(x=posicion.x(), y=nuevaY)
    }

    method activarSeleccion(){
        game.onCollideDo(self, {otro => otro.rivalPorSeleccionar()})
    }
}

object wraparound {
    method aplicarA(numero, topeInferior, topeSuperior) {
        if(numero < topeInferior) {
            return topeSuperior
        } else if(numero > topeSuperior) {
            return topeInferior
        } else {
            return numero
        }
    }
}

object arriba {
    method siguientePosicion(posicion) = posicion.up(3)
}
object abajo {
    method siguientePosicion(posicion) = posicion.down(3)
}

object primerPantalla {
    const property position = game.at(0,0)
    method image() = "primerPantalla.gif"
}