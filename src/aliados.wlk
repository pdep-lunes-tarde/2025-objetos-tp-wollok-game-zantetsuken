import src.gameManager.*
import personajes.*
import interfazImagenes.*
import wollok.game.*
import turnero.*

class Aliado inherits Criatura {
	override method empezarTurno() {
		keyboard.z().onPressDo {configurador.desactivarAcciones()
			configurador.seleccionarRival({rival => self.ataqueBasico(rival)})
		}
	}

}

object knight inherits Aliado (salud = 20, saludMaxima = 20, velocidad = 4, position = game.at(2,2), imagen = "knight.png"){
	
	override method image() = imagen
	override method cambiarImagenAtaque(){
		imagen = "knightAtaque.png"
	}
	override method cambiarImagenNormal(){
		imagen = "knight.png"
	}
	
	override method ataqueBasico(rival){
		self.animacionDeAtaque()
		game.schedule(1000, {rival.daniar(5)}) //era 3000ms
		logsFeed.agregarLog("Knight ataque basico a: " + rival)
	}

	override method ataqueEspecial(rival) {
		self.animacionDeAtaque()
		game.schedule(1000, {rival.matar()}) // era 3000ms
		logsFeed.agregarLog("Knight ha matado a: " + rival)
	}
	override method empezarTurno(){
		super()
		keyboard.x().onPressDo {
			configurador.seleccionarRival({rival => self.ataqueEspecial(rival)})}
		keyboard.c().onPressDo {
			configurador.seleccionarRival({rival => self.ataqueBasico(rival)})}
	}
}

object soifong inherits Aliado (salud = 15, saludMaxima = 15, velocidad = 2, position = game.at(2,5), imagen = "soifong.png"){
	var letalidad = 2
	method letalidad() = letalidad
	method aumentarLetalidad(){
		letalidad += 2
	}
	override method image() = imagen
	override method cambiarImagenAtaque(){
		imagen = "soifongAtaque.png"
	}
	override method cambiarImagenNormal(){
		imagen = "soifong.png"
	}
	override method ataqueBasico(rival){
		self.animacionDeAtaque()
		game.schedule(1000, {rival.daniar(letalidad)}) //era 3000ms
		logsFeed.agregarLog("Soifong ha hecho " + letalidad + " de daño a " + rival)
	}

	override method ataqueEspecial(rival) {
		self.aumentarLetalidad()
	}

	override method empezarTurno(){
		super()
		keyboard.x().onPressDo {configurador.desactivarAcciones()
			self.ataqueEspecial(self)
			game.schedule(1000, {turnero.pasarTurno()}) //era 7000ms
			logsFeed.agregarLog("Soifong aumentó su letalidad en 2")
		}
		keyboard.c().onPressDo {
			configurador.seleccionarRival({rival => self.ataqueBasico(rival)})
		}
	}
}