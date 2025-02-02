extends AspectRatioContainer

@export var headline: HeadlineResource

func _ready():
	var files = DirAccess.open("res://scenes/page_presets").get_files()
	var preset = load("res://scenes/page_presets/" + files[RandomNumberGenerator.new().randi_range(0, files.size() - 1)])
	
	var page = preset.instantiate()
	page.find_child("Headline").text = headline.headline
	add_child(page)
