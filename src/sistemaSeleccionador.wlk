import juego.*
import gameManager.*
import wollok.game.*
import mapas.*


class SistemaDeSeleccion {
    var property elementos 
    var property indiceActual = 0
    
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

class SelectorDeHechiceros inherits SistemaDeSeleccion (){

    override method accionAlSeleccionar(hechicero) {
        configurador.hechiceroElegido(hechicero)
        configurador.mostrarSeleccionDeGuerrero()
    }
}

class SelectorDeGuerreros inherits SistemaDeSeleccion (){

    override method accionAlSeleccionar(guerrero) {
        configurador.guerreroElegido(guerrero)
        configurador.seleccionarEnemigosAleatorios()
    }
}