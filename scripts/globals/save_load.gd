extends Node
# https://docs.godotengine.org/en/stable/classes/class_fileaccess.html


# Password for file encryption and decryption, you would likely want to change this in your application
var _password: String = "12345"  

# Objects, Paths, Open/Close Functions.
var _s_file = FileAccess # File object opened by the FileAccess library
var _globals_filepath: String = "user://globals.sav"


# Public Save/Load methods
func save_game(level_name: String):
	_save_globals()
	_save_level(level_name)


func load_game(level_name: String):
	pass
	_load_globals()
	_load_level(level_name)


func clear_save():
	DirAccess.remove_absolute(_globals_filepath)
	for level_name in Globals.levels:
		DirAccess.remove_absolute(_get_level_filepath(level_name))
	
	for key in Globals.default_global_values.keys():
		if key in Globals:
			Globals.set(key, Globals.default_global_values[key])


# Private file path and I/O methods
func _get_level_filepath(level_name: String):
	return "user://" + level_name + ".sav"


func _open_file(access : FileAccess.ModeFlags, filepath: String) -> int:
	# Try opening an encrypted file with write access
	_s_file = FileAccess.open_encrypted_with_pass(filepath, access, _password)
	# Handle errors if the file doesn't exist yet, this is necessary
	return FileAccess.get_open_error() if (_s_file == null) else OK
	
	
func _close_file() -> void:
	_s_file = null


# Private Save/Load methods 
func _save_globals():
	# Open and check file
	var status = _open_file(FileAccess.WRITE, _globals_filepath)
	if (status != OK): 
		print("Unable to open the file %s. Received error: %d" % [_globals_filepath, status])
		return
	# Serialize data to file
	var save_data: Dictionary = Globals.save_data()
	_s_file.store_var(save_data)
	# Close the file
	_close_file()


func _load_globals():
	# Open and check file
	var status = _open_file(FileAccess.READ, _globals_filepath)
	if (status != OK): 
		print("Unable to open the file %s. Received error: %d" % [_globals_filepath, status])
		return
	var loaded_data: Dictionary = _s_file.get_var()
	Globals.load_data(loaded_data)
	# Close the file
	_close_file()


func _save_level(level_name: String):
	# This function serializes any nodes in the group "persist"
	# For this game, we don't actually need to save each level individually. But, I have structured
	#	things this way to illustrate how you might save things in a game where you can reenter
	#	multiple levels and want to preserve the state of a previous playthrough (for example, 
	#	in a game like Super Mario 3).
	
	# Open and check file
	var status = _open_file(FileAccess.WRITE, _get_level_filepath(level_name))
	if (status != OK): 
		print("Unable to open the file %s. Received error: %d" % [_get_level_filepath(level_name), status])
		return

	# We are using the group "persist" to tell the save system which nodes should be saved and loaded.
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for node in save_nodes:
		# Every persisted node must have a "load_data()" function.
		# The resulting dictionary must include at least: 
			# "filepath" - (get_scene_file_path()) and 
			# "parent" - (get_parent().get_path())
		var save_data: Dictionary = node.save_data()
		_s_file.store_var(save_data)
	_close_file()


func _load_level(level_name: String):
	# Open and check file
	var status = _open_file(FileAccess.READ, _get_level_filepath(level_name))
	if (status != OK): 
		print("Unable to open the file %s. Received error: %d" % [_get_level_filepath(level_name), status])
		return
	
	# We are using the group "persist" to tell the save system which nodes should be saved and loaded.
	var save_nodes = get_tree().get_nodes_in_group("persist")  
	
	# For all persisted node types, we need to remove all instances from the game before 
	#	loading saved versions
	for node in save_nodes:
		node.queue_free()
	
	# Here we are deserializing all nodes by unpacking one node dict at a time with "get_var()"
	while _s_file.get_position() < _s_file.get_length():
		var loaded_data: Dictionary = _s_file.get_var()
		var new_object = load(loaded_data["filepath"]).instantiate()
		
		# Every persisted node must have a "load_data()" function.
		new_object.load_data(loaded_data)
		get_node(loaded_data["parent"]).add_child(new_object)
	_close_file()
