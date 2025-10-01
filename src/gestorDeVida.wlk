object gestorDeVida {
    method curacionNormal(personaje, cantidad) {
		const vidaPotencial = personaje.salud() + cantidad
		if (vidaPotencial >= personaje.saludMaxima()){
			personaje.fullVida()
		} else {
			personaje.salud(vidaPotencial)
		}
	}
}

class MedidorDeVida {
	const usuario
	method position() {
		return game.at(usuario.position().x(), usuario.position().y() - 1)
	}

//No logre hacer que funcione al enviar los datos
	method text() {
		return "" + usuario.salud() + " / " + usuario.saludMaxima()
	}
}

