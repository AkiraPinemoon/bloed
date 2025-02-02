extends PanelContainer

@export var swipe_threshold: float = 150.0
@export var page_indicator: HBoxContainer

var scrolling: bool = false
var velocity: float = 0.0
var target_position: float = 0.0
var swipe_start = null
var page = 0

@onready var vbox = $VBoxContainer

func _ready():
	page_indicator.get_children()[page].get("theme_override_styles/panel").bg_color = Color(0.5,0.5,0.5)

func _gui_input(event):
	if event is InputEventScreenTouch and event.pressed:
		swipe_start = event.position.x
	elif event is InputEventScreenDrag:
		vbox.position.x += event.relative.x
		velocity = event.relative.x
		scrolling = true
		get_viewport().set_input_as_handled()
	elif event is InputEventScreenTouch and not event.pressed:
		scrolling = false
		if abs(event.position.x - swipe_start) < swipe_threshold:
			snap_to_page(page)
		else:
			if event.position.x > swipe_start && page > 0:
				snap_to_page(page - 1)
			elif page < vbox.get_child_count() - 1:
				snap_to_page(page + 1)
			else:
				snap_to_page(page)

func snap_to_page(page):
	page_indicator.get_children()[self.page].get("theme_override_styles/panel").bg_color = Color(1,1,1)
	self.page = page
	page_indicator.get_children()[page].get("theme_override_styles/panel").bg_color = Color(0.5,0.5,0.5)
	
	var child = vbox.get_children()[page]
	if child == null:
		return
	var target_x = -child.position.x
	target_position = target_x
	create_tween().tween_property(vbox, "position:x", target_x, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
