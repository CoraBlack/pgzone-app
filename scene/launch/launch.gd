extends Control

@export var animation_player: AnimationPlayer

func _ready() -> void:
	animation_player.play("animat")
	await animation_player.animation_finished
	var cfg = get_node("/root/cfg") as Config
	if cfg.get_user_token().is_empty():
		get_tree().change_scene_to_file("res://scene/login/login.tscn")
	else:
		get_tree().change_scene_to_file("res://scene/main/main.tscn")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass
