extends Node2D
@export_group("BEHAVIOR")
@export var imgs_size:int = 16
@export_enum("Simple", "Automatic Simple", "Automatic Complex") var mode = "Simple"
@export_enum("Desactivado", "Simple Lines", "Complex Lines") var lines_mode = "Desactivado"
@export var destroy_to_click:bool = false

@export_group("BODY TEXTURES")

@export_subgroup("SIMPLE")
@export var alone_:Texture2D
##############################
@export_subgroup("AUTOMATIC SIMPLE")
@export var alone__:Texture2D
@export var center_:Texture2D
@export var corner_:Texture2D
@export var edge_:Texture2D
##############################
@export_subgroup("AUTOMATIC COMPLEX")
@export var alone___:Texture2D
@export var center__:Texture2D
@export var corner_1:Texture2D
@export var corner_2:Texture2D
@export var corner_3:Texture2D
@export var corner_4:Texture2D

@export var edge_1:Texture2D
@export var edge_2:Texture2D
@export var edge_3:Texture2D
@export var edge_4:Texture2D
##############################

@export_group("LINES TEXTURES")
@export_subgroup("SIMPLE")
@export var corner__:Texture2D
@export var center___:Texture2D

@export_subgroup("COMPLEX")
@export var corner__1:Texture2D
@export var center____:Texture2D
@export var corner__2:Texture2D

@onready var new_img = Sprite2D.new()
@onready var new_area:StaticBody2D = StaticBody2D.new()
@onready var new_colision = CollisionShape2D.new()
@onready var colision_type = RectangleShape2D.new()

@onready var ray_up = RayCast2D.new()
@onready var ray_rigth = RayCast2D.new()
@onready var ray_down = RayCast2D.new()
@onready var ray_left = RayCast2D.new()

# Called eve ry frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	self.add_to_group("BLOCKS")
	new_img.texture = alone_
	new_img.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	colision_type.size = Vector2(imgs_size, imgs_size)
	new_colision.shape = colision_type
	
	add_child(new_img)
	add_child(new_area)
	new_area.add_child(new_colision)
	
	if mode != "Simple":
		ray_up.target_position = Vector2(0, -imgs_size)
		#ray_up.rotation = PI
		#ray_up.collide_with_areas = true
		ray_rigth.target_position = Vector2(imgs_size, 0)
		#ray_rigth.rotation = -PI/2
		#ray_rigth.collide_with_areas = true
		ray_down.target_position = Vector2(0, imgs_size)
		#ray_down.rotation = 2 * PI
		#ray_down.collide_with_areas = true
		ray_left.target_position = Vector2(-imgs_size, 0)
		#ray_left.rotation = PI/2
		#ray_left.collide_with_areas = true
		
		add_child(ray_up)
		add_child(ray_rigth)
		add_child(ray_down)
		add_child(ray_left)


func _process(delta):
	match  destroy_to_click :
		true :
			var mouse_pos = get_global_mouse_position()
			if Input.is_action_pressed("anticlick"):
				if (round(mouse_pos/16) * 16) == self.global_position :
					self.queue_free()
	
	match lines_mode :
		"Desactivado" :
			return
		"Complex Lines" :
			_complex_lines()
		"Simple Lines" :
			_simple_lines()
			

	match  mode :
		"Simple":
			return
		"Automatic Complex":
			_automatic_complex()
		"Automatic Simple":
			_automatic_simple()


func _automatic_complex():
	### TODOS CHOCANDO ###
	if ray_up.is_colliding() and ray_down.is_colliding() and ray_rigth.is_colliding() and ray_left.is_colliding():
		new_img.texture = center__
		new_img.rotation_degrees = 0
	### NIMGUNO CHOCANDO ###
	if !ray_up.is_colliding() and !ray_down.is_colliding() and !ray_rigth.is_colliding() and !ray_left.is_colliding():
		new_img.texture = alone___
		rotation_degrees = 0
	
	
	########## EZQUINAS ##########
	### ARRIBA Y DERECHA CHOCANDO ###
	if ray_up.is_colliding() and ray_rigth.is_colliding() and !ray_down.is_colliding() and !ray_left.is_colliding():
		new_img.texture = corner_4
		new_img.rotation_degrees = 0
	### ARRIBA E IZQUIERDA CHOCANDO ###
	if ray_up.is_colliding() and ray_left.is_colliding() and !ray_down.is_colliding() and !ray_rigth.is_colliding():
		new_img.texture = corner_3
		new_img.rotation_degrees = 0
	### ABAJO Y DERECHA CHOCANDO ###
	if ray_down.is_colliding() and ray_rigth.is_colliding() and !ray_up.is_colliding() and !ray_left.is_colliding():
		new_img.texture = corner_1
		new_img.rotation_degrees = 0
	### ABAJO E IZQUIERDA CHOCANDO ###
	if ray_down.is_colliding() and ray_left.is_colliding() and !ray_up.is_colliding() and !ray_rigth.is_colliding():
		new_img.texture = corner_2
		new_img.rotation_degrees = 0
	##########################
	
	
	########## BORDES ##########
	### ABAJO , DERECHA E IZQUIERDA CHOCANDO ###
	if !ray_up.is_colliding() and ray_down.is_colliding() and ray_rigth.is_colliding() and ray_left.is_colliding():
		new_img.texture = edge_1
		new_img.rotation_degrees = 0
	### ARRIBA , DERECHA E IZQUIERDA CHOCANDO ###
	if ray_up.is_colliding() and !ray_down.is_colliding() and ray_rigth.is_colliding() and ray_left.is_colliding():
		new_img.texture = edge_3
		new_img.rotation_degrees = 0
	### ARRIBA , ABAJO E IZQUIERDA CHOCANDO ###
	if ray_up.is_colliding() and ray_down.is_colliding() and !ray_rigth.is_colliding() and ray_left.is_colliding():
		new_img.texture = edge_2
		new_img.rotation_degrees = 0
	### ABAJO , DERECHA Y ARRIBA CHOCANDO ###
	if ray_up.is_colliding() and ray_down.is_colliding() and ray_rigth.is_colliding() and !ray_left.is_colliding():
		new_img.texture = edge_4
		new_img.rotation_degrees = 0
	
	"""
	### ARRIBA Y ABAJO O IZQUIERDA Y DERECHA CHOCANDO ###
	if (ray_up.is_colliding() and ray_down.is_colliding() and !ray_rigth.is_colliding() and !ray_left.is_colliding()) or (ray_rigth.is_colliding() and ray_left.is_colliding() and !ray_up.is_colliding() and !ray_down.is_colliding()):
		new_img.texture = center_
"""

func _automatic_simple():
	### TODOS CHOCANDO ###
	if ray_up.is_colliding() and ray_down.is_colliding() and ray_rigth.is_colliding() and ray_left.is_colliding():
		new_img.texture = center_
		new_img.rotation_degrees = 0
	### NINGUNO CHOCANDO ###
	if !ray_up.is_colliding() and !ray_down.is_colliding() and !ray_rigth.is_colliding() and !ray_left.is_colliding():
		new_img.texture = alone__
		new_img.rotation_degrees = 0
	
	########## EZQUINAS ##########
	### ARRIBA Y DERECHA CHOCANDO ###
	if ray_up.is_colliding() and ray_rigth.is_colliding()  and !ray_down.is_colliding() and !ray_left.is_colliding():
		new_img.texture = corner_
		new_img.rotation_degrees = 180
	### ARRIBA E IZQUIERDA CHOCANDO ###
	if ray_up.is_colliding() and ray_left.is_colliding()  and !ray_down.is_colliding() and !ray_rigth.is_colliding():
		new_img.texture = corner_
		new_img.rotation_degrees = 90
	### ABAJO Y DERECHA CHOCANDO ###
	if ray_down.is_colliding() and ray_rigth.is_colliding() and !ray_up.is_colliding() and !ray_left.is_colliding():
		new_img.texture = corner_
		new_img.rotation_degrees = 270
	if ray_down.is_colliding() and ray_left.is_colliding() and !ray_up.is_colliding() and !ray_rigth.is_colliding():
		new_img.texture = corner_
		new_img.rotation_degrees = 0
	##########################
	
	
	########## BORDES ##########
	### ABAJO , DERECHA E IZQUIERDA CHOCANDO ###
	if !ray_up.is_colliding() and ray_down.is_colliding() and ray_rigth.is_colliding() and ray_left.is_colliding():
		new_img.texture = edge_
		new_img.rotation_degrees = 0
	### ARRIBA , DERECHA E IZQUIERDA CHOCANDO ###
	if ray_up.is_colliding() and !ray_down.is_colliding() and ray_rigth.is_colliding() and ray_left.is_colliding():
		new_img.texture = edge_
		new_img.rotation_degrees = 180
	### ARRIBA , ABAJO E IZQUIERDA CHOCANDO ###
	if ray_up.is_colliding() and ray_down.is_colliding() and !ray_rigth.is_colliding() and ray_left.is_colliding():
		new_img.texture = edge_
		new_img.rotation_degrees = 90
	### ABAJO , DERECHA Y ARRIBA CHOCANDO ###
	if ray_up.is_colliding() and ray_down.is_colliding() and ray_rigth.is_colliding() and !ray_left.is_colliding():
		new_img.texture = edge_
		new_img.rotation_degrees = 270
	"""
	### ARRIBA Y ABAJO O IZQUIERDA Y DERECHA CHOCANDO ###
	if (ray_up.is_colliding() and ray_down.is_colliding() and !ray_rigth.is_colliding() and !ray_left.is_colliding()) or (ray_rigth.is_colliding() and ray_left.is_colliding() and !ray_up.is_colliding() and !ray_down.is_colliding()):
		new_img.texture = center_
		"""

func _simple_lines():
	### ARRIBA CHOCANDO ###
	if ray_up.is_colliding() and !ray_down.is_colliding() and !ray_rigth.is_colliding() and !ray_left.is_colliding():
		new_img.texture = corner__
		new_img.rotation_degrees = 180
	### ABAJO CHOCANDO ###
	if  !ray_up.is_colliding() and ray_down.is_colliding() and !ray_rigth.is_colliding() and !ray_left.is_colliding():
		new_img.texture = corner__
		new_img.rotation_degrees = 0
	### DERECHA CHOCANDO ###
	if !ray_up.is_colliding() and !ray_down.is_colliding() and ray_rigth.is_colliding() and !ray_left.is_colliding():
		new_img.texture = corner__
		new_img.rotation_degrees = 270
	### IZQUIERDA CHOCANDO
	if  !ray_up.is_colliding() and !ray_down.is_colliding() and !ray_rigth.is_colliding() and ray_left.is_colliding():
		new_img.texture = corner__
		new_img.rotation_degrees = 90
	
	### ARRIBA Y ABAJO ###
	if (ray_up.is_colliding() and ray_down.is_colliding() and !ray_rigth.is_colliding() and !ray_left.is_colliding()) : # or 
		new_img.texture = center___
		new_img.rotation_degrees = 0
	###IZQUIERDA Y DERECHA CHOCANDO ###
	if (ray_rigth.is_colliding() and ray_left.is_colliding() and !ray_up.is_colliding() and !ray_down.is_colliding()):
		new_img.texture = center___
		new_img.rotation_degrees = 90

func  _complex_lines():
	### ARRIBA CHOCANDO ###
	if ray_up.is_colliding() and !ray_down.is_colliding() and !ray_rigth.is_colliding() and !ray_left.is_colliding():
		new_img.texture = corner__2
		new_img.rotation_degrees = 0
	### ABAJO CHOCANDO ###
	if  !ray_up.is_colliding() and ray_down.is_colliding() and !ray_rigth.is_colliding() and !ray_left.is_colliding():
		new_img.texture = corner__1
		new_img.rotation_degrees = 0
	### DERECHA CHOCANDO ###
	if !ray_up.is_colliding() and !ray_down.is_colliding() and ray_rigth.is_colliding() and !ray_left.is_colliding():
		new_img.texture = corner__1
		new_img.rotation_degrees = 270
	### IZQUIERDA CHOCANDO
	if  !ray_up.is_colliding() and !ray_down.is_colliding() and !ray_rigth.is_colliding() and ray_left.is_colliding():
		new_img.texture = corner__2
		new_img.rotation_degrees = 270
	
	### ARRIBA Y ABAJO ###
	if (ray_up.is_colliding() and ray_down.is_colliding() and !ray_rigth.is_colliding() and !ray_left.is_colliding()) : # or 
		new_img.texture = center____
		new_img.rotation_degrees = 0
	###IZQUIERDA Y DERECHA CHOCANDO ###
	if (ray_rigth.is_colliding() and ray_left.is_colliding() and !ray_up.is_colliding() and !ray_down.is_colliding()):
		new_img.texture = center____
		new_img.rotation_degrees = 90
