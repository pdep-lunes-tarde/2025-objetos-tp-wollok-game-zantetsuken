import personajes.*
import otroEvento.*
import interfazImagenes.*
import wollok.game.*
import turnero.*
import mapas.*

object gameManager {
    method mostrarMenu() {
        game.clear()
        game.addVisual(home)

        keyboard.t().onPressDo {
            manager.iniciarJuego()
        }
        keyboard.z().onPressDo {
            configurador.inicializarJuego()
        }
    }
}

object home {
    const property image = "fondo.jpg"
    const property position = game.at(0, 0)
}

object configurador {
    var property indicador = 1
    // ===== VARIABLES PARA GUARDAR LAS ELECCIONES DEL JUGADOR =====
    var hechiceroElegido = null
    var guerreroElegido = null

    // <<<--- NUEVAS VARIABLES PARA LOS ENEMIGOS (POR CATEGORÍA) ---<<<
    const property opcionesDeHechicero = [magoOscuro, nemegis, nikxomus, thiagurius]
    const property opcionesDeGuerrero = [halfdan, santhurius, soldadoBrilloNegro, malaika]

    // <<<--- NUEVAS VARIABLES PARA EL MAPA ---<<<
    var property mapaElegido = null 
    const property opcionesDeMapa = [mapaCastillo, mapaGalaxy, mapaInfierno, mapaPuente]
    
    var property hechiceroRival = null
    var property guerreroRival = null

    method ancho() = 20
    method alto() = 10


    method primerPantalla() {
        game.clear()
        game.addVisual(primerPantalla)
        keyboard.enter().onPressDo { self.mostrarSeleccionDeMapa() }
    }

    method mostrarSeleccionDeMapa() {
        game.clear()
        io.clear()
        game.addVisual(fondoSeleccionMapa)
        mapaPuente.position(game.at(2, 1))   
        mapaCastillo.position(game.at(10, 1))  
        mapaGalaxy.position(game.at(2, 6))   
        mapaInfierno.position(game.at(10, 6))
        
        // Muestra las 4 imágenes de mapa
        opcionesDeMapa.forEach({ mapita => game.addVisual(mapita) })

        // seleccion ed mapas
        keyboard.num1().onPressDo { self.seleccionarMapa(opcionesDeMapa.get(0)) }
        keyboard.num2().onPressDo { self.seleccionarMapa(opcionesDeMapa.get(1)) }
        keyboard.num3().onPressDo { self.seleccionarMapa(opcionesDeMapa.get(2)) }
        keyboard.num4().onPressDo { self.seleccionarMapa(opcionesDeMapa.get(3)) }
    }
    
    method seleccionarMapa(mapa) {
        mapaElegido = mapa.image() // Guardamos el mapa elegido
        self.mostrarSeleccionDeHechicero()
    }

    method mostrarSeleccionDeHechicero() {
        game.clear()
        io.clear()
        game.addVisual(fondoSeleccionHechicero)
        game.addVisual(magoOscuro)
        game.addVisual(nemegis)
        game.addVisual(nikxomus)
        game.addVisual(thiagurius)
        keyboard.num1().onPressDo { self.seleccionarHechicero(1) }
        keyboard.num2().onPressDo { self.seleccionarHechicero(2) }
        keyboard.num3().onPressDo { self.seleccionarHechicero(3) }
        keyboard.num4().onPressDo { self.seleccionarHechicero(4) }
    }

    method seleccionarHechicero(numero) {
        if(numero==1){
            hechiceroElegido = magoOscuro
        }else if(numero==2){
            hechiceroElegido = nemegis         
        }else if(numero==3){
            hechiceroElegido = nikxomus
        }else if(numero==4){
            hechiceroElegido = thiagurius
        }
        self.mostrarSeleccionDeGuerrero()
    }

    method mostrarSeleccionDeGuerrero() {
        game.clear()
        io.clear()
        game.addVisual(fondoSeleccionGuerrero)
        game.addVisual(halfdan)
        game.addVisual(santhurius)
        game.addVisual(soldadoBrilloNegro)
        game.addVisual(malaika)
        keyboard.num1().onPressDo { self.seleccionarGuerrero(1) }
        keyboard.num2().onPressDo { self.seleccionarGuerrero(2) }
        keyboard.num3().onPressDo { self.seleccionarGuerrero(3) }
        keyboard.num4().onPressDo { self.seleccionarGuerrero(4) }
    }
    
    method seleccionarGuerrero(numero) {
        if(numero==1){
            guerreroElegido = halfdan
        }else if(numero==2){
            guerreroElegido = santhurius       
        }else if(numero==3){
            guerreroElegido = soldadoBrilloNegro
        }else if(numero==4){
            guerreroElegido = malaika
        }
        self.seleccionarEnemigosAleatorios()       
    }

    // <<<--- MÉTODO MODIFICADO ---<<<
    method seleccionarEnemigosAleatorios() {
        // Selecciona 1 enemigo aleatorio de cada categoría
        opcionesDeHechicero.remove(hechiceroElegido)
        hechiceroRival = opcionesDeHechicero.anyOne()
        opcionesDeGuerrero.remove(guerreroElegido)
        guerreroRival = opcionesDeGuerrero.anyOne()
        self.mostrarSeleccionDeRival()
    }

    // <<<--- MÉTODO MODIFICADO ---<<<
    method mostrarSeleccionDeRival() {
        game.clear()
        io.clear()
        game.addVisual(fondoSeleccionRival)

        hechiceroRival.position(game.at(3, 3))
        game.addVisual(hechiceroRival)
        guerreroRival.position(game.at(10, 3))
        game.addVisual(guerreroRival)

        // Preparamos el listener para comenzar el juego
        keyboard.enter().onPressDo { self.activarCombate() }
    }

    method inicializarJuego() {
        game.title("PrimerPantalla")
        game.height(self.alto())
        game.width(self.ancho())
        //game.ground("suelo.png")
    }

    method inicializarSeleccionador() {
        game.addVisual(seleccionador)
        keyboard.r().onPressDo { io.removeEventHandler(['keypress', "ArrowRight"]) }
        keyboard.e().onPressDo { io.removeEventHandler(['keypress', "ArrowLeft"]) }
        keyboard.t().onPressDo { gameManager.mostrarMenu() }
        keyboard.up().onPressDo { seleccionador.moverse(arriba) }
        keyboard.down().onPressDo { seleccionador.moverse(abajo) }
        keyboard.enter().onPressDo { self.activarCombate() }
        seleccionador.activarSeleccionAtaque()
    }
    method activarCombate() {
        game.clear()
        game.ground(mapaElegido) 
        //game.addVisual(feed)
        turnero.empezarCombate([guerreroElegido, hechiceroElegido], [hechiceroRival, guerreroRival])
    }
    method seleccionarRival(accion) {
        self.desactivarAcciones()
        var objetivo = null
        keyboard.a().onPressDo { objetivo = turnero.enemigos().get(0); self.corroborarAtaque(objetivo, accion) }
        keyboard.s().onPressDo { objetivo = turnero.enemigos().get(1); self.corroborarAtaque(objetivo, accion) }
        keyboard.d().onPressDo { objetivo = turnero.enemigos().get(2); self.corroborarAtaque(objetivo, accion) }
        keyboard.c().onPressDo { self.desactivarAcciones(); turnero.personajeActivo().activarAcciones() }
    }
    
    method corroborarAtaque(objetivo, accion) {
        self.desactivarAcciones()
        if (objetivo.salud() == 0) {
            const atacante = turnero.personajeActivo()
            game.say(atacante, "No puedo atacar a un muerto")
            atacante.empezarTurnoAliado()
        } else if (objetivo.salud() > 0) {
            accion.apply(objetivo)
            game.schedule(7000, { turnero.pasarTurno() })
        }
    }
    method desactivarAcciones() {
        io.clear()
    }
    method activarCriatura(criatura) {
        game.addVisual(criatura)
    }
    method desactivarCriatura(criatura) {
        game.removeVisual(criatura)
    }
    method mostrarPersonajes() {
        turnero.aliados().forEach({ aliado => self.cambiarPosicionesAliado(aliado) })
        self.reiniciarIndicador()
        turnero.enemigos().forEach({ enemigo => self.cambiarPosicionesEnemigo(enemigo) })
        self.reiniciarIndicador()
        turnero.turnos().forEach({ personaje => game.addVisual(personaje) })
        turnero.turnos().forEach({ personaje => game.addVisual(personaje.medidorDeSalud()) })
        //game.width(self.ancho()+4)
        game.addVisual(feed)
    }
    method cambiarPosicionesAliado(aliado) {
        aliado.position(game.at(3, indicador))
        indicador += 5
    }

    method cambiarPosicionesEnemigo(enemigo) {
        enemigo.position(game.at(10, indicador))
        indicador += 5
    }
    method reiniciarIndicador() {
        indicador = 1
    }
    method jugar() {
        self.inicializarJuego()
        self.primerPantalla()
        game.start()
    }
}