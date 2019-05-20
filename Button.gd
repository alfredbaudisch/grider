extends Button

export(NodePath) var photo
export(NodePath) var file_dialog
export(NodePath) var save_as_dialog

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
  var dialog : FileDialog = get_node(file_dialog)
	#dialog.show_modal(true)
  dialog.popup()
	
	
"""
ButtonDemo.gd

extends Button

func _on_Button_pressed():
  self.text = "Clicked!"


func _on_Button_mouse_entered():
  self.add_color_override("font_color_hover", Color(0,0,0))
 

DynamicThemeOnButtonScript.gd

extends Button


func _ready():
  var myTheme = Theme.new()
  myTheme.set_color("font_color","Button", Color(0,0,1))
  self.set_theme(myTheme)


Dialogs.gd

extends Node

func _ready():
  # The following line wires the cancel button of the dialog to our local function
  $FileDialog.get_cancel().connect("pressed",self,"_on_Cancel")
  # The following commented out line of code displays the dialog modally
  #$FileDialog.show_modal(true)
  # While this version displays the dialog as a movable popup button
  #$FileDialog.popup()
  
  # The following code would be called if you had a node named AcceptDialog added to your scene already
  #$AcceptDialog.get_label().text = "You OK with this?"
  #$AcceptDialog.popup_centered()
  
  #This code creates a dialog for displaying text to the end user progammatically
  var diag = AcceptDialog.new()
  diag.get_label().text = "You OK with this?"
  self.add_child(diag)
  diag.popup_centered()
  
  

func _on_Cancel():
  print("Cancelled")

func _on_FileDialog_file_selected( path ):
  print("File selected at " + path)


LoadBitmapFont.gd
extends Label

func _ready():
  var font = load("res://myfont.fnt");
  self.add_font_override("font",font)

"""

func _on_FileDialog_file_selected(path):
	print(path)
	
	var imagetexture = ImageTexture.new()
	imagetexture.load(path)
	photo.set_texture(imagetexture)
	photo.reload()
	
func _on_Button4_pressed():
  var dialog : FileDialog = get_node(save_as_dialog)
  dialog.popup()


func _on_SaveAsDialog_file_selected(path):
	photo.set_save_path(path)


func _on_Width_value_changed(value):
	print(value)


func _on_Visible_toggled(button_pressed):
	print(button_pressed)
