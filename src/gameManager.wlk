import personajes.*
import otroEvento.*
import aliados.*
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
    var tanqueElegido = null
    var hechiceroElegido = null
    var guerreroElegido = null

    // <<<--- NUEVAS VARIABLES PARA LOS ENEMIGOS (POR CATEGORÍA) ---<<<
    const property opcionesDeTanque = [opcionTanque1, opcionTanque2, opcionTanque3]
    const property opcionesDeHechicero = [opcionHechicero1, opcionHechicero2, opcionHechicero3]
    const property opcionesDeGuerrero = [opcionGuerrero1, opcionGuerrero2, opcionGuerrero3]

    // <<<--- NUEVAS VARIABLES PARA EL MAPA ---<<<
    var property mapaElegido = null 
    const property opcionesDeMapa = [mapaCastillo, mapaGalaxy, mapaInfierno, mapaPuente]


    var property tanqueRival = null
    var property hechiceroRival = null
    var property guerreroRival = null

    method ancho() = 16
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
        mapaPuente.position(game.at(0.1, 3))   
        mapaCastillo.position(game.at(3.5, 3))  
        mapaGalaxy.position(game.at(6.5, 3))   
        mapaInfierno.position(game.at(10.5, 3))
        
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
        // Luego de elegir el mapa, pasamos a la selección de tanque
        self.mostrarSeleccionDeTanque()
    }


    // ===== MÉTODOS DE SELECCIÓN (ACTUALIZADOS Y NUEVOS) =====
    method mostrarSeleccionDeTanque() {
        game.clear()
        io.clear()
        game.addVisual(fondoSeleccionTanque)
        game.addVisual(opcionTanque1)
        game.addVisual(opcionTanque2)
        game.addVisual(opcionTanque3)
        keyboard.num1().onPressDo { self.seleccionarTanque(1) }
        keyboard.num2().onPressDo { self.seleccionarTanque(2) }
        keyboard.num3().onPressDo { self.seleccionarTanque(3) }
    }
    method seleccionarTanque(numero) {
        tanqueElegido = numero
        self.mostrarSeleccionDeHechicero()
    }
    method mostrarSeleccionDeHechicero() {
        game.clear()
        io.clear()
        game.addVisual(fondoSeleccionHechicero)
        game.addVisual(opcionHechicero1)
        game.addVisual(opcionHechicero2)
        game.addVisual(opcionHechicero3)
        keyboard.num1().onPressDo { self.seleccionarHechicero(1) }
        keyboard.num2().onPressDo { self.seleccionarHechicero(2) }
        keyboard.num3().onPressDo { self.seleccionarHechicero(3) }
    }
    method seleccionarHechicero(numero) {
        hechiceroElegido = numero
        self.mostrarSeleccionDeGuerrero()
    }
    method mostrarSeleccionDeGuerrero() {
        game.clear()
        io.clear()
        game.addVisual(fondoSeleccionGuerrero)
        game.addVisual(opcionGuerrero1)
        game.addVisual(opcionGuerrero2)
        game.addVisual(opcionGuerrero3)
        keyboard.num1().onPressDo { self.seleccionarGuerrero(1) }
        keyboard.num2().onPressDo { self.seleccionarGuerrero(2) }
        keyboard.num3().onPressDo { self.seleccionarGuerrero(3) }
    }
    
    method seleccionarGuerrero(numero) {
        guerreroElegido = numero
        self.mostrarResumenDeSeleccion()
    }

    method mostrarResumenDeSeleccion() {
        game.clear()
        io.clear()
        game.addVisual(fondoResumen)

        const cartaTanque = if (tanqueElegido == 1) opcionTanque1 else if (tanqueElegido == 2) opcionTanque2 else opcionTanque3
        const cartaHechicero = if (hechiceroElegido == 1) opcionHechicero1 else if (hechiceroElegido == 2) opcionHechicero2 else opcionHechicero3
        const cartaGuerrero = if (guerreroElegido == 1) opcionGuerrero1 else if (guerreroElegido == 2) opcionGuerrero2 else opcionGuerrero3

        cartaTanque.position(game.at(2, 2))
        game.addVisual(cartaTanque)
        cartaHechicero.position(game.at(7, 2))
        game.addVisual(cartaHechicero)
        cartaGuerrero.position(game.at(12, 2))
        game.addVisual(cartaGuerrero)

        // Al presionar Z, ahora selecciona y muestra a los rivales
        keyboard.z().onPressDo { 
            self.seleccionarEnemigosAleatorios()
            self.mostrarSeleccionDeRival()
        }
    }

    // <<<--- MÉTODO MODIFICADO ---<<<
    method seleccionarEnemigosAleatorios() {
        // Selecciona 1 enemigo aleatorio de cada categoría
        tanqueRival = opcionesDeTanque.anyOne()
        hechiceroRival = opcionesDeHechicero.anyOne()
        guerreroRival = opcionesDeGuerrero.anyOne()
    }

    // <<<--- MÉTODO MODIFICADO ---<<<
    method mostrarSeleccionDeRival() {
        game.clear()
        io.clear()
        game.addVisual(fondoSeleccionRival)

        tanqueRival.position(game.at(2, 2))
        game.addVisual(tanqueRival)
        hechiceroRival.position(game.at(7, 2))
        game.addVisual(hechiceroRival)
        guerreroRival.position(game.at(12, 2))
        game.addVisual(guerreroRival)

        // Preparamos el listener para comenzar el juego
        keyboard.z().onPressDo { self.activarCombate() }
    }

    method inicializarJuego() {
        game.title("PrimerPantalla")
        game.height(self.alto())
        game.width(self.ancho())
        game.ground("suelo.png")
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

        game.ground(mapaElegido) // Establece el mapa elegido como fondo de combate

        game.addVisual(feed)
        turnero.empezarCombate()
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
            atacante.empezarTurno()
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
        turnero.enemigos().forEach({ enemigo => self.cambiarPosiciones(enemigo) })
        self.reiniciarIndicador()
        turnero.turnos().forEach({ personaje => game.addVisual(personaje.background()) })
        turnero.turnos().forEach({ personaje => game.addVisual(personaje) })
        turnero.turnos().forEach({ personaje => game.addVisual(personaje.medidorDeSalud()) })
    }
    method cambiarPosiciones(enemigo) {
        enemigo.position(game.at(8, indicador))
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