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

    method enemigosVivos() = self.enemigos().filter { enemigo => enemigo.salud() > 0 }

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
        // <<<--- LÓGICA PARA OCULTAR EL MENÚ AL FINALIZAR TURNO ---<<<
         if (turnero.aliados().contains(self.personajeActivo())) {
            menuDeAcciones.ocultar()
        }

        if(enemigos.all({enemigo => enemigo.salud() == 0})) {
            game.removeVisual(indicadorTurno)
            self.combateVictorioso()
        } else if (aliados.all({aliado => aliado.salud() == 0})) {
            self.combateVictorioso() //atentos aca
            game.removeVisual(indicadorTurno)
        } else {
            self.ciclarTurnos()
            // Actualizar el indicador de turno
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
    const property position = game.at(5, 5)
    var property image = "flechaAD0.png" // Imagen por defecto
    
    // Imágenes de flechas para cada dirección
    const flechaAbajoIzquierda = "flechaAI0.png"
    const flechaArribaIzquierda = "flechaARI0.png"
    const flechaAbajoDerecha = "flechaAD0.png"
    const flechaArribaDerecha = "flechaARD0.png"
    
    method activar() {
        game.addVisual(self)
        self.actualizarFlecha()
    }
    
    method actualizarFlecha() {
        const personajeActivo = turnero.personajeActivo()
        const posicion = personajeActivo.position()
        
        // Determinar qué flecha mostrar según la posición del personaje activo
        if (posicion.x() == 1 && posicion.y() == 1) {
            // Aliado inferior izquierda
            image = flechaAbajoIzquierda
        } else if (posicion.x() == 1 && posicion.y() == 6) {
            // Aliado superior izquierda
            image = flechaArribaIzquierda
        } else if (posicion.x() == 7 && posicion.y() == 1) {
            // Enemigo inferior derecha
            image = flechaAbajoDerecha
        } else if (posicion.x() == 7 && posicion.y() == 6) {
            // Enemigo superior derecha
            image = flechaArribaDerecha
        }
        
        // Actualizar la imagen en pantalla
        game.removeVisual(self)
        game.addVisual(self)
    }
}