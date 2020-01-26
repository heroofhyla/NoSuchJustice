extends Area2D

onready var event_system = get_node("/root/Game/EventSystem")
export var target_map = ""
export (int) var new_x
export (int) var new_y
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func touch_trigger():
	event_system.load_map(load("res://scene/" + target_map + ".tscn"), new_x, new_y)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
