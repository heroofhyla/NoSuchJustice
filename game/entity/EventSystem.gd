extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum states {
	IDLE,
	BUSY,
	READY_SHOW_MESSAGE
}
var current_script = []
export var state = states.IDLE
var next_state = states.READY_SHOW_MESSAGE
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	if state == states.BUSY:
		return
	
	if state == states.READY_SHOW_MESSAGE and Input.is_action_just_pressed("ui_accept"):
		state = states.IDLE
	while state == states.IDLE and current_script:
		handle(current_script.pop_front())

func handle(script_line):
	var action = script_line.split(" ")[0]
	if action == "portrait":
		handle_portrait(script_line)
	if action == "message":
		handle_message(script_line)
	if action == "cleanup":
		handle_cleanup(script_line)

func handle_portrait(script_line):
	var parts = script_line.split(" ")
	if parts[1] == "right":
		$RightPortrait.visible = true
		$RightPortrait.texture = load("res://img/" + parts[2] + "_portrait.png")
	elif parts[1] == "left":
		$LeftPortrait.visible = true
		$LeftPortrait.texture = load("res://img/" + parts[2] + "_portrait.png")
	else:
		print_debug("can't recognize '" + parts[1])

func handle_cleanup(script_line):
	$RightPortrait.visible = false
	$LeftPortrait.visible = false
	$MessageBubble.visible = false
	$TextHolder.visible = false
	
func handle_message(script_line):
	state = states.BUSY
	var parts = script_line.split(" ", true, 2)
	if parts[1] == "left":
		$MessageBubble.flip_h = false
		$TextHolder.position.x = 0
	elif parts[1] == "right":
		$TextHolder.position.x = 61
		$MessageBubble.flip_h = true
	else:
		print_debug("can't recognize '" + parts[1] + "'")
	$MessageBubble.visible = true
	$TextHolder.visible = true
	$TextHolder/Text.text = parts[2]
	next_state = states.READY_SHOW_MESSAGE
	$Timer.start(0.25)
	
func load_script(new_script):
	current_script = []
	var f = File.new()
	f.open("scripts/" + new_script + ".txt", File.READ)
	while not f.eof_reached():
		current_script.append(f.get_line())
	current_script.append("cleanup")

func execute(entity, new_script):
	load_script(new_script)

func _on_Timer_timeout():
	state = next_state
	next_state = states.IDLE
	pass # Replace with function body.
