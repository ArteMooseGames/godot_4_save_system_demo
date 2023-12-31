extends Area2D

@export_group("My Properties")
@export_enum("star", "diamond") var coin_type: String = "diamond"

@onready var star_texture: String = "res://assets/coin_star.png"
@onready var diamond_texture: String = "res://assets/coin_diamond.png"
@onready var type_to_texture: Dictionary = {
	"star": star_texture,
	"diamond": diamond_texture,
}


func _ready():
	$Sprite2D.texture = load(type_to_texture[coin_type])


func _on_body_entered(body):
	if body is Player:
		_pickup()
		queue_free()


func _increment_coin_count():
	if !Globals.coin_counter.has(coin_type):
		Globals.coin_counter[coin_type] = 0
	Globals.coin_counter[coin_type] += 1


func _pickup():
	_increment_coin_count()


func save_data() -> Dictionary:
	var save_dict: Dictionary = {
		"filepath": get_scene_file_path(),
		"parent": get_parent().get_path(),
		"name": name,
		"pos_x": global_position.x,
		"pos_y": global_position.y,
		"coin_type": coin_type,
	}
	return save_dict


func load_data(data: Dictionary) -> void:
	name = data["name"]
	position.x = data["pos_x"]
	position.y = data["pos_y"]
	coin_type = data["coin_type"]
