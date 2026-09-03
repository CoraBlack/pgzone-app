extends Node

class_name Config

@export var cfg_res: CfgRes
const server_api_base: String = "https://101.33.205.242"
const cfg_path: String = "user://cfg.res"

func _ready() -> void:
	if FileAccess.file_exists(cfg_path):
		cfg_res = ResourceLoader.load(cfg_path)
	else:
		cfg_res = CfgRes.new()
	
func _exit_tree() -> void:
	ResourceSaver.save(cfg_res, cfg_path)

func set_user_token(token: String) -> void:
	cfg_res.user_token = token
	
func get_user_token() -> String:
	return cfg_res.user_token
	
func get_api_base() -> String:
	return server_api_base
