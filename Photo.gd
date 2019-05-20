extends Sprite

export(bool) var use_line_2d = false
export(Color) var main_diagonals_color = Color(255, 0, 0)
export(Color) var main_cross_color = Color(255, 0, 0)

onready var line_main : Line2D = get_node("MainQuadrantLine")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func reload():
	scale = Vector2(1, 1)
	
	var size = texture.get_size()
	set_offset(Vector2(size.x * .5, size.y * .5))	
	set_process(true)
	set_position(Vector2(0, 0))	
	
	#get_node("Camera2D").set_offset(Vector2(size.x, size.y))
	#get_node("Camera2D").set_position(position)
	
	var container = get_node("/root/Control/ViewportContainer")
	container.set_size(Vector2(size.x * scale.x + 2, size.y * scale.y + 1))
	
	var view = get_viewport()
	#view.set_size_override(true, Vector2(size.x * scale.x + 1, size.y * scale.y + 1)) # Custom size for 2D
	#view.set_size_override_stretch(true) # Enable stretch for custom size.	
	
	var camera : Camera2D = view.get_node("Camera2D")
	camera.offset = Vector2(size.x * scale.x * .5, size.y * scale.y * .5)
	#camera.set_size(Vector2(size.x * scale.x, size.y * scale.y))
	
	#
	# MAIN LINE 2D
	#
	
	var lines = get_node("Node2D")
	
	if lines:
		lines.queue_free()
		yield(get_tree(), "idle_frame")
	
	lines = Node2D.new()
	add_child(lines, true)
	
	var half_x = size.x * .5
	var half_y = size.y * .5

	# Diagonals
	var main_top_bottom = Line2D.new()	
	main_top_bottom.set_points(PoolVector2Array([Vector2(0,0), size]))
	lines.add_child(main_top_bottom)	
	var main_bottom_top = Line2D.new()	
	main_bottom_top.set_points(PoolVector2Array([Vector2(0, size.y), Vector2(size.x, 0)]))
	lines.add_child(main_bottom_top)
	
	# Cross
	var vertical = Line2D.new()	
	vertical.set_points(PoolVector2Array([Vector2(0, half_y), Vector2(size.x, half_y)]))
	lines.add_child(vertical)	
	var horizontal = Line2D.new()	
	horizontal.set_points(PoolVector2Array([Vector2(half_x, 0), Vector2(half_x, size.y)]))
	lines.add_child(horizontal)

# Called when the node enters the scene tree for the first time.
func _ready():
	reload()
	
func _process(delta):
    update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func draw_circle_arc(center, radius, angle_from, angle_to, color):
    var nb_points = 32
    var points_arc = PoolVector2Array()

    for i in range(nb_points + 1):
        var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
        points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

    for index_point in range(nb_points):
        draw_line(points_arc[index_point], points_arc[index_point + 1], color)
		
func _draw():
	if not use_line_2d:
		draw()
	
func draw():
	var size = texture.get_size()
	
	var color_main = Color(255, 0, 0)
	var half_x = size.x * .5
	var half_y = size.y * .5
	
	# Main diagonals
	draw_line(Vector2(0,0), size, color_main, 1, true)
	draw_line(Vector2(0, size.y), Vector2(size.x, 0), color_main, 1, true)
	
	# Main cross
	draw_line(Vector2(0, half_y), Vector2(size.x, half_y), color_main, 1, true)
	draw_line(Vector2(half_x, 0), Vector2(half_x, size.y), color_main, 1, true)
	
	# Top-left quadrant
	var white = Color(255, 255, 255)
	draw_line(Vector2(0, half_y), Vector2(half_x, 0), white, 1, true)
	draw_line(Vector2(0, half_y * .5), Vector2(half_x, half_y * .5), white, 1, true)
	draw_line(Vector2(half_x * .5, 0), Vector2(half_x * .5, half_y), white, 1, true)
	draw_line(Vector2(0, 0), Vector2(half_x, half_y), white, 1, true)
	
	# Bottom-left quadrant
	var black = Color(0, 0, 0)
	draw_line(Vector2(0, size.y), Vector2(half_x, half_y), black, 1, true)
	draw_line(Vector2(0, size.y * .75), Vector2(half_x, size.y * .75), black, 1, true)
	draw_line(Vector2(half_x * .5, half_y), Vector2(half_x * .5, size.y), black, 1, true)
	draw_line(Vector2(0, half_y), Vector2(half_x, size.y), black, 1, true)
	
	# Top-right quadrant
	var green = Color(0, 255, 0)
	draw_line(Vector2(half_x, half_y), Vector2(size.x, 0), green, 1, true)
	draw_line(Vector2(half_x, half_y * .5), Vector2(size.x, half_y * .5), green, 1, true)
	draw_line(Vector2(size.x * .75, 0), Vector2(size.x * .75, half_y), green, 1, true)
	draw_line(Vector2(half_x, 0), Vector2(size.x, half_y), green, 1, true)
	
	# Bottom-right quadrant
	var blue = Color(0, 0, 255)
	draw_line(Vector2(half_x, size.y), Vector2(size.x, half_y), blue, 1, true)
	draw_line(Vector2(half_x, size.y * .75), Vector2(size.x, size.y * .75), blue, 1, true)
	draw_line(Vector2(size.x * .75, half_y), Vector2(size.x * .75, size.y), blue, 1, true)
	draw_line(Vector2(half_x, half_y), Vector2(size.x, size.y), blue, 1, true)
	
	draw_rect(Rect2(0, 0, size.x, size.y), blue, false)
	
# http://kidscancode.org/blog/2018/03/godot3_visibility_raycasts/

func _on_Button2_pressed():
	get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	# Let two frames pass to make sure the screen was captured
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	var img = get_viewport().get_texture().get_data()
	img.flip_y()
	
	# Create a texture for it
	#var tex = ImageTexture.new()
	#tex.create_from_image(img)
	
	#var data = get_texture().get_data()
	img.save_png("print.png")
