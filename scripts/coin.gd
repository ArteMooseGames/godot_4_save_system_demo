extends Area2D

@export_group("My Properties")
@export_enum("star", "diamond") var currency_type: String = "diamond"

@onready var star_texture: String = "res://assets/coin_star.png"
@onready var diamond_texture: String = "res://assets/coin_diamond.png"


@onready var type_to_texture: Dictionary = {
	"star": star_texture,
	"diamond": diamond_texture,
}


func _ready():
	$Sprite2D.texture = load(type_to_texture[currency_type])


func _on_body_entered(body):
	if body is Player:
		_pickup()
		queue_free()


func _increment_currency_count():
	if !Globals.coin_counter.has(currency_type):
		Globals.coin_counter[currency_type] = 0
	Globals.coin_counter[currency_type] += 1


func _pickup():
	_increment_currency_count()
