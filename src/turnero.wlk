import src.interfazImagenes.*
import src.gameManager.*
import personajes.*

object zombieBackground{
    const property image = "zombieFondo.png"
    const property position = game.at(6, 5) 
}

object turnero {
    var property turnos = []
    var property turnoActual = 0
    var property equipo = null
    const property posicionesEnemigas = [8, 10]

    method empezarCombate(equipoNuevo){
        equipo = equipoNuevo
        turnoActual = 0
        equipo.cartasElegidas().forEach {personaje => self.agregarPersonaje(personaje)}
        configurador.mostrarPersonajes()
        self.ordenarTurnos()
        indicadorTurno.activar()
        self.correrTurno()
    }
    method agregarPersonaje(personaje){
        turnos.add(personaje)
    }
    method ordenarTurnos(){
        turnos = turnos.sortedBy({a, b => a.velocidad() > b.velocidad()})
    }

    method personajeActivo() = self.turnos().get(self.turnoActual())

    method aliadosVivos() = equipo.aliados().filter { aliado => aliado.salud() > 0 }

    method enemigosVivos() = equipo.enemigos().filter { enemigo => enemigo.salud() > 0 }

    method correrTurno(){
        if(self.personajeActivo().salud() == 0){
            self.pasarTurno()
        } else {
            if(equipo.aliados().contains(self.personajeActivo())){
                self.personajeActivo().empezarTurnoAliado()
            }else{self.personajeActivo().empezarTurnoEnemigo()}
        }
    }

    method tamanioDelCombate() = equipo.cartasElegidas().size() - 1

    method pasarTurno() {
        if (equipo.aliados().contains(self.personajeActivo())) {
            menuDeAcciones.ocultar()
        }

        if(equipo.aliados().all({personaje => personaje.salud() == 0}) || equipo.enemigos().all({personaje => personaje.salud() == 0})){
            game.removeVisual(indicadorTurno)
            self.combateVictorioso()
        } else {
            self.ciclarTurnos()
            indicadorTurno.actualizarFlecha()
            self.correrTurno()
        }
    }

    method ciclarTurnos(){
        if (turnoActual == self.tamanioDelCombate()){
            self.turnoActual(0)
        }else{
            self.turnoActual(turnoActual+1)    
        }
    }

    method combateVictorioso() {
        self.turnos().clear()
        logsFeed.limpiarLogs()
        configurador.primerPantalla()
    }
}

object activarAcciones {
    method inicializar(){
    const personajeActivo = turnero.turnos().get(turnero.turnoActual())
    }
    method ataqueNormal(rival){

    }

    method destruir(rival) { 
    }
}

object indicadorTurno {
    const property position = game.at(5, 5)
    var property image = "flechaAD0.png"
    
    const flechaAbajoIzquierda = "flechaAI0.png"
    const flechaArribaIzquierda = "flechaARI0.png"
    const flechaAbajoDerecha = "flechaAD0.png"
    const flechaArribaDerecha = "flechaARD0.png"
    
    method activar() {
        game.addVisual(self)
        self.actualizarFlecha()
    }
    
    method actualizarFlecha() {
        
        if (self.estaAbajoIzquierda()) {
            image = flechaAbajoIzquierda
        } else if (self.estaArribaIzquierda()) {
            image = flechaArribaIzquierda
        } else if (self.estaAbajoDerecha()) {
            image = flechaAbajoDerecha
        } else if (self.estaArribaDerecha()) {
            image = flechaArribaDerecha
        }
        
        game.removeVisual(self)
        game.addVisual(self)
    }

    method estaAbajoIzquierda() {
        return (turnero.personajeActivo().position().x() == 1 && turnero.personajeActivo().position().y() == 1)
    }

    method estaArribaIzquierda() {
        return (turnero.personajeActivo().position().x() == 1 && turnero.personajeActivo().position().y() == 6)
    }

    method estaAbajoDerecha() {
        return (turnero.personajeActivo().position().x() == 7 && turnero.personajeActivo().position().y() == 1)
    }

    method estaArribaDerecha() {
        return (turnero.personajeActivo().position().x() == 7 && turnero.personajeActivo().position().y() == 6)
    }
}
   