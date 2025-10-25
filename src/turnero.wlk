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
    var property enemigos = []
    var property aliados = []
    const property posicionesEnemigas = [8, 10]

    method empezarCombate(cartasElegidas, cartasDelRival){
        aliados = cartasElegidas
        enemigos = cartasDelRival
        turnoActual = 0
        aliados.forEach {aliado => self.agregarPersonaje(aliado)}
        enemigos.forEach {enemigo => self.agregarPersonaje(enemigo)}
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

    method correrTurno(){
        if(self.personajeActivo().salud() == 0){
            self.pasarTurno()
        } else {
            if(turnero.aliados().contains(self.personajeActivo())){
                self.personajeActivo().empezarTurnoAliado()
            }else{self.personajeActivo().empezarTurnoEnemigo()}
        }
    }

    method tamanioDelCombate() = enemigos.size() + aliados.size() -1

    method pasarTurno() {
        if(enemigos.all({enemigo => enemigo.salud() == 0})) {
            game.removeVisual(indicadorTurno)
            self.combateVictorioso()
        } else if (aliados.all({aliado => aliado.salud() == 0})) {
            self.combateVictorioso()//atentos aca
            game.removeVisual(indicadorTurno)
        } else {
            self.ciclarTurnos()
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
        turnos.forEach({personaje => personaje.fullVida()})
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
	method position() = game.at(14,0)
	
	method text() = "Le toca el turno a " + turnero.personajeActivo()
    method textColor() = "FFFFFF" 
	method activar(){
		game.addVisual(self)
	}
}