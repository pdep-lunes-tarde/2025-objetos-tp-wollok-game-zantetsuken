import src.gameManager.*
import wollok.game.*
import turnero.*

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