extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum states {
	IDLE,
	BUSY_SHOW_MESSAGE,
	READY_SHOW_MESSAGE
}
var current_script = []
export var state = states.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	while state == states.IDLE and current_script:
		handle(current_script.pop_front())

func handle(script_line):
	if "portrait" in script_line:
		handle_portrait(script_line)
	if "message" in script_line:
		handle_message(script_line)

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

func handle_message(script_line):
	state = states.BUSY_SHOW_MESSAGE
func load_script(new_script):
	current_script = []
	var f = File.new()
	f.open("scripts/" + new_script + ".txt", File.READ)
	while not f.eof_reached():
		current_script.append(f.get_line())

func execute(entity, new_script):
	load_script(new_script)