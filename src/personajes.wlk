import interfazImagenes.*
import wollok.game.*
import aliados.*
import turnero.*
import gestorDeVida.*
import gameManager.*

class Criatura {
	var salud
	const property saludMaxima
    const property velocidad 
	var property position
	const property medidorDeSalud = new MedidorDeVida(usuario = self)
	var property imagen
	
	method salud() {
		return salud
	}
	
	method ataqueBasico(rival)

	method ataqueEspecial(rival)

	method fullVida(){
		salud = self.saludMaxima()
	}

	method daniar(danio) {
		self.recibioDanio()
		salud = (self.salud()-danio).max(0)
	}
	method curar(cantidad){
		gestorDeVida.curacionNormal(self, cantidad)
	}
	method matar(){
		salud = 0
	}
	method empezarTurno()
	method recibioDanio(){
		game.removeVisual(self)
		game.onTick(1000, "apagarAnimacion", {
			game.addVisual(self)
		})
		game.schedule(500, {game.onTick(1000, "prenderAnimacion", {
			game.removeVisual(self)
		})})
		game.schedule(3250, {
			game.removeTickEvent("apagarAnimacion")
			game.removeTickEvent("prenderAnimacion")
			})
	}
	method image() = imagen
	method cambiarImagenAtaque()
	method cambiarImagenNormal()

	method animacionDeAtaque(){
		self.cambiarImagenAtaque()
		game.schedule(2000, {self.cambiarImagenNormal()})
	}
}
class Enemigo inherits Criatura (position = game.at(7,0)){ 
	override method empezarTurno() { //determina un rival de forma aleatoria, funciona correctamente
		const objetivo = turnero.aliados().anyOne()
		self.animacionDeAtaque()
		game.schedule(3000, {self.ataqueBasico(objetivo)})
		game.schedule(7000, {turnero.pasarTurno()})
	}
}
object pepita inherits Enemigo(velocidad = 2, salud = 10, saludMaxima = 10, imagen = "pepita.png") {
	override method cambiarImagenAtaque(){
		imagen = "pepitaCanchera.png"
	}
	override method cambiarImagenNormal(){
		imagen = "pepita.png"
	}
    override method ataqueBasico(rival){
		rival.daniar(2)
	}
	override method ataqueEspecial(rival){

	}
}

object zombie inherits Enemigo(velocidad = 1, salud = 6, saludMaxima = 6, imagen = "zombie.png") {
		override method cambiarImagenAtaque(){
		imagen = "zombieAtaque.png"
	}
	override method cambiarImagenNormal(){
		imagen = "zombie.png"
	}
    override method ataqueBasico(rival){
		rival.daniar(4)
	}

	override method curar(cantidad) {
		self.daniar(cantidad * 2)
	}
	override method ataqueEspecial(rival){
		
	}
}