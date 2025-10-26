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
    const property tipo
    const property ataque
    const property defensa
    var property energia
    var property salud
    var property velocidad
    const property saludMaxima
    var property imagenBatalla
    var property imagenSeleccionador
    const property costoBasico = 100
    const property costoEspecial = 300
    const property medidorDeSalud = new MedidorDeVida(usuario = self)

    method ataqueBasico(rival) {
        energia = energia - costoBasico
        //console.println(energia)
        self.animacionDeAtaque()
        logsFeed.agregarLog(self.nombre() + " realiza ataque basico")
        game.schedule(500, { rival.recibirAtaque(self.ataque()) })
    }

    method ataqueEspecial(rival) {
        if (!self.puedeAtacarEspecial()) {
            game.say(self, "No tengo suficiente energia para un ataque especial")
            self.ataqueBasico(rival)
        }
        energia = energia - costoEspecial
        //console.println(energia)
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

    method recibirAtaque(danio) {
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
        game.removeVisual(self.medidorDeSalud())
        game.removeVisual(self)
    }

    method empezarTurnoAliado() {
        menuDeAcciones.mostrar()
        
        keyboard.z().onPressDo {
            configurador.desactivarAcciones()
            configurador.seleccionarRival({ rival => self.ataqueBasico(rival) })
        }
        keyboard.x().onPressDo {
            configurador.desactivarAcciones()
            configurador.seleccionarRival({ rival => self.ataqueEspecial(rival) })
        }
    }

    method empezarTurnoEnemigo() {
        const objetivo = turnero.aliadosVivos().anyOne()
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

object magoOscuro inherits Carta(
    nombre = "Mago Oscuro", 
    tipo = "hechicero", 
    ataque = 2500, 
    defensa = 2100, 
    energia = 400, 
    velocidad = 10, 
    salud = 1000, 
    saludMaxima = 1000, 
    imagenBatalla = "MagoOscuro2.jpg",
    imagenSeleccionador = "MagoOscuroSeleccion.jpg")
{
    var property image = imagenBatalla
    var property position = game.at(4, 1)
}

object thiagurius inherits Carta(
    nombre = "Thiagurius", 
    tipo = "hechicero", 
    ataque = 5000, 
    defensa = 4000, 
    energia = 5000, 
    velocidad = 8, 
    salud = 1500, 
    saludMaxima = 1500,
    imagenBatalla = "Thiagurius0.jpeg",
    imagenSeleccionador = "ThiaguriusSeleccion.jpeg"
){
    var property image = imagenBatalla
    var property position = game.at(4, 1)
}

object nemegis inherits Carta(
    nombre = "Nemegis", 
    tipo = "hechicero", 
    ataque = 3500, 
    defensa = 4000, 
    energia = 3500, 
    velocidad = 4, 
    salud = 1500, 
    saludMaxima = 1500,
    imagenBatalla = "nemegis0.jpeg",
    imagenSeleccionador = "nemegisSeleccion.jpeg"
){
    var property image = imagenBatalla
    var property position = game.at(4, 1)
}

object nikxomus inherits Carta(
    nombre = "Nikxomus", 
    tipo = "hechicero", 
    ataque = 7000, 
    defensa = 2100, 
    energia = 7000, 
    velocidad = 5, 
    salud = 1500, 
    saludMaxima = 1500,
    imagenBatalla = "Nikxomus0.jpeg",
    imagenSeleccionador = "NikxomusSeleccion.jpeg"
){
    var property image = imagenBatalla
    var property position = game.at(4, 1)
}

object santhurius inherits Carta(
    nombre = "Santhurius", 
    tipo = "guerrero", 
    ataque = 9999, 
    defensa = 4000, 
    energia = 9999, 
    velocidad = 6, 
    salud = 1500, 
    saludMaxima = 1500,
    imagenBatalla = "Santhurius0.jpeg",
    imagenSeleccionador = "SanthuriusSeleccion.jpeg"
){
    var property image = imagenBatalla
    var property position = game.at(4, 1)
}

object soldadoBrilloNegro inherits Carta(
    nombre = "Soldado Brillo Negro", 
    tipo = "guerrero", 
    ataque = 3000, 
    defensa = 2500, 
    energia = 3000, 
    velocidad = 7, 
    salud = 1200, 
    saludMaxima = 1200,
    imagenBatalla = "soldadoBrilloNegro0.jpg",
    imagenSeleccionador = "soldadoBrilloNegroSeleccion.jpg"
){
    var property image = imagenBatalla
    var property position = game.at(4, 1)
}

object malaika inherits Carta(
    nombre = "Malaika", 
    tipo = "guerrero", 
    ataque = 3700, 
    defensa = 1400, 
    energia = 3700, 
    velocidad = 7, 
    salud = 1100, 
    saludMaxima = 1100,
    imagenBatalla = "Malaika0.jpeg",
    imagenSeleccionador = "MalaikaSeleccion.jpeg"
){
    var property image = imagenBatalla
    var property position = game.at(4, 1)
}

object halfdan inherits Carta(
    nombre = "Halfdan", 
    tipo = "guerrero", 
    ataque = 1300, 
    defensa = 200, 
    energia = 1300, 
    velocidad = 10, 
    salud = 500, 
    saludMaxima = 500,
    imagenBatalla = "halfdan0.jpeg",
    imagenSeleccionador = "halfdanSeleccion.jpeg"
){
    var property image = imagenBatalla
    var property position = game.at(4, 1)
}