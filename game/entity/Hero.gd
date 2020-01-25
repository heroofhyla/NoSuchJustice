extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var speed = 200
var input_vector = Vector2(0,0)
var interactables = []
onready var event_system = get_node("/root/Game/EventSystem")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	z_index = position.y
#	pass

func _physics_process(delta):
	if event_system.state != event_system.states.IDLE:
		return
		
	input_vector = Vector2(0,0)
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if input_vector != Vector2(0,0):
		move_and_slide(input_vector.normalized() * speed)
	if Input.is_action_just_pressed("ui_accept"):
		if interactables:
			interactables[0].interact()

func _on_Interact_area_entered(area):
	if area.is_in_group("interact"):
		var area_parent = area.get_parent()
		if not area_parent in interactables:
			if interactables:
				interactables[0].hide_interactable()
			interactables.push_front(area_parent)
			interactables[0].show_interactable()


func _on_Interact_area_exited(area):
	var area_parent = area.get_parent()
	if area.is_in_group("interact"):
		area_parent.hide_interactable()
		interactables.erase(area_parent)
		if interactables:
			interactables[0].show_interactable()
