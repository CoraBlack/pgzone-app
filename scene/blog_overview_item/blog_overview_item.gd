extends Control

class_name BlogItem

@export var title: String
@export var author: String
@export var title_label: Label
@export var author_label: Label

func _ready() -> void:
	title_label.text = title
	author_label.text = author

func set_title(new_title: String) -> void:
	title = new_title

func set_author(new_author: String) -> void:
	author = new_author
