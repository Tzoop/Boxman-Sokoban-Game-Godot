extends Node

var file = File.new()
var levelDict = [] #2d array : []-> row ("y-axis value"), then []-> cell ("x-axis value")

var Wall
var Ground
var Place
var BoxBright
var BoxDark
var Player
var x
var y
var step

var player = '@'
var player_on_storage = '+'
var box = '$'
var box_on_storage = '*'
var storage = '.'
var wall = '#'
var empty = ' '

var previous_level_dict
var lineLength
var number_of_lines
var nodes_queued_free

var complete
var current_level
var level_number

var level1 = "res://Levels/Level1.txt"
var level2 = "res://Levels/Level2.txt"
var level3 = "res://Levels/Level3.txt"
var level4 = "res://Levels/Level4.txt"
var level5 = "res://Levels/Level5.txt"
var level6 = "res://Levels/Level6.txt"
var level7 = "res://Levels/Level7.txt"
var level8 = "res://Levels/Level8.txt"
var level9 = "res://Levels/Level9.txt"
var level10 = "res://Levels/Level10.txt"
var level11 = "res://Levels/Level11.txt"
var level12 = "res://Levels/Level12.txt"
var level13 = "res://Levels/Level13.txt"
var level14 = "res://Levels/Level14.txt"
var level15 = "res://Levels/Level15.txt"
var level16 = "res://Levels/Level16.txt"

var level_change_timer
var level_change_timer_started
var current_level_text
var well_done_text
var ui_border
var audio_stream_player_sound
var audio_stream_player_music
var step_sound 
var level_complete_sound
var music_track_one
var music_track_two
var pause_text
var unpause_text
var x_unpause_text
var back_to_menu_text
var x_back_to_menu_text
var game_scene
var pause_background

func _ready():
	game_scene = "res://Scenes/Game.tscn"
	pause_text = get_parent().get_node("PauseText")
	unpause_text = get_parent().get_node("UnpauseText")
	x_unpause_text = get_parent().get_node("XUnpauseText")
	back_to_menu_text = get_parent().get_node("BackToMenuText")
	x_back_to_menu_text = get_parent().get_node("XBackToMenuText")
	pause_background = get_parent().get_node("PauseBackground")
	pause_text.visible = false
	unpause_text.visible = false
	x_unpause_text.visible = false
	back_to_menu_text.visible = false
	x_back_to_menu_text.visible = false
	pause_background.visible = false
	music_track_one = preload("res://Music/sample_friday23.ogg")
	music_track_two = preload("res://Music/sampl2_friday23.ogg")
	audio_stream_player_sound = get_parent().get_node("AudioStreamPlayerSound")
	audio_stream_player_music = get_parent().get_node("AudioStreamPlayerMusic")
	audio_stream_player_music.stream = music_track_one
	audio_stream_player_music.play()
	step_sound = preload("res://Sounds/step2.wav")
	level_complete_sound = preload("res://Sounds/good_sound.wav")
	ui_border = get_parent().get_node("UiBorder")
	ui_border.visible = true
	well_done_text = get_parent().get_node("WellDoneText")
	current_level_text = get_parent().get_node("CurrentLevelText")
	current_level_text.visible = true
	well_done_text.visible = false
	level_number = 1
	level_change_timer_started = false
	current_level = level1
	nodes_queued_free = true
	step = 16
	x = 16
	y = 16
	Wall = preload("res://Scenes/Wall.tscn")
	Ground = preload("res://Scenes/Ground.tscn")
	Place = preload("res://Scenes/Place.tscn")
	BoxBright = preload("res://Scenes/BoxBright.tscn")
	BoxDark = preload("res://Scenes/BoxDark.tscn")
	Player = preload("res://Scenes/Player.tscn")
	check_file()
	open_file()
	create_level_array()
	nodes_queued_free = false
	pass

func _process(_delta):
	if not well_done_text.visible \
	and not pause_text.visible:
		if not current_level_text.text == "the End":
			position_check()
	check_for_pause()

func check_file():
	if not file.file_exists(current_level):
		print ("No file saved!")
		return

func open_file():
	if file.open(current_level, File.READ) != 0:
		print ("Error opening file")
		return

func check_for_pause():
	if pause_text.visible == true:
		well_done_text.visible = false
	if pause_text.visible == false:
		if Input.is_action_just_pressed("ui_button_start"):
			audio_stream_player_music.set_stream_paused(true)
			pause_background.visible = true
			pause_text.visible = true
			unpause_text.visible = true
			x_unpause_text.visible = true
			back_to_menu_text.visible = true
			x_back_to_menu_text.visible = false
	elif pause_text.visible == true:
		if x_unpause_text.visible == true \
			and x_back_to_menu_text.visible == false:
			if Input.is_action_just_pressed("ui_button_start") \
			or Input.is_action_just_pressed("ui_button_a") \
			or Input.is_action_just_pressed("ui_right"):
				audio_stream_player_music.set_stream_paused(false)
				if current_level_text.text == "the End":
					well_done_text.visible = true
				pause_background.visible = false
				pause_text.visible = false
				unpause_text.visible = false
				x_unpause_text.visible = false
				back_to_menu_text.visible = false
				x_back_to_menu_text.visible = false
			if Input.is_action_just_pressed("ui_down"):
				pause_text.visible = true
				unpause_text.visible = true
				x_unpause_text.visible = false
				back_to_menu_text.visible = true
				x_back_to_menu_text.visible = true
	if pause_text.visible == true \
		and x_back_to_menu_text.visible == true:
			if Input.is_action_just_pressed("ui_button_start") \
			or Input.is_action_just_pressed("ui_button_a") \
			or Input.is_action_just_pressed("ui_right"):
				get_tree().reload_current_scene()
			if Input.is_action_just_pressed("ui_up"):
				pause_text.visible = true
				unpause_text.visible = true
				x_unpause_text.visible = true
				back_to_menu_text.visible = true
				x_back_to_menu_text.visible = false

func create_level_array():
	number_of_lines = 0
	var lineArray = []
	var i = 0
	file.open(current_level, File.READ)
	while not file.eof_reached():
		var line = file.get_line()
		lineLength = line.length()
		while i < lineLength:
			lineArray.append(line.substr(i, 1))
			i+=1
			if i == lineLength:
				levelDict.append(str2var(var2str(lineArray))) #not the lineArray itself is appended, because it will be cleared later
				number_of_lines += 1
				lineArray.clear()
		i = 0
	print(levelDict)

func find_player():
	previous_level_dict = str2var(var2str(levelDict))
	var test_y = 0 #row
	var test_x = 0 #cell
	for i in levelDict:
		test_y += 1
		test_x = 0
		for j in i:
			test_x += 1
			if j == player:
				print("player at: cell: ", test_x," row: ", test_y)

func position_check():
	if !nodes_queued_free:
		queue_nodes_free()
	if not complete:
		if Input.is_action_just_pressed("ui_button_b"):
			if not previous_level_dict == null:
				levelDict = str2var(var2str(previous_level_dict))
		if Input.is_action_just_pressed("ui_left") \
		or Input.is_action_just_pressed("ui_right") \
		or Input.is_action_just_pressed("ui_up") \
		or Input.is_action_just_pressed("ui_down"):
			audio_stream_player_sound.stream = step_sound
			audio_stream_player_sound.play()
			if str2var(var2str(previous_level_dict)) != str2var(var2str(levelDict)):
				previous_level_dict = str2var(var2str(levelDict))
			var player_y #row
			var player_x #cell
			var test_y = 0 #row
			var test_x = 0 # cell
			for i in levelDict:
				test_y +=1
				test_x = 0
				for j in i:
					test_x += 1
					if j == player or j == player_on_storage:
						player_x = test_x
						player_y = test_y
			var direction_x = 0
			var direction_y = 0
			if Input.is_action_just_pressed("ui_left"):
				direction_x = -1
			elif Input.is_action_just_pressed("ui_right"):
				direction_x = 1
			elif Input.is_action_just_pressed("ui_up"):
				direction_y = -1
			elif Input.is_action_just_pressed("ui_down"):
				direction_y = 1
			var current
			current =levelDict[player_y-1][player_x-1]
			var adjacent
			adjacent = levelDict[player_y + direction_y -1][player_x + direction_x -1]
			var beyond
			if player_x + direction_x + direction_x - 1 <= lineLength - 1 \
				and player_y + direction_y + direction_y -1 <= number_of_lines -1:
				beyond = levelDict[player_y + direction_y + direction_y -1] \
				[player_x + direction_x + direction_x -1]
			var next_adjacent = {empty : player, storage : player_on_storage}
			var next_current = {player : empty, player_on_storage : storage}
			var next_beyond = {empty : box, storage : box_on_storage}
			var next_adjacent_push = {box : player, box_on_storage : player_on_storage}
			if next_adjacent.has(adjacent):
				levelDict[player_y -1][player_x -1] = next_current[current]
				levelDict[player_y + direction_y -1][player_x + direction_x -1] = next_adjacent[adjacent]
			elif next_beyond.has(beyond) and next_adjacent_push.has(adjacent):
				levelDict[player_y -1][player_x -1] = next_current[current]
				levelDict[player_y + direction_y -1][player_x + direction_x -1] = next_adjacent_push[adjacent]
				levelDict[player_y + direction_y + direction_y -1][player_x + direction_x + direction_x -1] = next_beyond[beyond]
	if Input.is_action_just_released("ui_left")\
	or Input.is_action_just_released("ui_right")\
	or Input.is_action_just_released("ui_up")\
	or Input.is_action_just_released("ui_down"):
		nodes_queued_free = false
	complete = true
	for i in levelDict:
		for j in i:
			if j == box:
				complete = false
	if complete:
		previous_level_dict = null
		if not level_change_timer_started:
			audio_stream_player_sound.stream = level_complete_sound
			audio_stream_player_sound.play()
			print("complete")
			level_change_timer = Timer.new()
			level_change_timer.set_wait_time(2)
			level_change_timer.connect("timeout", self, "_on_level_change_timer_timeout")
			get_parent().add_child(level_change_timer)
			level_change_timer.start()
			level_change_timer_started = true
	if Input.is_action_just_pressed("ui_button_a"):
		levelDict.clear()
		create_level_array()

func _on_level_change_timer_timeout():
		level_change_timer_started = false
		level_number += 1
		if level_number == 2:
			current_level = level2
			current_level_text.text = "Level 1-2"
		elif level_number == 3:
			current_level = level3
			current_level_text.text = "Level 1-3"
		elif level_number == 4:
			current_level = level4
			current_level_text.text = "Level 1-4"
		elif level_number == 5:
			current_level = level5
			current_level_text.text = "Level 2-1"
			audio_stream_player_music.stream = music_track_two
			audio_stream_player_music.play()
		elif level_number == 6:
			current_level = level6
			current_level_text.text = "Level 2-2"
		elif level_number == 7:
			current_level = level7
			current_level_text.text = "Level 2-3"
		elif level_number == 8:
			current_level = level8
			current_level_text.text = "Level 2-4"
		elif level_number == 9:
			current_level = level9
			current_level_text.text = "Level 3-1"
			audio_stream_player_music.stream = music_track_one
			audio_stream_player_music.play()
		elif level_number == 10:
			current_level = level10
			current_level_text.text = "Level 3-2"
		elif level_number == 11:
			current_level = level11
			current_level_text.text = "Level 3-3"
		elif level_number == 12:
			current_level = level12
			current_level_text.text = "Level 3-4"
		elif level_number == 13:
			current_level = level13
			current_level_text.text = "Level 4-1"
			audio_stream_player_music.stream = music_track_two
			audio_stream_player_music.play()
		elif level_number == 14:
			current_level = level14
			current_level_text.text = "Level 4-2"
		elif level_number == 15:
			current_level = level15
			current_level_text.text = "Level 4-3"
		elif level_number == 16:
			current_level = level16
			current_level_text.text = "Level 4-4"
		else:
			current_level_text.text = "the End"
			level_number += 1
			well_done_text.visible = true
			audio_stream_player_music.stream = music_track_one
			audio_stream_player_music.play()
			for node in get_children():
				node.queue_free()
		levelDict.clear()
		check_file()
		open_file()
		create_level_array()
		level_change_timer.stop()

func queue_nodes_free():
	if !nodes_queued_free:
		for node in get_children():
			node.queue_free()
		apply_player_movement_to_level()

func apply_player_movement_to_level():
	if lineLength >= 9:
		x = 16
	elif lineLength == 8:
		x = 24
	elif lineLength == 7:
		x = 32
	elif lineLength == 6:
		x = 40
	else:
		x= 48
	var x_default = x
	y = 16
	var x_dict = 0
	for j in levelDict:
		y += step
		for i in j:
			var ground_instance
			if i == wall:
				var wall_instance = Wall.instance()
				wall_instance.position = Vector2(x, y)
				wall_instance = Wall.instance()
				wall_instance.position = Vector2(x, y)
				add_child(wall_instance)
				x += step
			elif i == player:
				ground_instance = Ground.instance()
				ground_instance.position = Vector2(x, y)
				add_child(ground_instance)
				var player_instance = Player.instance()
				player_instance.position = Vector2(x, y)
				add_child(player_instance)
				x += step
			elif i == player_on_storage:
				ground_instance = Ground.instance()
				ground_instance.position = Vector2(x, y)
				add_child(ground_instance)
				var player_instance = Player.instance()
				player_instance.position = Vector2(x, y)
				add_child(player_instance)
				x += step
			elif i == empty:
				ground_instance = Ground.instance()
				ground_instance.position = Vector2(x, y)
				add_child(ground_instance)
				x += step
			elif i == box:
				ground_instance = Ground.instance()
				ground_instance.position = Vector2(x, y)
				add_child(ground_instance)
				var box_instance = BoxBright.instance()
				box_instance.position = Vector2(x, y)
				add_child(box_instance)
				x += step
			elif i == box_on_storage:
				ground_instance = Ground.instance()
				ground_instance.position = Vector2(x, y)
				add_child(ground_instance)
				var place_instance = Place.instance()
				place_instance.position = Vector2(x, y)
				add_child(place_instance)
				var box_instance = BoxDark.instance()
				box_instance.position = Vector2(x, y)
				add_child(box_instance)
				x += step
			elif i == storage:
				ground_instance = Ground.instance()
				ground_instance.position = Vector2(x, y)
				add_child(ground_instance)
				var place_instance = Place.instance()
				place_instance.position = Vector2(x, y)
				add_child(place_instance)
				x += step
			x_dict += 1
			if x_dict == lineLength:
				x = x_default
				x_dict = 0
