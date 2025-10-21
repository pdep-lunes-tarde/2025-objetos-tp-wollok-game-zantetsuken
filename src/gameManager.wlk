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
            configurador.inicializarJuego()
        }
    }
}

object home {
	const property image = "fondo.jpg"
	const property position = game.at(0, 0)
}
object configurador{
	var property indicador = 2
	
	method ancho() = 15

	method alto() = 10

	method primerPantalla(){
		game.clear()
		game.addVisual(primerPantalla)
		keyboard.enter().onPressDo {self.activarCombate()}
	}
    //Ahora mismo este metodo está inutilizado ya que de primer pantalla salta directamente a "activarCombate"
	method inicializarJuego(){
		game.title("PrimerPantalla")
		game.height(self.alto())
		game.width(self.ancho())
		game.ground("suelo.png")
	}
	
	method inicializarSeleccionador(){ 

    //	CONFIG	
	//	VISUALES
		game.addVisual(seleccionador)

	//	TECLADO

		keyboard.r().onPressDo {io.removeEventHandler(['keypress',"ArrowRight"])}
		keyboard.e().onPressDo {io.removeEventHandler(['keypress',"ArrowLeft"])}
		keyboard.t().onPressDo {gameManager.mostrarMenu()}
		
		keyboard.up().onPressDo {seleccionador.moverse(arriba)}
        keyboard.down().onPressDo {seleccionador.moverse(abajo)}
		keyboard.enter().onPressDo {self.activarCombate()}
		seleccionador.activarSeleccionAtaque()

    }

	method activarCombate(){
		game.clear()
		game.addVisual(feed)
		turnero.empezarCombate()
	}
	// debe cambiarse para atacar a alguien que se determine

	method seleccionarRival(accion) {
		self.desactivarAcciones()
		var objetivo = null
		keyboard.a().onPressDo {objetivo = turnero.enemigos().get(0)
			self.corroborarAtaque(objetivo, accion)}
		keyboard.s().onPressDo {objetivo = turnero.enemigos().get(1)
			self.corroborarAtaque(objetivo, accion)}
		keyboard.d().onPressDo {objetivo = turnero.enemigos().get(2)
			self.corroborarAtaque(objetivo, accion)}
		keyboard.c().onPressDo {self.desactivarAcciones()
			turnero.personajeActivo().activarAcciones()}
	}
	method corroborarAtaque(objetivo, accion) {
        self.desactivarAcciones()
        if (objetivo.salud() == 0) {
			const atacante = turnero.personajeActivo()
			game.say(atacante, "No puedo atacar a un muerto")
			atacante.empezarTurno()
		} else if (objetivo.salud() > 0){
			accion.apply(objetivo)
			game.schedule(7000, {turnero.pasarTurno()}) 
		}
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
		self.reiniciarIndicador() //reinicia el contador para cambiar posiciones
		turnero.turnos().forEach({personaje => game.addVisual(personaje)})
		turnero.turnos().forEach({personaje => game.addVisual(personaje.medidorDeSalud())})
	}
	method cambiarPosiciones(enemigo){
		enemigo.position(game.at(7,indicador))
		indicador += 3
	}

	method reiniciarIndicador(){
		indicador = 2
	}

	method jugar(){
		self.inicializarJuego()
		self.primerPantalla()
		//self.inicializarSeleccionador()// modificado
		game.start()
	}	
}