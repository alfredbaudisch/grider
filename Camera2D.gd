extends Camera2D

onready var photo = get_node("/root/Photo")

func _ready():
	pass

func get_screenshot():
	self.add_child(photo)
    # get_viewport returns the closest viewport (subViewport)
	get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	var result = get_viewport().get_texture().get_data()
	result.save_png("capture.png")    

func _on_Button2_pressed():
	get_screenshot()
