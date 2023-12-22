extends Area2D

signal end_door_entered


func _on_body_entered(body):
	end_door_entered.emit()
