extends Node2D

var free_space:bool = true

@onready var img:Sprite2D = $Sprite
@export var BLOCK:PackedScene
var size_snap:int = 16

func _physics_process(_delta) :
	#print(get_tree().get_nodes_in_group("BLOCKS").size())
	#print(get_tree().get_nodes_in_group("Blocks").size())
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	var mouse_pos = get_global_mouse_position()
	img.global_position = round(mouse_pos/size_snap) * size_snap
	
	if Input.is_action_pressed("click") :
		if free_space :
			var new_block = BLOCK.instantiate()
			get_node("Blocks").add_child(new_block)
			new_block.global_position = (round(mouse_pos/size_snap) * size_snap)



func _block_entered(body):
	if body.get_parent().is_in_group("BLOCKS") :
		free_space = false
func _block_exited(body):
	if body.get_parent().is_in_group("BLOCKS") :
		free_space = true
