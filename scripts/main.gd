extends Node

@onready var debug_button = $GUI/DebugButton

@onready var money_ui = $GUI/Panel/Money
@onready var readers_ui = $GUI/Panel2/Readers
@onready var advertisability_ui = $GUI/Panel3/Advertisability
@onready var politics_ui = $GUI/Panel4/Politics

var money = 10
var readers = 10
var advertisability = 1.0
var politics = 0.5

var loaded_scene: Node = null
var selected_headlines: Array[HeadlineResource] = []
var event_count = 0

enum State {
	SELECT_HEADLINE,
	PRINT
}

var state: State = State.SELECT_HEADLINE

func _ready():
	debug_button.pressed.connect(step)
	set_money(money)
	set_readers(readers)
	set_advertisability(advertisability)
	set_politics(politics)

func step():
	if state == State.PRINT:
		set_money(money + advertisability * readers)
		selected_headlines = []
		event_count = 0
		state = State.SELECT_HEADLINE
	elif state == State.SELECT_HEADLINE:
		if event_count >= 5:
			state = State.PRINT
			apply_effects()
		else:
			event_count += 1
			select_headline()

func select_headline():
	var files = DirAccess.open("res://events").get_files()
	var event = load("res://events/" + files[RandomNumberGenerator.new().randi_range(0, files.size() - 1)])
	
	var scene = load("res://scenes/select_headline.tscn").instantiate()
	scene.event = event
	scene.headline_selected.connect(on_headline_selected)
	loaded_scene = scene
	add_child(scene)

func set_money(value: int):
	money = clamp(value, 0, INF)
	money_ui.text = str(money)

func set_readers(value: int):
	readers = clamp(value, 0, INF)
	readers_ui.text = str(readers)

func set_advertisability(value: float):
	advertisability = clampf(value, 0.0, 1.0)
	advertisability_ui.text = str(advertisability * 100) + "%"
	
func set_politics(value: float):
	politics = clampf(value, 0.0, 1.0)
	politics_ui.text = str(politics * 100) + "%"

func on_headline_selected(headline: HeadlineResource):
	selected_headlines.push_back(headline)
	loaded_scene.queue_free()
	step()

func apply_effects():
	set_readers(readers + selected_headlines.map(func(headline): return headline.readers).reduce(func(x, y): return x + y))
	set_advertisability(readers + selected_headlines.map(func(headline): return headline.advertisability).reduce(func(x, y): return x + y))
	set_politics(readers + selected_headlines.map(func(headline): return headline.politics).reduce(func(x, y): return x + y))
