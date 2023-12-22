extends Node
# https://docs.godotengine.org/en/stable/classes/class_fileaccess.html
# https://docs.godotengine.org/en/stable/tutorials/io/binary_serialization_api.html#doc-binary-serialization-api 

# Password for file encryption and decryption, you would likely want to change this in your application
var password: String = "12345"  

# Objects, Paths, Open/Close Functions.
var s_file = FileAccess # File object opened by the FileAccess library
var globals_filepath: String = "user://globals.sav"


func _get_level_filepath(level_name: String):
	return "user://" + level_name + ".sav"


func _open_file(access : FileAccess.ModeFlags, filepath: String) -> int:
	# Try opening an encrypted file with write access
	s_file = FileAccess.open_encrypted_with_pass(filepath, access, password)
	# Return the assigned file index (handle)
	return FileAccess.get_open_error() if (s_file == null) else OK
	
	
func _close_file() -> void:
	s_file = null


# Save/Load functions
func save_game(level_name: String):
	_save_globals()
	_save_level(level_name)


func load_game(level_name: String):
	pass
	_load_globals()
	_load_level(level_name)


func clear_save():
	DirAccess.remove_absolute(globals_filepath)
	for level_name in Globals.levels:
		DirAccess.remove_absolute(_get_level_filepath(level_name))
	Globals.current_level = "Level1"
	Globals.player_lives = 5
	Globals.player_position = Vector2(104, 104)  # This is the starting position on a new map
	Globals.coin_counter = {
		"star": 0,
		"diamond": 0,
	}
	Globals.points_per_level = {
		"Level1": 0,
		"Level2": 0,
		"Level3": 0,
		"Level4": 0,
		"Level5": 0,
	}


func _save_globals():
#	print_debug("Saving Globals Binary")
	# Open and check file
	var status = _open_file(FileAccess.WRITE, globals_filepath)
	if (status != OK): 
		print("Unable to open the file %s. Received error: %d" % [globals_filepath, status])
		return
	# Serialize data to file
	_serialize_globals()
	# Close the file
	_close_file()


func _load_globals():
	# Open and check file
#	print_debug("Loading Globals from Binary")
	var status = _open_file(FileAccess.READ, globals_filepath)
	if (status != OK): 
		print("Unable to open the file %s. Received error: %d" % [globals_filepath, status])
		return
	_deserialize_globals()
	# Close the file
	_close_file()


func _serialize_globals() -> void:
	s_file.store_pascal_string(Globals.current_level)
	s_file.store_32(Globals.player_lives)
	s_file.store_32(Globals.player_position.x)
	s_file.store_32(Globals.player_position.y)
	s_file.store_pascal_string(JSON.stringify(Globals.coin_counter))
	s_file.store_pascal_string(JSON.stringify(Globals.points_per_level))


func _deserialize_globals() -> void:
	Globals.current_level = s_file.get_pascal_string()
	Globals.player_lives = s_file.get_32()
	Globals.player_position = Vector2(s_file.get_32(), s_file.get_32())
	Globals.coin_counter = JSON.parse_string(s_file.get_pascal_string())
	Globals.points_per_level = JSON.parse_string(s_file.get_pascal_string())


func _serialize_node(node) -> void:
	# This function serializes any nodes in the group "persist"
	# Some tutorials create specific serialize/deserialize functions for each node.
	#	but for slightly, but not overly complex games, I find this a tractable way to 
	#	store save data
	# Filepath, Parent, Name, and Position are stored for every persisted node.
	s_file.store_pascal_string(node.get_scene_file_path())  # Always store scene path first so you can use this to deserialize
	s_file.store_pascal_string(node.get_parent().get_path()) # Always store scene parent second so that new object can be created
	s_file.store_pascal_string(node.name)
	s_file.store_float(node.global_position.x)
	s_file.store_float(node.global_position.y)
	
	# Some nodes may have additional attributes.
	if node.get_scene_file_path() == "res://scenes/coin.tscn":
		s_file.store_pascal_string(node.coin_type)


func _deserialize_nodes() -> void: 
	# Here we are deserializing all nodes by unpacking the level save file
	while s_file.get_position() < s_file.get_length():
		# We will first retrieve shared attributes for all nodes.
		var node_filepath = s_file.get_pascal_string()
		var node_parent = s_file.get_pascal_string()
		var new_object = load(node_filepath).instantiate()
		new_object.name = s_file.get_pascal_string()
		new_object.global_position = Vector2(s_file.get_float(), s_file.get_float())
		
		# Then for any nodes with additional stored attributes, unpack those.
		if node_filepath == "res://scenes/coin.tscn":
			new_object.coin_type = s_file.get_pascal_string()

		# Now that all properties of the node are unpacked and assigned 
		#  add the node to the parent scene.
		get_node(node_parent).add_child(new_object)  


func _save_level(level_name: String):
	# For this game, we don't actually need to save each level individually. But, I have structured
	#	things this way to illustrate how you might save things in a game where you can reenter
	#	multiple levels and want to preserve the state of a previous playthrough (for example, 
	#	in a game like Super Mario 3).
	# Open and check file
	var status = _open_file(FileAccess.WRITE, _get_level_filepath(level_name))
	if (status != OK): 
		print("Unable to open the file %s. Received error: %d" % [_get_level_filepath(level_name), status])
		return

	var save_nodes = get_tree().get_nodes_in_group("persist")
	for node in save_nodes:
		_serialize_node(node)
	_close_file()


func _load_level(level_name: String):
	# Open and check file
	var status = _open_file(FileAccess.READ, _get_level_filepath(level_name))
	if (status != OK): 
		print("Unable to open the file %s. Received error: %d" % [_get_level_filepath(level_name), status])
		return
	var save_nodes = get_tree().get_nodes_in_group("persist")  # Any nodes here must be serialized in serialize_node and deserialized in deserialize_nodes
	
	# For all persisted node types, we need to remove all instances from the game before 
	#	loading saved versions
	for node in save_nodes:
		node.queue_free()
	_deserialize_nodes()
	_close_file()
