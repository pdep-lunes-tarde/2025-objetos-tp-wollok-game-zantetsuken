import seleccionador.*
import wollok.game.*
import pepita.*
import turnero.*
import gestorDeVida.*

object pepitaRival {
    const property velocidad = 2
	var property salud = 10
	var property position = new Position(x = 8,y = 9)
	method image() = "pepita1.png"
	const property medidorDeSalud = new MedidorDeVida(usuario = self)

	method moverse(direccion) {
		position = position.direccion(1)
	}

    method ataqueBasico(rival){
		rival.salud(rival.salud()-2)
		turnero.pasarTurno()
	}

	method empezarTurno() { //determina un rival de forma aleatoria, funciona correctamente
		const objetivo = turnero.aliados().anyOne()
		self.ataqueBasico(objetivo)
	}

	method fullVida() {
		self.salud(self.saludMaxima())
	}
	
	method daniar(danio) {
		self.salud(self.salud()-danio)
	}

	method curar(cantidad){
		gestorDeVida.curacionNormal(self, cantidad)
	}

	method saludMaxima() {
		return 10
	}
}

object zombie {
    const property velocidad = 1
	var property salud = 6
	var property position = new Position(x = 8, y = 10)
	method image() = "zombie.png"
	const property medidorDeSalud = new MedidorDeVida(usuario = self)	

	method moverse(direccion) {
		position = position.direccion(1)
	}
	
	method move(nuevaPosicion) {
		self.position(nuevaPosicion)
	}	

    method ataqueBasico(rival){
		rival.daniar(2)
		turnero.pasarTurno()
	}

	method empezarTurno() {
		const objetivo = turnero.aliados().anyOne()
		self.ataqueBasico(objetivo)
	}

	method fullVida() {
		self.salud(self.saludMaxima())
	}

	method daniar(danio) {
		self.salud(self.salud()-danio)
	}

	method curar(cantidad) {
		self.daniar(cantidad * 2)
	}
	
	method saludMaxima() {
		return 6
	}
}