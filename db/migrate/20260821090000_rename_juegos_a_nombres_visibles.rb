class RenameJuegosANombresVisibles < ActiveRecord::Migration[7.2]
  def up
    Juego.where(nombre: "Radar visual").update_all(nombre: "Exploraciones")
    Juego.where(nombre: "Rasgos críticos").update_all(nombre: "Cierre visual")

    # Actualizamos también el texto denormalizado de las sesiones ya existentes,
    # para que las búsquedas por nombre (de_juego) sigan encontrándolas correctamente.
    Sesion.where(juego_nombre: "Radar visual").update_all(juego_nombre: "Exploraciones")
    Sesion.where(juego_nombre: "Rasgos críticos").update_all(juego_nombre: "Cierre visual")
  end

  def down
    Juego.where(nombre: "Exploraciones").update_all(nombre: "Radar visual")
    Juego.where(nombre: "Cierre visual").update_all(nombre: "Rasgos críticos")
    Sesion.where(juego_nombre: "Exploraciones").update_all(juego_nombre: "Radar visual")
    Sesion.where(juego_nombre: "Cierre visual").update_all(juego_nombre: "Rasgos críticos")
  end
end

