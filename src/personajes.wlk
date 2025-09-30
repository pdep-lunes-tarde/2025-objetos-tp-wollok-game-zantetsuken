import seleccionador.*
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
	method image() 
	method salud() {
		return salud
	}
	
	method ataqueBasico(rival){
	}

	method ataqueEspecial(rival) {
	}

	method fullVida(){
		salud = self.saludMaxima()
	}

	method daniar(danio) {
		salud = (self.salud()-danio).max(0)
	}
	method curar(cantidad){
		gestorDeVida.curacionNormal(self, cantidad)
	}
	method matar(){
		salud = 0
	}
	method empezarTurno(){

	}
}
class Enemigo inherits Criatura (position= new Position(x = 7,y = 0)){ 
	override method empezarTurno() { //determina un rival de forma aleatoria, funciona correctamente
		const objetivo = turnero.aliados().anyOne()
		self.ataqueBasico(objetivo)
		turnero.pasarTurno()
	}
}
object pepitaRival inherits Enemigo(velocidad = 2, salud = 10, saludMaxima = 10) {
	override method image() = "pepita1.png"
    override method ataqueBasico(rival){
		rival.daniar(2)
	}
}

object zombie inherits Enemigo(velocidad = 1, salud = 6, saludMaxima = 6) {
	override method image() = "zombie.png"	

    override method ataqueBasico(rival){
		rival.daniar(4)
	}

	override method curar(cantidad) {
		self.daniar(cantidad * 2)
	}
}