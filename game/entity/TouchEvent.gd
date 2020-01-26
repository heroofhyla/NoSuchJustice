tool
extends Area2D

onready var event_system = get_node("/root/Game/EventSystem")
export var event_script = ""
export (Vector2) var field_size = Vector2(20,20) setget set_field_size, get_field_size
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_field_size(size):
	if has_node("CollisionShape2D"):
		$CollisionShape2D.shape = RectangleShape2D.new()
		$CollisionShape2D.shape.extents = size

func get_field_size():
	if has_node("CollisionShape2D"):
		return $CollisionShape2D.get_shape().extents
func touch_trigger():
	event_system.execute(self,event_script)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
