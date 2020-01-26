extends Node2D
export var event_script = ""
onready var event_system = get_node("/root/Game/EventSystem")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	if event_script:
		event_system.execute(self,event_script)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
