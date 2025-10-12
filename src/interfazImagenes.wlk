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
        const nuevaX = detenerMovimiento.aplicarA(posicionACorregir.x(), 3, 8)
        return new Position(x=nuevaX, y=posicion.y())
    }

    method activarSeleccion(){
        game.onCollideDo(self, {otro => otro.rivalPorSeleccionar()})
    }

    method activarSeleccionAtaque(){
        io.clear()
        keyboard.left().onPressDo{self.moverse(izquierda)}
        keyboard.right().onPressDo{self.moverse(derecha)}
        keyboard.z().onPressDo{self.activarPosicion()}
    }

    method activarPosicion(){
        if (posicion.x() == 3){
            turnero.personajeActivo().ataqueBasico()
        } else if (posicion.x() == 6) {
            turnero.personajeActivo().ataqueEspecial()
        } else {
            self.activarSeleccionAtaque()
        }
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
object detenerMovimiento {
    method aplicarA(numero, topeInferior, topeSuperior) {
        if(numero < topeInferior) {
            return topeInferior
        } else if(numero > topeSuperior) {
            return topeSuperior
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
object izquierda {
    method siguientePosicion(posicion) = posicion.left(3)
}

object derecha {
    method siguientePosicion(posicion) = posicion.right(3)
}
object primerPantalla {
    const property position = game.at(0,0)
    method image() = "primerPantalla.gif"
}