import src.gameManager.*
import wollok.game.*

object seleccionador {
	var posicion = new Position(x=3, y=3)
	method image() = "seleccionadorCuadradoA.png"


	method position() {
        return posicion
    }
	method position(nuevaPosicion) {
        posicion = nuevaPosicion
    }
	
	method moverse(direccion) {
		const nuevaPosicion = direccion.siguientePosicion(posicion)

		posicion = self.posicionCorregida(nuevaPosicion)
	}

	method posicionCorregida(posicionACorregir) {
        const nuevaY = wraparound.aplicarA(posicionACorregir.y(), 3, 3)
        const nuevaX = wraparound.aplicarA(posicionACorregir.x(), 3, 7)

        return new Position(x=nuevaX, y=nuevaY)
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

object izquierda {
    method siguientePosicion(posicion) {
        return posicion.left(2)
    }
}
object derecha {
    method siguientePosicion(posicion) {
        return posicion.right(2)
    }
}