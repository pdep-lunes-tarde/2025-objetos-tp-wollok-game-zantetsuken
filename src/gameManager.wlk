import src.gestorDeVida.*
import enemigos.*
import otroEvento.*
import pepita.*
import seleccionador.*
import wollok.game.*
import turnero.*
object gameManager {

    method mostrarMenu() {
        game.clear()
        game.addVisual(home)
    
        keyboard.t().onPressDo {
 			manager.iniciarJuego()
 		}

        keyboard.z().onPressDo {
            configurador.inicializar()
        }
    }
}

object home {
	const property image = "fondo.jpg"
	const property position = game.at(0, 0)
}
object juegoRpg {
	

}
object configurador{
	var property indicador = 3
	
	method ancho() {
		return 10
	}

	method alto() {
		return 10
	}

	method primerPantalla(){
		game.title("Pepita")
		game.height(self.alto())
		game.width(self.ancho())
		game.ground("suelo.png")

		keyboard.enter().onPressDo {game.clear()
			self.inicializar()
		}
	}
    method inicializar(){

    //	CONFIG	
	//	VISUALES
		game.addVisual(pepita)
		game.addVisual(seleccionador)

	//	TECLADO
		keyboard.h().onPressDo { game.say(pepita, "Hola chiques!") }

		keyboard.r().onPressDo {io.removeEventHandler(['keypress',"ArrowRight"])}
		keyboard.e().onPressDo {io.removeEventHandler(['keypress',"ArrowLeft"])}
		keyboard.t().onPressDo {gameManager.mostrarMenu()}
		
		keyboard.right().onPressDo {seleccionador.moverse(derecha)}
        keyboard.left().onPressDo {seleccionador.moverse(izquierda)}
		keyboard.enter().onPressDo {self.activarCombate()}

    }

	method activarCombate(){
		game.clear()
		turnero.empezarCombate()
	}
	// debe cambiarse para atacar a alguien que se determine
	method activarAcciones(){
		keyboard.z().onPressDo {turnero.personajeActivo().ataqueBasico(pepitaRival)
			self.desactivarAcciones()}
		
		keyboard.x().onPressDo {turnero.personajeActivo().ataqueEspecial(pepitaRival)}
	}

	method desactivarAcciones(){
		io.clear()
	}

	method desactivarEnemigo(enemigo){
		game.removeVisual(enemigo)
	}

	method mostrarPersonajes(){
		turnero.enemigos().forEach({enemigo => self.cambiarPosiciones(enemigo)})
		turnero.turnos().forEach({personaje => game.addVisual(personaje)})
		turnero.turnos().forEach({personaje => game.addVisual(personaje.medidorDeSalud())})
	}
	method cambiarPosiciones(enemigo){
		enemigo.position(new Position(x = 8, y = indicador))
		indicador += 3
	}

	method jugar(){
		self.primerPantalla()
		game.start()
	}
}