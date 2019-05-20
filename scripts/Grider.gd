extends Sprite

const LINES_GROUP = "GridLines"
const DEFAULT_GRID_PATH = "grid.png"
const DEFAULT_GRID_WITH_PHOTO_PATH = "grid-with-photo.png"
const DEFAULT_GRID_WITH_PHOTO_APPEND = "-with-photo"

enum GRID_TYPES {
	Contour,
	Thirds
	MinorThirds
	CentralCross
	CentralDiagonals
}

onready var grid = get_node("Grid")
onready var viewport_container = get_node("../../../ViewportContainer")

var image_scale := 1.0 setget set_scale,get_scale

export var settings = {
	GRID_TYPES.Contour: {
		name = "Contour",
		visible = true,
		color = Color(0, 0, 0),
		width = 10
	},
	GRID_TYPES.Thirds: {
		name = "Thirds",
		visible = true,
		color = Color(0, 1, 0, .5),
		width = 4
	},
	GRID_TYPES.MinorThirds: {
		name = "MinorThirds",
		visible = true,
		color = Color(1, 0, 0, .5),
		width = 4,
		subdivisions = 10, # TODO: implement me
		with_central_cross = false # TODO: implement me
	},
	GRID_TYPES.CentralCross: {
		name = "CentralCross",
		visible = true,
		color = Color(1, 0, 0, .5),
		width = 4
	},
	GRID_TYPES.CentralDiagonals: {
		name = "MainDiagonals",
		visible = true,
		color = Color(1, 0, 0, .5),
		width = 4
	}
} setget ,get_grid_settings

var save_path setget set_save_path
var save_grid_with_photo_path = null

var save_grid_with_photo := true setget set_save_grid_with_photo,get_save_grid_with_photo

func set_save_path(path):
	save_path = path
	
	var regex = RegEx.new()
	regex.compile("^(.*)\\.png$")
	var result = regex.search(save_path)
	
	# Append "-with-photo"
	if result and result.get_group_count() == 1:
		save_grid_with_photo_path = result.get_string(1) + DEFAULT_GRID_WITH_PHOTO_APPEND + ".png"

func set_save_grid_with_photo(value): save_grid_with_photo = value
func get_save_grid_with_photo(): return save_grid_with_photo

func set_scale(value): image_scale = value
func get_scale(): return image_scale

func get_grid_settings(): return settings
	
func set_grid_visible(grid_type, value): settings[grid_type].visible = value
func set_grid_width(grid_type, value): settings[grid_type].width = value
func set_grid_color(grid_type, value): settings[grid_type].color = value
	
func reload():
	scale = Vector2(image_scale, image_scale)
	
	var size = texture.get_size()
	set_offset(Vector2(size.x * .5, size.y * .5))	
	set_process(true)
	set_position(Vector2(0, 0))	
	
	viewport_container.set_size(Vector2(size.x * scale.x, size.y * scale.y))
	
	var view = get_viewport()
	var camera : Camera2D = view.get_node("Camera2D")
	camera.offset = Vector2(size.x * scale.x * .5, size.y * scale.y * .5)

	_clear_grid()

	#
	# Draw grids
	#
	
	if settings[GRID_TYPES.MinorThirds].visible:
		_draw_minor_thirds(size, settings[GRID_TYPES.Thirds].visible)
	
	if settings[GRID_TYPES.CentralDiagonals].visible:
		_draw_central_diagonals(size)

	if settings[GRID_TYPES.CentralCross].visible:
		_draw_central_cross(size)
	
	if settings[GRID_TYPES.Thirds].visible:
		_draw_thirds(size)

	if settings[GRID_TYPES.Contour].visible:
		_draw_contour(size)
	
func _clear_grid():
	for line in grid.get_children():
		grid.remove_child(line)
		line.queue_free()
		
	yield(get_tree(), "idle_frame")
	
func _draw_contour(size):
	_draw_line(Vector2(0, 0), Vector2(size.x, 0), settings[GRID_TYPES.Contour].width, settings[GRID_TYPES.Contour].color)
	_draw_line(Vector2(0, 0), Vector2(0, size.y), settings[GRID_TYPES.Contour].width, settings[GRID_TYPES.Contour].color)
	_draw_line(Vector2(0, size.y), Vector2(size.x, size.y), settings[GRID_TYPES.Contour].width, settings[GRID_TYPES.Contour].color)
	_draw_line(Vector2(size.x, 0), Vector2(size.x, size.y), settings[GRID_TYPES.Contour].width, settings[GRID_TYPES.Contour].color)
	
func _draw_thirds(size):
	var third = size.x / 3
	var third_row = size.y / 3

	for col in range(1, 3):
		var x = col * third
		_draw_line(Vector2(x, 0), Vector2(x, size.y), settings[GRID_TYPES.Thirds].width, settings[GRID_TYPES.Thirds].color)
		
	for row in range(1, 3):
		var y = row * third_row
		_draw_line(Vector2(0, y), Vector2(size.x, y), settings[GRID_TYPES.Thirds].width, settings[GRID_TYPES.Thirds].color)

func _draw_minor_thirds(size, skip_central_thirds):
	var third = size.x / 3
	var third_row = size.y / 3
	
	var col_increment = third / 3

	for col in range(11):
		if skip_central_thirds:
			if col == 0 or col % 3 == 0: continue
			
		var x = col * col_increment
		_draw_line(Vector2(x, 0), Vector2(x, size.y), settings[GRID_TYPES.MinorThirds].width, settings[GRID_TYPES.MinorThirds].color)
		
	var row_increment = third_row / 3

	for col in range(11):
		if skip_central_thirds:
			if col == 0 or col % 3 == 0: continue
		
		var y = col * row_increment
		_draw_line(Vector2(0, y), Vector2(size.x, y), settings[GRID_TYPES.MinorThirds].width, settings[GRID_TYPES.MinorThirds].color)

func _draw_central_cross(size):
	var half_x = size.x * .5
	var half_y = size.y * .5
	
	_draw_line(Vector2(half_x, 0), Vector2(half_x, size.y), settings[GRID_TYPES.CentralCross].width, settings[GRID_TYPES.CentralCross].color)
	_draw_line(Vector2(0, half_y), Vector2(size.x, half_y), settings[GRID_TYPES.CentralCross].width, settings[GRID_TYPES.CentralCross].color)

func _draw_central_diagonals(size):	
	_draw_line(Vector2(0, 0), Vector2(size.x, size.y), settings[GRID_TYPES.CentralDiagonals].width, settings[GRID_TYPES.CentralDiagonals].color)
	_draw_line(Vector2(0, size.y), Vector2(size.x, 0), settings[GRID_TYPES.CentralDiagonals].width, settings[GRID_TYPES.CentralDiagonals].color)

func _draw_line(pos, size, width = 4, color = Color(255, 0, 0)):
	var line = Line2D.new()
	line.set_points(PoolVector2Array([pos, size]))
	line.set_width(width)
	line.set_default_color(color)
	line.add_to_group("GridLines")
	grid.add_child(line)

func _on_Button2_pressed():
	capture_to_file()
			
func capture_to_file():
	var original = self_modulate
	
	for action in range(3):
		if action == 0 and save_grid_with_photo:
			get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)	
			# Let two frames pass to make sure the screen was captured
			yield(get_tree(), "idle_frame")
			yield(get_tree(), "idle_frame")
			_save_to_file(save_grid_with_photo_path if save_grid_with_photo_path else DEFAULT_GRID_WITH_PHOTO_PATH)	
					
		elif action == 1:
			self_modulate = Color(255, 255, 255, 0)
			get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
			yield(get_tree(), "idle_frame")
			yield(get_tree(), "idle_frame")
			_save_to_file(save_path if save_path else DEFAULT_GRID_PATH)
		else:
			self_modulate = original

func _save_to_file(file_name):
	var img = get_viewport().get_texture().get_data()
	img.flip_y()
	img.save_png(file_name)

func _on_PhotoVScrollBar_value_changed(value):
	print(value)
