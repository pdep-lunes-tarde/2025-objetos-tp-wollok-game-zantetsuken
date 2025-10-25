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
            game.removeVisual(primerElemento) // lo saco de pantalla
            logsEnPantalla.remove(primerElemento) // lo saco de la lista

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

object soifongBackground{
    const property image = "soifongFondo2.jpg"
    const property position = game.at(0, 5)
}

object drGeroBackground{
    const property image = "maestroRoshiIsla.jpg"
    const property position = game.at(6, 0)
}

object hollowKnightBackground{
    const property image = "knightBackground.jpg"
    const property position = game.at(0, 0)
}

// ===== NUEVOS OBJETOS PARA LA PANTALLA DE SELECCIÓN DE HECHICERO =====

object fondoSeleccionHechicero {
    const property image = "primerPantallaSeleccion0.gif" // Puedes usar el mismo fondo romano o uno nuevo
    const property position = game.at(0, 0)
}

// ===== NUEVOS OBJETOS PARA LA PANTALLA DE SELECCIÓN DE GUERRERO =====

object fondoSeleccionGuerrero {
    const property image = "segundaPantallaSeleccion0.gif" // Puedes usar el mismo fondo romano o uno nuevo
    const property position = game.at(0, 0)
}



// ===== NUEVO OBJETO PARA LA PANTALLA DE RESUMEN DE SELECCIÓN =====
object fondoResumen {
    // Reemplaza "fondoResumen.gif" con el nombre de tu archivo de imagen cuando lo tengas
    const property image = "fondoSeleccionGuerrero.gif" // Placeholder
    const property position = game.at(0, 0)
}

// ===== NUEVO OBJETO PARA LA PANTALLA DE SELECCIÓN DE RIVAL =====
object fondoSeleccionRival {
    // Reemplaza "fondoRival.gif" con tu imagen cuando la tengas
    const property image = "pantallaCartasDelRival01.gif" // Placeholder
    const property position = game.at(0, 0)
}

object selectorDeObjetivo {
    var property position = game.at(0, 0)
    
    // IMPORTANTE: Reemplaza "selectorDeObjetivo.png" con la imagen de tu cursor/marco.
    // Puede ser una flecha, un marco brillante, etc.
    const property image = "marcoSeleccionador0.png" 
}

// ... (código existente en interfazImagenes.wlk) ...

// ===== NUEVO MENÚ DE ACCIONES VISUAL =====

// Componentes individuales del menú
object teclaZ {
    // IMPORTANTE: Asegúrate de tener una imagen llamada "tecla_z.png" en tu carpeta de assets.
    const property image = "tecla_z0.png" 
    const property position = game.at(12, 1)
}

object textoAtaqueBasico {
    const property position = game.at(14, 1) // Posición ajustada para quedar al lado de la tecla
    method text() = "ATAQUE BASICO"
    method textColor() = "FFFFFF" // Color blanco para resaltar
}

object teclaX {
    // IMPORTANTE: Asegúrate de tener una imagen llamada "tecla_x.png" en tu carpeta de assets.
    const property image = "tecla_x.png"
    const property position = game.at(12, 0)
}

object textoAtaqueEspecial {
    const property position = game.at(14, 0) // Posición ajustada para quedar al lado de la tecla
    method text() = "ATAQUE ESPECIAL"
    method textColor() = "FFFFFF" // Color blanco para resaltar
}

// Objeto contenedor que gestiona todo el menú
object menuDeAcciones {
    // Lista de todos los componentes visuales del menú
    const componentes = [teclaZ, textoAtaqueBasico, teclaX, textoAtaqueEspecial]

    // Método para mostrar el menú en pantalla
    method mostrar() {
        componentes.forEach({ componente => game.addVisual(componente) })
    }

    // Método para ocultar el menú de la pantalla
    method ocultar() {
        componentes.forEach({ componente => game.removeVisual(componente) })
    }
}

object fondoInstrucciones{
    const property image = "instrucciones.gif"
    const property position = game.at(0, 0)
}