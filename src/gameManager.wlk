import src.gestorDeVida.*
import personajes.*
import otroEvento.*
import aliados.*
import interfazImagenes.*
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
object configurador{
	var property indicador = 2
	
	method ancho() {
		return 10
	}

	method alto() {
		return 10
	}

	method primerPantalla(){
		game.title("PrimerPantalla")
		game.height(self.alto())
		game.width(self.ancho())
		game.ground("suelo.png")
		game.addVisual(primerPantalla)

		keyboard.enter().onPressDo {game.clear()
			self.activarCombate()
		}
	}
    //Ahora mismo este metodo está inutilizado ya que de primer pantalla salta directamente a "activarCombate"
	method inicializar(){ 

    //	CONFIG	
	//	VISUALES
		game.addVisual(seleccionador)

	//	TECLADO

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
	}
	method activarAccionesPepita(){
		io.clear()
		const atacante = turnero.personajeActivo()
		keyboard.z().onPressDo {self.seleccionarRival({rival => atacante.ataqueBasico(rival)})}
		
		keyboard.x().onPressDo {self.seleccionarRival({rival => atacante.ataqueEspecial(rival)})}
	}

	method seleccionarRival(accion) {
		self.desactivarAcciones()
		keyboard.a().onPressDo {self.desactivarAcciones()
			accion.apply(turnero.enemigos().get(0))}
		keyboard.s().onPressDo {self.desactivarAcciones()
			accion.apply(turnero.enemigos().get(1))}
		keyboard.d().onPressDo {self.desactivarAcciones()
			accion.apply(turnero.enemigos().get(2))}
		keyboard.c().onPressDo {self.desactivarAcciones()
			self.activarAcciones()}
	}

	method desactivarAcciones(){
		io.clear()
	}
	method activarCriatura(criatura){
		game.addVisual(criatura)
	}
	method desactivarCriatura(criatura){
		game.removeVisual(criatura)
	}

	method mostrarPersonajes(){
		turnero.enemigos().forEach({enemigo => self.cambiarPosiciones(enemigo)})
		turnero.turnos().forEach({personaje => game.addVisual(personaje)})
		turnero.turnos().forEach({personaje => game.addVisual(personaje.medidorDeSalud())})
	}
	method cambiarPosiciones(enemigo){
		enemigo.position(game.at(7,indicador))
		indicador += 3
	}

	method jugar(){
		self.primerPantalla()
		game.start()
	}	
}