extends TextureButton

var origin_size: Vector2

func _ready() -> void:
	pass

func _on_mouse_entered() -> void:
	var target_scale := Vector2(1.2, 1.2)
	var target_rotation_degree := 360.0
	var scale_tween = get_tree().create_tween().tween_property(self, "scale", target_scale, 0.6)
	var rotation_tween = get_tree().create_tween().tween_property(self, "rotation_degrees", target_rotation_degree, 0.6)
	
	await scale_tween.finished
	await rotation_tween.finished

func _on_mouse_exited() -> void:
	var target_scale := Vector2(1, 1)
	var target_rotation_degree := 0
	var scale_tween = get_tree().create_tween().tween_property(self, "scale", target_scale, 0.6)
	var rotation_tween = get_tree().create_tween().tween_property(self, "rotation_degrees", target_rotation_degree, 0.6)
	
	await scale_tween.finished
	await rotation_tween.finished
