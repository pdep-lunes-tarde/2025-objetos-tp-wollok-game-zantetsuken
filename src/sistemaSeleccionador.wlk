import juego.*
import gameManager.*
import wollok.game.*
import mapas.*


class SistemaDeSeleccion {
    var property elementos 
    var property indiceActual = 0
    var property posicionElemento
    
    method iniciar() {
        indiceActual = 0

        io.clear()

        keyboard.right().onPressDo { self.siguiente() }
        keyboard.left().onPressDo { self.anterior() }
        keyboard.enter().onPressDo { self.seleccionar() }

        self.mostrarElementoActual()
    }

    method elementoActual() = elementos.get(indiceActual)

    method mostrarElementoActual() {
        game.removeVisual(self.elementoActual())

        self.elementoActual().position(posicionElemento)

        game.addVisual(self.elementoActual())
    }

    method siguiente() {
        indiceActual = (indiceActual + 1) % elementos.size()
        self.mostrarElementoActual()
    }

    method anterior() {
        indiceActual = (indiceActual - 1 + elementos.size()) % elementos.size()
        self.mostrarElementoActual()
    }

    method seleccionar() {
        self.accionAlSeleccionar(self.elementoActual())
    }

    method accionAlSeleccionar(elemento)
}

object selectorDeHechiceros inherits SistemaDeSeleccion (elementos = configurador.opcionesDeHechicero(), posicionElemento = game.at(5, 1)){
    override method accionAlSeleccionar(hechicero) {
        configurador.hechiceroElegido(hechicero)
        configurador.mostrarSeleccionDeGuerrero()
    }
}

object selectorDeGuerreros inherits SistemaDeSeleccion (elementos = configurador.opcionesDeGuerrero(), posicionElemento = game.at(5, 1)){
    override method accionAlSeleccionar(guerrero) {
        configurador.guerreroElegido(guerrero)
        configurador.seleccionarEnemigosAleatorios()
    }
}