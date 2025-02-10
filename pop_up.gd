extends Control

func new_game():
	print("New game")
	get_tree().set_pause(false)
	queue_free()
	GameManager.reset_game()


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().set_pause(true)
	var playButton = get_node("CenterContainer").get_node("Panel").get_node("VBoxContainer").get_node("Button")
	playButton.connect("pressed", self.new_game)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func win(score, seconds, moves):
	$CenterContainer/Panel/VBoxContainer/TextureRect.set_texture(load("res://assets/ui/complete.png"))
	$CenterContainer/Panel/VBoxContainer/Label.set_text("You found %s pairs in %ss and made %s moves" % [str(score), str(seconds), str(moves)])
	pass
