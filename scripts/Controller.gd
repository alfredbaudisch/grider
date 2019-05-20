extends Control

export(NodePath) var photo_path
export(NodePath) var open_file_dialog_path
export(NodePath) var save_as_dialog_path

export(String) var default_grid_path = "grid.png"
export(String) var default_grid_with_photo_path = "grid-with-photo.png"

onready var photo = get_node(photo_path)
onready var open_file_dialog = get_node(open_file_dialog_path)
onready var save_as_dialog = get_node(save_as_dialog_path)
onready var save = get_node("MainContainer/Toolbar/MainActions/LoadSave/Save")

onready var grids = get_node("MainContainer/Toolbar/Grids")
onready var image_options = get_node("MainContainer/Toolbar/MainActions/ImageOptions")

var loaded_photo_path = null

func _ready():
	_reload_ui()

func has_photo() -> bool:
	return loaded_photo_path != null and loaded_photo_path != ""

func _reload_ui():
	if not has_photo():
		grids.visible = false
		save.disabled = true
		image_options.visible = false
		return
	
	var settings = photo.get_grid_settings()
	
	for grid_type in settings:
		var ui = grids.get_node(settings[grid_type].name)
		var ui_visible : CheckBox = ui.get_node("MainContainer/Visible")
		ui_visible.set_pressed(settings[grid_type].visible)
		var ui_color : ColorPickerButton = ui.get_node("MainContainer/Color")
		ui_color.set_pick_color(settings[grid_type].color)
		var ui_slider : ColorPickerButton = ui.get_node("WidthContainer/Width")
		ui_slider.set_value(settings[grid_type].width)
		var ui_width : Label = ui.get_node("WidthContainer/WidthDisplay")
		ui_width.set_text(str(settings[grid_type].width))
		
	var ui_scale_slider = image_options.get_node("Scale/Scale")
	ui_scale_slider.set_value(photo.get_scale())
	var ui_scale = image_options.get_node("Scale/ScaleDisplay")
	ui_scale.set_text(str(photo.get_scale() * 100) + "%")
	var ui_with_photo = image_options.get_node("GridWithPhoto")
	ui_with_photo.set_pressed(photo.get_save_grid_with_photo())
	
	image_options.visible = true
	grids.visible = true
	save.disabled = false

#
# Main Buttons
#

func _on_LoadPhoto_pressed():
	open_file_dialog.popup()

func _on_SetSavePath_pressed():
	save_as_dialog.popup()

func _on_Save_pressed():
	photo.capture_to_file()
	
#
# Dialogs
#

func _on_OpenFileDialog_file_selected(path):
	loaded_photo_path = path
	_reload_ui()
	
	var tex = ImageTexture.new()
	tex.load(path)
	photo.set_texture(tex)
	photo.reload()

func _on_SaveAsDialog_file_selected(path):
	photo.set_save_path(path)

#
# Image Options
#

func _on_Scale_value_changed(value):
	if not has_photo(): return
	if value == photo.get_scale(): return
	
	photo.set_scale(value)
	photo.reload()
	_reload_ui()

func _on_GridWithPhoto_pressed():
	photo.set_save_grid_with_photo(!photo.get_save_grid_with_photo())

#
# Grids
#

func _get_grid_settings(grid_type_pos):
	return photo.get_grid_settings()[grid_type_pos]

func _on_Visible_pressed(grid_type):
	photo.set_grid_visible(grid_type, !_get_grid_settings(grid_type).visible)
	photo.reload()

func _on_Width_value_changed(value, grid_type):
	if not has_photo(): return
	var current = _get_grid_settings(grid_type).width
	
	if current != value:
		photo.set_grid_width(grid_type, value)
		photo.reload()
		_reload_ui()


func _on_Color_color_changed(color, grid_type):
	if not has_photo(): return
	var current = _get_grid_settings(grid_type).color
	
	if current != color:
		photo.set_grid_color(grid_type, color)
		photo.reload()
		_reload_ui()
