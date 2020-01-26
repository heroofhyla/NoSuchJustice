extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum states {
	IDLE,
	BUSY,
	READY_SHOW_MESSAGE
}

onready var current_map = get_node("/root/Game/Map")
onready var game = get_node("/root/Game")
enum message_types{
	MESSAGE,
	THOUGHT
}
var current_script = []
var current_line = 0
export var state = states.IDLE
var next_state = states.READY_SHOW_MESSAGE
var variables = {}
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
		handle(current_script[current_line])
		current_line += 1

func handle(script_line):
	var action = script_line.split(" ")[0]
	if action == "portrait":
		handle_portrait(script_line)
	if action == "message":
		handle_message(script_line, message_types.MESSAGE)
	if action == "cleanup":
		handle_cleanup(script_line)
	if action == "finish":
		handle_finish(script_line)
	if action == "set":
		handle_set(script_line)
	if action == "jumpif":
		handle_jumpif(script_line)
	if action == "thought":
		handle_message(script_line, message_types.THOUGHT)

func handle_set(script_line):
	print_debug(script_line)
	var parts = script_line.split(" ", 3)
	var variable = parts[1].replace("@","")
	variables[variable] = parts[2]
	print_debug(variable + " => " + variables[variable])

func parse_expression(expr_string):
	var expression = Expression.new()
	var expr_vars = []
	if "@" in expr_string:
		for expr_var in expr_string.split("@"):
			if not expr_var:
				continue
			var trimmed_expr_var = expr_var.split(" ")[0]
			expr_vars.append(trimmed_expr_var)
			if not trimmed_expr_var in variables:
				variables[trimmed_expr_var] = null
		print_debug(expr_vars)
	expr_string = expr_string.replace("@", "")
	var error = expression.parse(expr_string, expr_vars)
	if error != OK:
		print_debug("jumpif failed to evaluate " + expr_string)
	var result_vars = []
	for expr_var in expr_vars:
		result_vars.append(variables[expr_var])
	var result = expression.execute(result_vars)
	return result
	
func handle_jumpif(script_line):
	var parts = script_line.split(" ", 3)
	var label = parts[1]
	var expr_string = parts[2]
	var res = parse_expression(expr_string)
	
	if not res:
		return
	for i in range(0, len(current_script)):
		var test_line = current_script[i].split(" ")
		if test_line[0] == "label":
			if test_line[1] == label:
				current_line = i
				return
	print_debug("couldn't find " + label)
	
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

func handle_finish(script_line):
	handle_cleanup(script_line)
	current_script = []
	current_line = 0
	state = states.IDLE

func handle_message(script_line, message_type):
	if message_type == message_types.MESSAGE:
		$MessageBubble.texture = load("res://img/big_message_bubble.png")
	elif message_type == message_types.THOUGHT:
		$MessageBubble.texture = load("res://img/big_thought_bubble.png")
	else:
		print_debug("can't recognize " + message_type)
	state = states.BUSY
	var parts = script_line.split(" ", true, 2)
	if parts[1] == "left":
		$MessageBubble.flip_h = false
		$TextHolder.position.x = 51
	elif parts[1] == "right":
		$TextHolder.position.x = 8
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
	current_script.append("finish")
	current_line = 0

func execute(entity, new_script):
	load_script(new_script)

func _on_Timer_timeout():
	state = next_state
	next_state = states.IDLE
	pass # Replace with function body.

func set_player_pos(map_instance, new_x, new_y):
	var player = map_instance.get_node("Hero")
	player.position = Vector2(new_x, new_y)
	print_debug('setting position of ' + str(player))
func load_map(target_map, new_x, new_y):
	current_map.queue_free()
	var map_instance = target_map.instance()
	game.call_deferred("add_child", map_instance)
	call_deferred("set_player_pos", map_instance, new_x, new_y)
	current_map = map_instance
	