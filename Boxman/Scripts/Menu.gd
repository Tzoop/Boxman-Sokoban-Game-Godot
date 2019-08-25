extends Node

var x_start
var x_colors
var x_volume
var volume_text
var game_done_by_text
var level_scene
var shader_one
var shader_two
var shader_three
var shader_four
var shader_five
var shader_six
var shader_seven
var shader_eight
var level_scene_instance
var audio_stream_player_sound
var step_sound
var audio_stream_player_music
var music_track_one
var music_track_two

func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
	music_track_one = preload("res://Music/sample_friday23.ogg")
	music_track_two = preload("res://Music/sampl2_friday23.ogg")
	audio_stream_player_sound = get_parent().get_node("AudioStreamPlayerSound")
	audio_stream_player_music = get_parent().get_node("AudioStreamPlayerMusic")
	audio_stream_player_music.stream = music_track_two
	audio_stream_player_music.play()
	step_sound = preload("res://Sounds/step2.wav")
	level_scene = preload("res://Scenes/Level.tscn")
	shader_one = get_parent().get_node("ColorRectBlue")
	shader_two = get_parent().get_node("ColorRectOrange")
	shader_three = get_parent().get_node("ColorRectPink")
	shader_four = get_parent().get_node("ColorRectGameBoyColors")
	shader_five = get_parent().get_node("ColorRectGrapefruit")
	shader_six = get_parent().get_node("ColorRectCrimson")
	shader_seven = get_parent().get_node("ColorRectEndesga")
	shader_eight = get_parent().get_node("ColorRectGrayScale")
	x_start = get_node("XStartText")
	x_colors = get_node("XColorsText")
	x_volume = get_node("XVolumeText")
	volume_text = get_node("VolumeText")
	volume_text.text = "Volume: full"
	game_done_by_text = get_node("GameDoneByText")
	x_start.visible = true
	x_colors.visible = false
	x_volume.visible = false
	level_scene_instance = level_scene.instance()

func _process(_delta):
	if Input.is_action_just_pressed("ui_down"):
		audio_stream_player_sound.stream = step_sound
		audio_stream_player_sound.play()
		if x_start.visible == true:
			x_start.visible = false
			x_colors.visible = true
		elif x_colors.visible == true:
			x_colors.visible = false
			x_volume.visible = true
	elif Input.is_action_just_pressed("ui_up"):
		audio_stream_player_sound.stream = step_sound
		audio_stream_player_sound.play()
		if x_colors.visible == true:
			x_colors.visible = false
			x_start.visible = true
		elif x_volume.visible == true:
			x_volume.visible = false
			x_colors.visible = true
	if x_start.visible == true:
		if Input.is_action_just_pressed("ui_button_a")\
			or Input.is_action_just_pressed("ui_button_start")\
			or Input.is_action_just_pressed("ui_right"):
			audio_stream_player_sound.stream = step_sound
			audio_stream_player_sound.play()
			get_parent().add_child(level_scene_instance)
			get_parent().move_child(level_scene_instance, 0)
			queue_free()
	elif x_colors.visible == true:
		if Input.is_action_just_pressed("ui_button_a")\
			or Input.is_action_just_pressed("ui_button_start")\
			or Input.is_action_just_pressed("ui_right"):
				audio_stream_player_sound.stream = step_sound
				audio_stream_player_sound.play()
				if shader_one.visible == false\
					and shader_two.visible == false\
					and shader_three.visible == false\
					and shader_four.visible == false\
					and shader_five.visible == false\
					and shader_six.visible == false\
					and shader_seven.visible == false\
					and shader_eight.visible == false:
					shader_one.visible = true
				elif shader_one.visible == true:
					shader_one.visible = false
					shader_two.visible = true
				elif shader_two.visible == true:
					shader_two.visible = false
					shader_three.visible = true
				elif shader_three.visible == true:
					shader_three.visible = false
					shader_four.visible = true
				elif shader_four.visible == true:
					shader_four.visible = false
					shader_five.visible = true
				elif shader_five.visible == true:
					shader_five.visible = false
					shader_six.visible = true
				elif shader_six.visible == true:
					shader_six.visible = false
					shader_seven.visible = true
				elif shader_seven.visible == true:
					shader_seven.visible = false
					shader_eight.visible = true
				elif shader_eight.visible == true:
					shader_eight.visible = false
		if Input.is_action_just_pressed("ui_button_b")\
			or Input.is_action_just_pressed("ui_left"):
				audio_stream_player_sound.stream = step_sound
				audio_stream_player_sound.play()
				if shader_one.visible == false\
					and shader_two.visible == false\
					and shader_three.visible == false\
					and shader_four.visible == false\
					and shader_five.visible == false\
					and shader_six.visible == false\
					and shader_seven.visible == false\
					and shader_eight.visible == false:
					shader_eight.visible = true
				elif shader_eight.visible == true:
					shader_eight.visible = false
					shader_seven.visible = true
				elif shader_seven.visible == true:
					shader_seven.visible = false
					shader_six.visible = true
				elif shader_six.visible == true:
					shader_six.visible = false
					shader_five.visible = true
				elif shader_five.visible == true:
					shader_five.visible = false
					shader_four.visible = true
				elif shader_four.visible == true:
					shader_four.visible = false
					shader_three.visible = true
				elif shader_three.visible == true:
					shader_three.visible = false
					shader_two.visible = true
				elif shader_two.visible == true:
					shader_two.visible = false
					shader_one.visible = true
				elif shader_one.visible == true:
					shader_one.visible = false
	elif x_volume.visible == true:
		if Input.is_action_just_pressed("ui_button_a")\
			or Input.is_action_just_pressed("ui_button_start")\
			or Input.is_action_just_pressed("ui_right")\
			or Input.is_action_just_pressed("ui_left"):
				audio_stream_player_sound.stream = step_sound
				audio_stream_player_sound.play()
				if volume_text.text == "Volume: full":
					AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -30)
					volume_text.text = "Volume: half"
				elif volume_text.text == "Volume: half":
					AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -90)
					volume_text.text = "Volume: none"
				elif volume_text.text == "Volume: none":
					AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
					volume_text.text = "Volume: full"
		game_done_by_text.visible = true
