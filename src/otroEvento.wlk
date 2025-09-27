import juego.*
import gameManager.*
import wollok.game.*
object manager {

    method iniciarJuego() {
		game.clear()
		game.addVisual(fondoEvento)
        io.clear()

        keyboard.z().onPressDo {
			game.clear()
			gameManager.mostrarMenu()
		}

        keyboard.r().onPressDo {
            game.removeVisual(fondoEvento)
        }
	}

}

object fondoEvento {
    const property image = "fondo2.jpg"
    const property position = game.at(0,0)
}
