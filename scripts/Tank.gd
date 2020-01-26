extends KinematicBody2D

# variável para o controle de velocidade.
var speed = 100
# variável para fazer um pré carregamento do objeto bullet.
var pre_bullet = preload("res://scenes/bullet.tscn")

""" Um dos benefícios fundamentais da exportação de variáveis é tê-las visíveis e editáveis 
​​no editor. Dessa forma, artistas e designers de jogos podem modificar valores que mais tarde 
influenciam a execução do programa. """

# Expotando variáveis de membros, para telas visíveis no editor de variáveis do script.
export(int, "bigRed", "blue", "dark", "darkLarge", "green", "huge", "red", "sand") var bodie = 0
export(int, "red1", "blue", "dark1", "dark2", "green", "sand1", "red2", "sand2") var barrel = 0

# Criando lista para novas texturas do tanque
var bodies = [
	"res://sprites/tankBody_bigRed.png",
	"res://sprites/tankBody_blue.png",
	"res://sprites/tankBody_dark.png",
	"res://sprites/tankBody_darkLarge.png",
	"res://sprites/tankBody_green.png",
	"res://sprites/tankBody_huge.png",
	"res://sprites/tankBody_red.png",
	"res://sprites/tankBody_sand.png"
]

# Criando lista para novas texturas dos canhos dos tanques
var barrels = [
	"res://sprites/tankRed_barrel1_outline.png",
	"res://sprites/tankBlue_barrel1.png",
	"res://sprites/tankDark_barrel1_outline.png",
	"res://sprites/tankDark_barrel1.png",
	"res://sprites/tankGreen_barrel1_outline.png",
	"res://sprites/tankSand_barrel1.png",
	"res://sprites/tankRed_barrel2_outline.png",
	"res://sprites/tankSand_barrel1_outline.png"
]

func _ready():
	$Sprite.texture = load(bodies[bodie])
	$barrel/sprite.texture = load(barrels[barrel])
	

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
	
	# Input do botões do tiro
	if Input.is_action_just_pressed("ui_shoot"):
		
		# Limitando quantidade de tiros. 
		# Se a quantidade de nós do grupo cannon_bullets for menor que 6 atire.		
		if get_tree().get_nodes_in_group("cannon_bullets").size() < 6:
			
			# Crirando uma instância(cópia) do objeto bullet.
			var bullet = pre_bullet.instance()
			
			# Pegando a posição global do objeto "muzzel" e atribuiando na posição global 
			# da variável bullet. 
			bullet.global_position = $barrel/muzzle.global_position
			
			# Atribuindo o valor do seno e coseno na variável direção ou seja o x e o y do 
			# mouse. Usando o normalized para não calcular a velocidade. 
			bullet.dir = Vector2( cos(rotation), sin(rotation) ).normalized()
			
			# Chamando a animação fire do disparo
			$barrel/animation.play("fire")
			
			# Colocando o objeto bullet na cena principail.
			get_parent().add_child(bullet)
	
	# Colando o tanque pra seguir a direção do mouse
	look_at(get_global_mouse_position())
	
	# Chamando função translate para movimentar o objeto apartir do ponto original, 
	# movimentando para direção x ou y a cada pixel.
	translate( Vector2(dir_x , dir_y) * delta * speed)
	pass
