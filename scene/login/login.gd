extends Control

enum PanelState {
	SignIn,
	SignUp
}

var state: PanelState = PanelState.SignIn

@export var input_account: LineEdit
@export var input_passwd: LineEdit
@export var input_passwd2: LineEdit
@export var pwd_gap: Control

@export var top_label: Label
@export var tips: Label

@export var func_btn: Button
@export var switch_btn: Button

@export var http_requester: HTTPRequest
@export var animation_player: AnimationPlayer

func _ready() -> void:
	var cert = load("res://assert/cert.crt")
	http_requester.set_tls_options(TLSOptions.client_unsafe(cert))
	
	animation_player.play("entry")
	await animation_player.animation_finished
	
func _exit_tree() -> void:
	if state == PanelState.SignUp:
		animation_player.play("panel_switch")
		await animation_player.animation_finished
	
	animation_player.play_backwards("entry")
	await animation_player.animation_finished
	
func change_state() -> void:
	#animation_player.play_backwards("entry")
	#await animation_player.animation_finished
	
	animation_player.play("panel_switch") if state == PanelState.SignIn else animation_player.play_backwards("panel_switch")
	await animation_player.animation_finished
	
	match state:
		PanelState.SignIn:
			state = PanelState.SignUp
			top_label.text = "欢迎加入Pg zone"
			func_btn.text = "注册"
			switch_btn.text = "返回登录"
			
		PanelState.SignUp:
			state = PanelState.SignIn
			top_label.text = "欢迎回到Pg zone"
			func_btn.text = "登录"
			switch_btn.text = "前往注册"
	
	pwd_gap.show() if state == PanelState.SignIn else pwd_gap.hide()
	input_passwd2.hide() if state == PanelState.SignIn else input_passwd2.show()
	
	input_account.text = ""
	input_passwd.text = ""
	input_passwd2.text = ""
	
	#animation_player.play("entry")
	#await animation_player.animation_finished
	
func _on_big_btn_button_down() -> void:
	if input_account.text.is_empty() or input_passwd.text.is_empty():
		tips.text = "账户名和密码不能为空"
		return
	
	match state:
		PanelState.SignIn:
			var login_body := {}
			login_body["account_name"] = input_account.text
			login_body["password"] = input_passwd.text
			
			var body_string := JSON.stringify(login_body)
			var cfg = get_node("/root/cfg") as Config
			var full_addr: String = cfg.get_api_base() + "/user/login"
			http_requester.request(full_addr, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body_string)
		
		PanelState.SignUp:
			var signup_body := {}
			signup_body["account_name"] = input_account.text
			signup_body["password"] = input_passwd.text
			signup_body["confirm_password"] = input_passwd2.text
			var body_string := JSON.stringify(signup_body)
			var cfg = get_node("/root/cfg") as Config
			var full_addr: String = cfg.get_api_base() + "/user"
			http_requester.request(full_addr, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body_string) 

# 转换注册/登录模式
func _on_small_btn_button_down() -> void:
	change_state()

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	match state:
		PanelState.SignIn:
			if result != Error.OK || response_code != 200:
				tips.text = "登录失败"
				return
				
			var cfg = get_node("/root/cfg") as Config
			var raw_token = body.get_string_from_utf8()
			var user_token = JSON.parse_string(raw_token)
			cfg.set_user_token(user_token)
			get_tree().change_scene_to_file("res://scene/main/main.tscn")
			
		PanelState.SignUp:
			if result != Error.OK || response_code != 200:
				tips.text = "注册失败"
				return;
			tips.text = "用户 %s 注册成功" % input_account.text
			change_state()
