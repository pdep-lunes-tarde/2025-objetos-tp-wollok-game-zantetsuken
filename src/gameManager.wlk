import personajes.*
import sistemaSeleccionador.*
import interfazImagenes.*
import wollok.game.*
import turnero.*
import mapas.*

object home {
    const property image = "fondo.jpg"
    const property position = game.at(0, 0)
}

object configurador {
    var property indicador = 1
    // ===== VARIABLES PARA GUARDAR LAS ELECCIONES DEL JUGADOR =====
    var property hechiceroElegido = null
    var property guerreroElegido = null

    // <<<--- NUEVAS VARIABLES PARA LOS ENEMIGOS (POR CATEGORÍA) ---<<<
    const property opcionesDeHechicero = [magoOscuro, nemegis, nikxomus, thiagurius]
    const property opcionesDeGuerrero = [halfdan, santhurius, soldadoBrilloNegro, malaika]

    // <<<--- NUEVAS VARIABLES PARA EL MAPA ---<<<
    var property mapaElegido = null 
    const property opcionesDeMapa = [mapaCastillo, mapaGalaxy, mapaInfierno, mapaPuente]
    
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
        game.addVisual(fondoSeleccionMapa)

        const posicionCentral = game.at(2, 1)

        // Definimos qué acción se ejecutará al presionar Enter
        const accionAlElegirMapa = { mapaElegido =>
            self.mapaElegido(mapaElegido.mapa())
            self.mostrarSeleccionDeHechicero()
        }

        sistemaSeleccion.iniciar(selectorDeMapas.mapas(), posicionCentral, accionAlElegirMapa)
    }

    method mostrarSeleccionDeHechicero() {
    game.clear()
    game.addVisual(fondoSeleccionHechicero)

    const posicionCentral = game.at(5, 1)

    // Definimos qué acción se ejecutará al presionar Enter para el HECHICERO
    const accionAlElegirHechicero = { hechicero =>
        self.hechiceroElegido(hechicero)
        // Al elegir el hechicero, pasamos a la siguiente pantalla
        self.mostrarSeleccionDeGuerrero()
    }

    // Iniciamos el selector para los HECHICEROS
    sistemaSeleccion.iniciar(
        opcionesDeHechicero,
        posicionCentral,
        accionAlElegirHechicero
    )
    }

    method mostrarSeleccionDeGuerrero() {
    game.clear()
    game.addVisual(fondoSeleccionGuerrero)

    const posicionCentral = game.at(5, 1)

    // Definimos qué acción se ejecutará al presionar Enter para el GUERRERO
    const accionAlElegirGuerrero = { guerrero =>
        self.guerreroElegido(guerrero)
        // Al elegir el guerrero, pasamos a la pantalla de rivales
        self.seleccionarEnemigosAleatorios()
    }

    // Iniciamos el selector para los GUERREROS
    sistemaSeleccion.iniciar(
        opcionesDeGuerrero,
        posicionCentral,
        accionAlElegirGuerrero
    )
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

        hechiceroRival.position(game.at(1, 1))
        game.addVisual(hechiceroRival)
        guerreroRival.position(game.at(9, 1))
        game.addVisual(guerreroRival)

        // Preparamos el listener para comenzar el juego
        keyboard.enter().onPressDo { self.mostrarInstrucciones() }
    }

    method mostrarInstrucciones() {
        game.clear()
        game.addVisual(fondoInstrucciones)
        keyboard.enter().onPressDo { self.activarCombate() }
    }


    method inicializarJuego() {
        game.title("PrimerPantalla")
        game.height(self.alto())
        game.width(self.ancho())
        //game.ground("suelo.png")
    }

    method activarCombate() {
        game.clear()
        //console.println(mapaElegido)
        mapa.establecerFondoMapa(mapaElegido)
        //game.addVisual(feed)
        turnero.empezarCombate([guerreroElegido, hechiceroElegido], [hechiceroRival, guerreroRival])
    }
    method seleccionarRival(accion) {
        // 1. Obtenemos la lista de enemigos que están vivos.
        const objetivosVivos = turnero.enemigosVivos()
        
        // Si no hay objetivos vivos, devolvemos el control al jugador.
        if (objetivosVivos.isEmpty()) {
            turnero.personajeActivo().activarAcciones()
        }

        // 2. Inicializamos el selector en el primer enemigo vivo.
        var indiceSeleccionado = 0
        selectorDeObjetivo.position(objetivosVivos.get(indiceSeleccionado).position())
        game.addVisual(selectorDeObjetivo)

        // 3. Definimos una función de limpieza para reutilizarla.
        const limpiarSeleccion = {
            game.removeVisual(selectorDeObjetivo)
        }

        // 4. Configuramos los controles del teclado.
        keyboard.left().onPressDo {
            // Movimiento circular hacia la izquierda
            indiceSeleccionado = (indiceSeleccionado - 1 + objetivosVivos.size()) % objetivosVivos.size()
            selectorDeObjetivo.position(objetivosVivos.get(indiceSeleccionado).position())
        }
        keyboard.right().onPressDo {
            // Movimiento circular hacia la derecha
            indiceSeleccionado = (indiceSeleccionado + 1) % objetivosVivos.size()
            selectorDeObjetivo.position(objetivosVivos.get(indiceSeleccionado).position())
        }
        keyboard.enter().onPressDo {
            // Confirmar el ataque
            const objetivoElegido = objetivosVivos.get(indiceSeleccionado)
            limpiarSeleccion.apply()
            self.corroborarAtaque(objetivoElegido, accion)
        }
        keyboard.c().onPressDo {
            // Cancelar y volver al menú de acciones
            limpiarSeleccion.apply()
            turnero.personajeActivo().activarAcciones()
        }
    }
    
    method corroborarAtaque(objetivo, accion) {
        // La limpieza de inputs ahora se maneja antes de llamar a este método.
        io.clear() 
        if (objetivo.salud() == 0) {
            const atacante = turnero.personajeActivo()
            game.say(atacante, "No puedo atacar a un muerto")
            // Devolvemos el control al jugador para que elija otra acción.
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
        aliado.position(game.at(1, indicador))
        aliado.image(aliado.imagenSeleccionador())
        indicador += 5
    }

    method cambiarPosicionesEnemigo(enemigo) {
        enemigo.position(game.at(7, indicador))
        enemigo.image(enemigo.imagenSeleccionador())
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

