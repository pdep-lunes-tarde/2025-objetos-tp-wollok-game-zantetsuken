import src.gestorDeVida.*
import src.gameManager.*
import personajes.*
import interfazImagenes.*
import wollok.game.*
import turnero.*

class Aliado inherits Criatura {
	override method empezarTurno() {
		keyboard.z().onPressDo {configurador.desactivarAcciones()
			configurador.seleccionarRival({rival => self.ataqueBasico(rival)
			game.schedule(7000, {turnero.pasarTurno()})})}
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
		game.schedule(3000, {rival.daniar(5)})
	}

	override method ataqueEspecial(rival) {
		self.animacionDeAtaque()
		game.schedule(3000, {rival.matar()})
	}
	override method empezarTurno(){
		super()
		keyboard.x().onPressDo {configurador.desactivarAcciones()
			configurador.seleccionarRival({rival => self.ataqueEspecial(rival)
			game.schedule(7000, {turnero.pasarTurno()})})}
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
		game.schedule(3000, {rival.daniar(letalidad)})
	}

	override method ataqueEspecial(rival) {
		self.aumentarLetalidad()
	}

	override method empezarTurno(){
		super()
		keyboard.x().onPressDo {configurador.desactivarAcciones()
			self.ataqueEspecial(self)
			game.schedule(7000, {turnero.pasarTurno()})}
	}
}

object soifongAtaque{
	method image() = "soifonAtaque.png"
	const property position = soifong.position()
}

object knightAtaque{
	method image() = "knightAtaque.png"
	const property position = knight.position()
}