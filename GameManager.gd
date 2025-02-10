extends Node

@onready var Game = get_node('/root/Game')

enum Suits {SPADE = 1, HEART = 2, DIAMOND = 3, CLUB = 4}

var cardBack = preload("res://assets/cards/cardBack_red2.png")
var deck:Array[Card] = []
var matchTimer = Timer.new()
var flipTimer = Timer.new()
var secondsTimer = Timer.new()
var score:= 0
var seconds := 0
var moves := 0

const GOAL := 26

var c1:Card
var c2:Card
var scoreLabel:Label
var timerLabel:Label
var movesLabel:Label
var resetButton:TextureButton

var popUp = preload("res://pop_up.tscn")

func count_seconds():
	seconds += 1
	timerLabel.text = str(seconds)
	pass

func setup_timers():
	flipTimer.connect("timeout",self.turn_over_cards)
	flipTimer.set_one_shot(true)
	add_child(flipTimer)
	
	matchTimer.connect("timeout",self.match_cards_and_score)
	matchTimer.set_one_shot(true)
	add_child(matchTimer)
	
	secondsTimer.connect("timeout",self.count_seconds)
	add_child(secondsTimer)
	secondsTimer.start()
	pass

func reset_deck():
	self.c1 = null
	self.c2 = null
	for card in deck:
		card.queue_free()
	deck.clear()
	fill_deck()
	fill_grid_with_deck()
	
func reset_counters():
	score = 0
	seconds = 0
	moves = 0
	scoreLabel.text = str(score)
	timerLabel.text = str(seconds)
	movesLabel.text = str(moves)

func reset_from_button():
	reset_game()
	instantiate_splash()

func reset_game():
	reset_deck()
	reset_counters()
	pass

func setup_HUD():
	var hud:Node = Game.get_node('HUD')
	scoreLabel = hud.get_node('MarginContainer/Panel/Sections/SectionScore/score')
	timerLabel = hud.get_node('MarginContainer/Panel/Sections/SectionTimer/seconds')
	movesLabel = hud.get_node('MarginContainer/Panel/Sections/SectionMoves/moves')
	scoreLabel.text = str(score)
	timerLabel.text = str(seconds)
	movesLabel.text = str(moves)
	resetButton = hud.get_node('MarginContainer/Panel/Sections/SectionButtons/ButtonReset')
	resetButton.connect('pressed', self.reset_from_button)
	pass

func instantiate_splash():
	var splash = popUp.instantiate()
	Game.add_child(splash)

# Called when the node enters the scene tree for the first time.
func _ready():
	fill_deck()
	fill_grid_with_deck()
	setup_timers()
	setup_HUD()
	instantiate_splash()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fill_deck():
	for suit in Suits.values():
		for v in range(1, 14):
			var new_card = Card.new(suit, v)
			new_card.flip()
			deck.append(new_card)
	deck.shuffle()
	pass

func fill_grid_with_deck():
	#var grid = Game.get_node('grid')
	var grid = Game.get_node('Margin').get_node('grid')
	for c in deck:
		grid.add_child(c)
	pass

func choose_card(card:Card):
	if c1:
		if c2:
			# Already have 2 cards, do nothing
			return
		else:
			# Choosing 2nd card, time to evaluate
			card.flip()
			card.set_disabled(true)
			self.c2 = card
			moves += 1
			movesLabel.text = str(moves)
			eval_choices()
	else:
		# Choosing 1st card
		card.flip()
		card.set_disabled(true)
		self.c1 = card

func eval_choices():
	if c1 == null or c2 == null:
		print("Error, running evaluation without both chosen cards")
	else:
		if c1.value == c2.value:
			matchTimer.start(0.2)
		else:
			flipTimer.start(1)

func turn_over_cards():
	if c1:
		c1.flip()
		c1.set_disabled(false)
	if c2:
		c2.flip()
		c2.set_disabled(false)
	self.c1 = null
	self.c2 = null

func match_cards_and_score():
	#turn_over_cards()
	c1.set_modulate(Color(0.8,0.8,0.8,0.5))
	c2.set_modulate(Color(0.8,0.8,0.8,0.5))
	self.c1 = null
	self.c2 = null
	score += 1
	scoreLabel.text = str(score)
	if score >= GOAL:
		var winScreen = popUp.instantiate()
		winScreen.win(score, seconds, moves)
		Game.add_child(winScreen)
	pass
