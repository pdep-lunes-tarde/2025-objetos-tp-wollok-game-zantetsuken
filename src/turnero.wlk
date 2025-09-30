import src.gameManager.*
import enemigos.*
import pepita.*

object turnero {
    var property turnos = []
    var property turnoActual = 0
    var property enemigos = [pepitaRival, zombie]
    var property aliados = [pepita, soifong]
    const property posicionesEnemigas = [8, 10]

    method empezarCombate(){
        turnoActual = 0
        aliados.forEach {aliado => self.agregarPersonaje(aliado)}
        enemigos.forEach {enemigo => self.agregarPersonaje(enemigo)}
        configurador.mostrarPersonajes()
        self.ordenarTurnos()
        self.correrTurno()
    }
    method agregarPersonaje(personaje){
        turnos.add(personaje)
    }
    method ordenarTurnos(){
        turnos = turnos.sortedBy({a, b => a.velocidad() > b.velocidad()})
    }

    method personajeActivo(){
        return self.turnos().get(self.turnoActual())
    }

    method correrTurno(){
        if(self.personajeActivo().salud() <= 0){
            self.pasarTurno()
        } else {
            self.personajeActivo().empezarTurno()
        }
    }

    method tamanioDelCombate(){
        return enemigos.size() + aliados.size() -1
    }

    method corroborarEstado(){
        if(enemigos.all({enemigo => enemigo.salud() <= 0})) {
            self.combateVictorioso()
        } else if (aliados.all({aliado => aliado.salud() <= 0})) {
            self.combateVictorioso()
        } else {
            self.correrTurno()
        }
    }

    method pasarTurno() {
        configurador.desactivarAcciones()
        if (turnoActual == self.tamanioDelCombate()){
        self.turnoActual(0)
        }else{
        self.turnoActual(turnoActual+1)    
        } 
        self.corroborarEstado()
    }

    method combateVictorioso() {
        turnos.forEach({personaje => personaje.fullVida()})
        self.turnos().clear()
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