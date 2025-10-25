import interfazImagenes.*
import wollok.game.*
import turnero.*
import gameManager.*

class MedidorDeVida {
	const usuario
	method position() = game.at(usuario.position().x(), usuario.position().y() - 1)

	method text() = "            " + usuario.salud() + " / " + usuario.saludMaxima()
	method textColor() = "14E507"
}
class Carta {
    const property nombre
    const property tipo               // "guerrero", "tanque", "hechicero"
    const property ataque             // valor de ataque (también usado como referencia)
    const property defensa            // valor de defensa
    var property energia              // energiaDeAtaque que se va consumiendo
    var property salud
    var property velocidad
    const property saludMaxima
    var property imagenSeleccionador
    const property costoBasico = 100
    const property costoEspecial = 300
    const property medidorDeSalud = new MedidorDeVida(usuario = self)

    // Ataque básico: consume energía y causa daño igual a ataque
    method ataqueBasico(rival) {
        if (!self.puedeAtacarBasico()) {
            game.say(self, "No tengo suficiente energia")
        }
        self.energia(self.energia() - self.costoBasico())
        self.animacionDeAtaque()
        logsFeed.agregarLog(self.nombre() + " realiza ataque basico")
        game.schedule(500, { rival.recibirAtaque(self.ataque()) })
    }

    // Ataque especial: por defecto más costoso y más daño (puede override)
    method ataqueEspecial(rival) {
        if (!self.puedeAtacarEspecial()) {
            game.say(self, "No tengo suficiente energia")
        }
        self.energia(self.energia() - self.costoEspecial())
        const dano = self.aEntero(self.ataque() * 1.8)
        self.animacionDeAtaque()
        logsFeed.agregarLog(self.nombre() + " realiza ataque especial")
        game.schedule(500, { rival.recibirAtaque(dano) })
    }

    method puedeAtacarBasico() = self.energia() >= self.costoBasico()
    method puedeAtacarEspecial() = self.energia() >= self.costoEspecial()

    method aEntero(numero) {
    return numero - (numero % 1)
    }

    // recibe ataque: aplica defensa y reduce salud
    method recibirAtaque(danio) {
        // Fórmula de mitigación: daño * 100 / (100 + defensa)
        const danoReal = self.aEntero(((danio * 100) / (100 + self.defensa())).max(0))
        self.daniar(danoReal)
        logsFeed.agregarLog(self.nombre() + " recibe " + danoReal + " de daño")
    }

    method daniar(danio) {
        self.recibioDanio()
        salud = (self.salud()-danio).max(0)
        if (self.salud() == 0) {
            self.matar()
            logsFeed.agregarLog(self.nombre() + " ha sido derrotado")
        }
    }

    method curar(cantidad){
        const vidaPotencial = self.salud() + cantidad
        if (vidaPotencial >= self.saludMaxima()){
            self.fullVida()
        } else {
            self.salud(vidaPotencial)
        }
    }

    method fullVida(){
        salud = self.saludMaxima()
    }

    method matar(){
        salud = 0
        game.removeVisual(self)
    }

    method empezarTurnoAliado() {
        // 1. Mostramos el menú de acciones para el jugador
        menuDeAcciones.mostrar()
        
        // 2. Configuramos los listeners para las teclas Z y X
        keyboard.z().onPressDo {
            configurador.desactivarAcciones()
            configurador.seleccionarRival({ rival => self.ataqueBasico(rival) })
        }
        keyboard.x().onPressDo { // <-- Tecla cambiada a 'X' para el ataque especial
            configurador.desactivarAcciones()
            configurador.seleccionarRival({ rival => self.ataqueEspecial(rival) })
        }
    }

    method empezarTurnoEnemigo() {
        const objetivo = turnero.aliados().anyOne()
		self.animacionDeAtaque()
		game.schedule(3000, {self.ataqueBasico(objetivo)}) 
		game.schedule(7000, {turnero.pasarTurno()})
    }

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

    method animacionDeAtaque(){
        
    }
}

// Definición de cartas como constantes compactas
object magoOscuro inherits Carta(
    nombre = "Mago Oscuro", 
    tipo = "hechicero", 
    ataque = 2500, 
    defensa = 2100, 
    energia = 2500, 
    velocidad = 10, 
    salud = 2500, 
    saludMaxima = 2500, 
    imagenSeleccionador = "MagoOscuroSeleccion.jpg")
{
	var property image = "MagoOscuro2.jpg" // Reemplaza con tu imagen
    var property position = game.at(4, 1)
}

object thiagurius inherits Carta(
    nombre = "Thiagurius", 
    tipo = "hechicero", 
    ataque = 5000, 
    defensa = 4000, 
    energia = 5000, 
    velocidad = 8, 
    salud = 5000, 
    saludMaxima = 5000,
    imagenSeleccionador = "ThiaguriusSeleccion.jpeg"
){
    var property image = "Thiagurius0.jpeg"
    var property position = game.at(4, 1)
}

object nemegis inherits Carta(
    nombre = "Nemegis", 
    tipo = "hechicero", 
    ataque = 3500, 
    defensa = 4000, 
    energia = 3500, 
    velocidad = 4, 
    salud = 3500, 
    saludMaxima = 3500,
    imagenSeleccionador = "nemegisSeleccion.jpeg"
){
    var property image = "nemegis0.jpeg"
    var property position = game.at(4, 1)
}

object nikxomus inherits Carta(
    nombre = "Nikxomus", 
    tipo = "hechicero", 
    ataque = 7000, 
    defensa = 2100, 
    energia = 7000, 
    velocidad = 5, 
    salud = 7000, 
    saludMaxima = 7000,
    imagenSeleccionador = "NikxomusSeleccion.jpeg"
){
    var property image = "Nikxomus0.jpeg"
    var property position = game.at(4, 1)
}

object santhurius inherits Carta(
    nombre = "Santhurius", 
    tipo = "guerrero", 
    ataque = 9999, 
    defensa = 4000, 
    energia = 9999, 
    velocidad = 6, 
    salud = 9999, 
    saludMaxima = 9999,
    imagenSeleccionador = "SanthuriusSeleccion.jpeg"
){
    var property image = "Santhurius0.jpeg"
    var property position = game.at(4, 1)
}

object soldadoBrilloNegro inherits Carta(
    nombre = "Soldado Brillo Negro", 
    tipo = "guerrero", 
    ataque = 3000, 
    defensa = 2500, 
    energia = 3000, 
    velocidad = 7, 
    salud = 3000, 
    saludMaxima = 3000,
    imagenSeleccionador = "soldadoBrilloNegroSeleccion.jpg"
){
    var property image = "soldadoBrilloNegro0.jpg"
    var property position = game.at(4, 1)
}

object malaika inherits Carta(
    nombre = "Malaika", 
    tipo = "guerrero", 
    ataque = 3700, 
    defensa = 1400, 
    energia = 3700, 
    velocidad = 7, 
    salud = 3700, 
    saludMaxima = 3700,
    imagenSeleccionador = "MalaikaSeleccion.jpeg"
){
    var property image = "Malaika0.jpeg"
    var property position = game.at(4, 1)
}

object halfdan inherits Carta(
    nombre = "Halfdan", 
    tipo = "guerrero", 
    ataque = 1300, 
    defensa = 200, 
    energia = 1300, 
    velocidad = 10, 
    salud = 1300, 
    saludMaxima = 1300,
    imagenSeleccionador = "halfdanSeleccion.jpeg"
){
    var property image = "halfdan0.jpeg"
    var property position = game.at(4, 1)
}