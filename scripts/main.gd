extends Node

@onready var debug_button = $GUI/DebugButton

enum State {
	START,
	SELECT_HEADLINE,
}

const state: State = State.START

func _ready():
	debug_button.pressed.connect(select_headline)

func _process(delta):
	pass

func select_headline():
	var files = DirAccess.open("res://events").get_files()
	var event = load("res://events/" + files[RandomNumberGenerator.new().randi_range(0, files.size() - 1)])
	
	var scene = load("res://scenes/select_headline.tscn").instantiate()
	scene.event = event
	add_child(scene)
