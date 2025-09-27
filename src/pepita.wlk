import src.gestorDeVida.*
import src.gameManager.*
import seleccionador.*
import wollok.game.*
import enemigos.*
import turnero.*

object pepita {
	var property salud = 20
    const property velocidad = 4
	var property position = game.at(3,3)
	method image() = "pepita.png"
	const property medidorDeSalud = new MedidorDeVida(usuario = self)

	method moverse(direccion) {
		position = position.direccion(1)
	}
	
	// se encuentra hardcodeado para atacar siempre a pepitaRival, revisar el gameManager
	method ataqueBasico(rival){
		rival.daniar(5)
		turnero.pasarTurno()
	}	

	method ataqueEspecial(rival) {
		rival.salud(0)
		turnero.pasarTurno()
	}

	method empezarTurno() {
		configurador.activarAcciones()
	}

	method fullVida(){
		self.salud(self.saludMaxima())
	}

	method daniar(danio) {
		self.salud(self.salud()-danio)
	}
	method saludMaxima() {
		return 20
	}
	method curar(cantidad){
		gestorDeVida.curacionNormal(self, cantidad)
	}
}
