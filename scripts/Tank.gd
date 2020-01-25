extends KinematicBody2D

#variável para o controle de velocidade.
var speed = 100
#variável para fazer um pré carregamento do objeto bullet.
var pre_bullet = preload("res://scenes/bullet.tscn")

func _ready():
	pass

# Chamado todos os quadros. 'delta' é o tempo decorrido desde o quadro anterior.
func _process(delta):
	
	var dir_x = 0
	var dir_y = 0	
	
	#Entradas dos comandos.
	if Input.is_action_pressed("ui_right"):
		dir_x += 1
		
	if Input.is_action_pressed("ui_left"):
		dir_x -= 1
	
	if Input.is_action_pressed("ui_up"):
		dir_y -= 1
		
	if Input.is_action_pressed("ui_down"):
		dir_y += 1
	
	if Input.is_action_just_pressed("ui_shoot"):
		#Limitando quantidade de tiros. Se a quantidade de nós do grupo cannon_bullets for menor que 3 atire.
		if get_tree().get_nodes_in_group("cannon_bullets").size() < 3:
			#Crirando uma instância(cópia) do objeto bullet.
			var bullet = pre_bullet.instance()
			#Pegando a posição global do objeto "muzzel" e atribuiando na posição global da variável bullet. 
			bullet.global_position = $barrel/muzzle.global_position
			#Colocando o objeto bullet na cena principail.
			get_parent().add_child(bullet)	
		
		
	# Chamando função translate para movimentar o objeto apartir do ponto original, movimentando para direção x ou y a cada pixel.
	translate( Vector2(dir_x , dir_y) * delta * speed)
	pass
