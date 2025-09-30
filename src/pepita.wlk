import src.gestorDeVida.*
import src.gameManager.*
import seleccionador.*
import wollok.game.*
import enemigos.*
import turnero.*

class Aliado inherits Criatura {
	override method empezarTurno() {
		io.clear()
		keyboard.z().onPressDo {configurador.seleccionarRival({rival => self.ataqueBasico(rival)})}
	}

}

object pepita inherits Aliado (salud = 20, saludMaxima = 20, velocidad = 4, position = game.at(3,3)){
	
	override method image() = "pepita.png"
	
	// se encuentra hardcodeado para atacar siempre a pepitaRival, revisar el gameManager
	override method ataqueBasico(rival){
		rival.daniar(5)
		turnero.pasarTurno()
	}

	override method ataqueEspecial(rival) {
		rival.matar()
		turnero.pasarTurno()
	}
	override method empezarTurno(){
		super()
		keyboard.x().onPressDo {configurador.seleccionarRival({rival => self.ataqueEspecial(rival)})}
	}
}

object soifong inherits Aliado (salud = 15, saludMaxima = 15, velocidad = 2, position = game.at(3,5),
	medidorDeSalud = new MedidorDeVida(usuario = self)){
	var letalidad = 2
	override method image() = "pepita2.png"
	method letalidad() = letalidad
	method aumentarLetalidad(){
		letalidad += 2
	}
	override method ataqueBasico(rival){
		rival.daniar(letalidad)
		turnero.pasarTurno()
	}

	override method ataqueEspecial(rival) {
		self.aumentarLetalidad()
		turnero.pasarTurno()
	}

	override method empezarTurno(){
		super()
		keyboard.x().onPressDo {self.ataqueEspecial(self)}
	}

}