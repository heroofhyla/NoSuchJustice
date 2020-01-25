extends KinematicBody2D

export var event_script = ""
onready var event_system = get_node("/root/Game/EventSystem")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show_interactable():
	$MessageBubble.visible = true

func hide_interactable():
	$MessageBubble.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	z_index = position.y
#	pass

func interact():
	if event_script:
		event_system.execute(self,event_script)