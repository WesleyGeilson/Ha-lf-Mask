extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#quando pressidonado aqui, basicamente vai redirecionar para a cena estabelecida, do video que eu aprendi no yt
func _on_exit_pressed() -> void:
	get_tree().quit()
