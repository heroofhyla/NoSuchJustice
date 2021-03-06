tool
extends KinematicBody2D

export var event_script = ""
onready var event_system = get_node("/root/Game/EventSystem")
export(Texture) var sprite = preload("res://img/buddy.png") setget set_sprite, get_sprite
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_sprite(new_sprite):
	sprite = new_sprite
	$Sprite.texture = new_sprite

func get_sprite():
	return $Sprite.texture
func show_interactable():
	if event_script:
		$MessageBubble.visible = true

func hide_interactable():
	$MessageBubble.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.editor_hint:
		return
	z_index = int(position.y)
#	pass

func interact():
	if event_script:
		event_system.execute(self,event_script)