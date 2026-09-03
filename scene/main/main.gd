extends Control

var server_url: String = "https://101.33.205.242:443"
@export var animation_player: AnimationPlayer
@export var blog_list: VBoxContainer
@export var http_requester: HTTPRequest

func _ready() -> void:
	var cert = load("res://assert/cert.crt")
	http_requester.set_tls_options(TLSOptions.client_unsafe(cert))
	var result = http_requester.request(server_url + "/blogs")
	animation_player.play_backwards("leave_scene")
	await animation_player.animation_finished

func _exit_tree() -> void:
	animation_player.play_backwards("entry")
	await animation_player.animation_finished

func _on_blog_list_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != Error.OK || response_code != 200:
		return
	
	var body_str := body.get_string_from_utf8()
	var json = JSON.parse_string(body_str)
	var blogs = json["blogs"];
	for blog in blogs:
		var blog_info_btn := (ResourceLoader.load("res://scene/blog_overview_item/blog_overview_item.tscn") as PackedScene).instantiate() as BlogItem
		blog_info_btn.set_title(blog["title"])
		blog_info_btn.set_author(blog["author"])
		blog_list.add_child(blog_info_btn)


func changed_scene(scene_path: String) -> void:
	animation_player.play("leave_scene")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(scene_path)


func _on_home_btn_button_down() -> void:
	changed_scene("res://scene/blog_editor/blog_editor.tscn")
