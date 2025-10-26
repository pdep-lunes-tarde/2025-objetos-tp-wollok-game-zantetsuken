import personajes.*
import sistemaSeleccionador.*
import interfazImagenes.*
import wollok.game.*
import turnero.*
import mapas.*

object configurador {
    var property indicador = 1
    var property hechiceroElegido = null
    var property guerreroElegido = null

    const property opcionesDeHechicero = [magoOscuro, nemegis, nikxomus, thiagurius]
    const property opcionesDeGuerrero = [halfdan, santhurius, soldadoBrilloNegro, malaika]

    var property mapaElegido = null 
    const property opcionesDeMapa = [mapa2, mapa3, mapa4, mapa1]
    
    var property hechiceroRival = null
    var property guerreroRival = null

    method ancho() = 16
    method alto() = 10

    method inicializarJuego() {
        game.title("PrimerPantalla")
        game.height(self.alto())
        game.width(self.ancho())
    }

    method primerPantalla() {
        game.clear()
        game.addVisual(primerPantalla)
        keyboard.enter().onPressDo { self.mostrarSeleccionDeMapa() }
    }

    method mostrarSeleccionDeMapa() {
        game.clear()
        game.addVisual(fondoSeleccionMapa)

        selectorDeMapas.iniciar()
    }

    method mostrarSeleccionDeHechicero() {
        game.clear()
        game.addVisual(fondoSeleccionHechicero)
        
        selectorDeHechiceros.iniciar()
    }

    method mostrarSeleccionDeGuerrero() {
        game.clear()
        game.addVisual(fondoSeleccionGuerrero)

        selectorDeGuerreros.iniciar()
    }

    method seleccionarEnemigosAleatorios() {
        opcionesDeHechicero.remove(hechiceroElegido)
        hechiceroRival = opcionesDeHechicero.anyOne()
        opcionesDeGuerrero.remove(guerreroElegido)
        guerreroRival = opcionesDeGuerrero.anyOne()
        self.mostrarSeleccionDeRival()
    }

    method mostrarSeleccionDeRival() {
        game.clear()
        io.clear()
        game.addVisual(fondoSeleccionRival)

        hechiceroRival.position(game.at(1, 1))
        game.addVisual(hechiceroRival)
        guerreroRival.position(game.at(9, 1))
        game.addVisual(guerreroRival)

        keyboard.enter().onPressDo { self.mostrarInstrucciones() }
    }

    method mostrarInstrucciones() {
        game.clear()
        game.addVisual(fondoInstrucciones)
        keyboard.enter().onPressDo { self.activarCombate() }
    }

    method activarCombate() {
        game.clear()
        mapa.establecerFondoMapa(mapaElegido)
        turnero.empezarCombate([guerreroElegido, hechiceroElegido], [hechiceroRival, guerreroRival])
    }

    method seleccionarRival(accion) {
        const objetivosVivos = turnero.enemigosVivos()
        
        if (objetivosVivos.isEmpty()) {
            turnero.personajeActivo().activarAcciones()
        }

        var indiceSeleccionado = 0
        selectorDeObjetivo.position(objetivosVivos.get(indiceSeleccionado).position())
        game.addVisual(selectorDeObjetivo)

        const limpiarSeleccion = {
            game.removeVisual(selectorDeObjetivo)
        }

        keyboard.left().onPressDo {
            indiceSeleccionado = (indiceSeleccionado - 1 + objetivosVivos.size()) % objetivosVivos.size()
            selectorDeObjetivo.position(objetivosVivos.get(indiceSeleccionado).position())
        }
        keyboard.right().onPressDo {
            indiceSeleccionado = (indiceSeleccionado + 1) % objetivosVivos.size()
            selectorDeObjetivo.position(objetivosVivos.get(indiceSeleccionado).position())
        }
        keyboard.enter().onPressDo {
            const objetivoElegido = objetivosVivos.get(indiceSeleccionado)
            limpiarSeleccion.apply()
            self.corroborarAtaque(objetivoElegido, accion)
        }
        keyboard.c().onPressDo {
            limpiarSeleccion.apply()
            turnero.personajeActivo().activarAcciones()
        }
    }
    
    method corroborarAtaque(objetivo, accion) {
        io.clear() 
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

