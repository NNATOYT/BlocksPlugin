@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("Blocks", "Node2D", preload("res://addons/blocks/BaseBlocks.gd"), preload("res://addons/blocks/icon.png"))



func _exit_tree():
	remove_custom_type("Blocks")
