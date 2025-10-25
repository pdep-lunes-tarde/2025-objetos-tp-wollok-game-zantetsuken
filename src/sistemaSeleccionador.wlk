import juego.*
import gameManager.*
import wollok.game.*
import mapas.*


object sistemaSeleccion {
    // Propiedades que se configurarán para cada selección
    var elementos = []
    var indiceActual = 0
    var posicionElemento = null
    var accionAlSeleccionar = null
    
    method iniciar(listaDeElementos, posElemento, accion) {
        // 1. Configurar las propiedades para esta selección
        elementos = listaDeElementos
        posicionElemento = posElemento
        accionAlSeleccionar = accion
        indiceActual = 0 // Reiniciamos el índice al empezar

        // 2. Limpiar inputs y visuales anteriores
        io.clear()

        // 3. Configurar los controles del teclado
        keyboard.right().onPressDo { self.siguiente() }
        keyboard.left().onPressDo { self.anterior() }
        keyboard.enter().onPressDo { self.seleccionar() }

        // 4. Mostrar el estado inicial
        self.mostrarElementoActual()
    }

    method elementoActual() = elementos.get(indiceActual)

    method mostrarElementoActual() {
        // Quitamos el elemento y la flecha anteriores de la pantalla
        game.removeVisual(self.elementoActual())

        // Actualizamos las posiciones del elemento y la flecha
        self.elementoActual().position(posicionElemento)

        // Añadimos el nuevo elemento y la flecha a la pantalla
        game.addVisual(self.elementoActual())
    }

    method siguiente() {
        // Lógica de bucle infinito hacia adelante
        indiceActual = (indiceActual + 1) % elementos.size()
        self.mostrarElementoActual()
    }

    method anterior() {
        // Lógica de bucle infinito hacia atrás
        indiceActual = (indiceActual - 1 + elementos.size()) % elementos.size()
        self.mostrarElementoActual()
    }

    method seleccionar() {
        // Ejecutamos la acción, pasándole el elemento seleccionado como parámetro
        accionAlSeleccionar.apply(self.elementoActual())
    }
}
