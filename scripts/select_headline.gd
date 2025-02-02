extends Control

@export var event: EventResource

@onready var title = $Title
@onready var headline_container = $PageScrollContainer/VBoxContainer
@onready var button = $Button

func _ready():
	title.text = event.title
	
	var page_builder_asset = load("res://scenes/page_builder.tscn")
	
	for headline in event.headlines:
		var page_builder = page_builder_asset.instantiate()
		page_builder.headline = headline
		headline_container.add_child(page_builder)
		
	button.pressed.connect(select)

func select():
	queue_free()
