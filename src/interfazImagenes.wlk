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
    method image() = "pantallaDeInicio1.gif"
}

object feed {
    const property position = game.at(11, 0)
    method image() = "registroDelCombate.jpg"
}

class Log {
    var property palabras
    var property y
    const property x = 13

    var property position = game.at(x, y)

    method text() = palabras
    method textColor() = "543A17"

    method activar(){
        game.addVisual(self)
    } 

    method subir(){
        position = position.up(1)
        y = y + 1
    }
}
object logsFeed {
    const maxLogs = 5
    const logsEnPantalla = []

    method nuevaPosX(){
        return logsEnPantalla.last().x()
    }

    method nuevaPosY(){
        if(logsEnPantalla.size() == 0){
            return 6
        }else {return logsEnPantalla.last().y() - 1}
    }

    method subirTodos(){
        logsEnPantalla.forEach({log => 
        log.subir()
        })
    }

    method mostrarLog(log){
        log.activar()
    }

    method agregarLog(texto){
        if(logsEnPantalla.size() == maxLogs){
            const primerElemento = logsEnPantalla.first()
            game.removeVisual(primerElemento)
            logsEnPantalla.remove(primerElemento)

            self.subirTodos()
        }

        const log = new Log(palabras = texto, y = self.nuevaPosY())
        self.mostrarLog(log)
        logsEnPantalla.add(log)
    }

    method limpiarLogs(){
        logsEnPantalla.clear()
    }
}

object fondoSeleccionMapa{
    var property image = "selectorDeMapas2.gif"
    var property position = game.at(0, 0)
}

object fondoSeleccionHechicero {
    const property image = "primerPantallaSeleccion0.gif"
    const property position = game.at(0, 0)
}

object fondoSeleccionGuerrero {
    const property image = "segundaPantallaSeleccion0.gif"
    const property position = game.at(0, 0)
}

object fondoResumen {
    const property image = "fondoSeleccionGuerrero.gif"
    const property position = game.at(0, 0)
}

object fondoSeleccionRival {
    const property image = "pantallaCartasDelRival01.gif"
    const property position = game.at(0, 0)
}

object selectorDeObjetivo {
    var property position = game.at(0, 0)
    const property image = "marcoSeleccionador0.png" 
}

object teclaZ {
    const property image = "tecla_z0.png" 
    const property position = game.at(12, 1)
}

object textoAtaqueBasico {
    const property position = game.at(14, 1)
    method text() = "ATAQUE BASICO"
    method textColor() = "FFFFFF"
}

object teclaX {
    const property image = "tecla_x.png"
    const property position = game.at(12, 0)
}

object textoAtaqueEspecial {
    const property position = game.at(14, 0)
    method text() = "ATAQUE ESPECIAL"
    method textColor() = "FFFFFF"
}

object menuDeAcciones {
    const componentes = [teclaZ, textoAtaqueBasico, teclaX, textoAtaqueEspecial]

    method mostrar() {
        componentes.forEach({ componente => game.addVisual(componente) })
    }

    method ocultar() {
        componentes.forEach({ componente => game.removeVisual(componente) })
    }
}

object fondoInstrucciones{
    const property image = "instrucciones.gif"
    const property position = game.at(0, 0)
}