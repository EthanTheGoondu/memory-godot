extends TextureButton

class_name Card

var suit:int
var value:int # Ace is 1, J is 11, Q is 12, K is 13
var face: Resource
var back: Resource
var face_up: bool


# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_custom_minimum_size(Vector2(105,142.5))
	self.set_stretch_mode(5)
	self.set_ignore_texture_size(true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _init(suit, value):
	self.suit = suit
	self.value = value
	self.face = load("res://assets/cards/card-%s-%s.png" % [str(suit), str(value)])
	self.back = GameManager.cardBack
	self.face_up = true
	set_texture_normal(self.face)

func flip():
	if get_texture_normal() == self.face:
		set_texture_normal(self.back)
	else:
		set_texture_normal(self.face)

func _pressed():
	GameManager.choose_card(self)
	pass
