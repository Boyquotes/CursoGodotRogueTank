# visualizando alterações em modo de edição.
tool

# incorporando o objeto KinematicBody2D.
extends KinematicBody2D

""" variável para armazena o id do objeto tank e criar um grupo.
onready só inicia a variável quando todo o script estiver pronto."""
onready var bullet_tank_group = "bullet-" + str(self)

""" Criando uma constante para criar a rotação de 90 graus por segundo usando 
PI(180 graus) Pi dividido por 2, 90 graus - Pi multiplicado por 2 360 graus
OBS: 1 PI é meia esfera."""
const ROT_VEL = PI / 2

# variável para o controle de velocidade.
const MAX_SPEED = 100

# pré carregamento do objeto bullet.
var pre_bullet = preload("res://scenes/bullet.tscn")

# Variável para celeração
var aceleracao = 0

""" Um dos benefícios fundamentais da exportação de variáveis é tê-las 
visíveis e editáveis ​​no editor. Dessa forma, artistas e designers de jogos 
podem modificar valores que mais tarde influenciam a execução do programa. """

# Expotando variáveis de membros, para telas visíveis no editor de variáveis do script.
export(int, "bigRed", "blue", "dark", "darkLarge", "green", "huge", "red", "sand") var bodie = 0 setget set_bodie
export(int, "red1", "blue", "dark1", "dark2", "green", "sand1", "red2", "sand2") var barrel = 0 setget set_barrel

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
	pass

# Função para redesenhar o objetos.
func _draw():
	$Sprite.texture = load(bodies[bodie])
	$barrel/sprite.texture = load(barrels[barrel])
	
# Chamado todos os quadros. 'delta' é o tempo decorrido desde o quadro anterior.
func _physics_process(delta):
	# Se estiver no modo editor saia da função process.
	if (Engine.editor_hint):
		return
	
#	var dir_x = 0 
#	var dir_y = 0 
#
#	#Entradas dos comandos.
#	if (Input.is_action_pressed("ui_right")):
#		dir_x += 1
#
#	if (Input.is_action_pressed("ui_left")):
#		dir_x -= 1
#
#	if (Input.is_action_pressed("ui_up")):
#		dir_y -= 1
#
#	if (Input.is_action_pressed("ui_down")):
#		dir_y += 1
#
	# Input do botões do tiro
	if (Input.is_action_just_pressed("ui_shoot")):

		# Limitando quantidade de tiros. 
		# Se a quantidade de nós do grupo cannon_bullets for menor que 6 atire.		
		if (get_tree().get_nodes_in_group(bullet_tank_group).size() < 6):

			# Crirando uma instância(cópia) do objeto bullet.
			var bullet = pre_bullet.instance()

			# Pegando a posição global do objeto "muzzel" e atribuiando na posição global 
			# da variável bullet. 
			bullet.global_position = $barrel/muzzle.global_position

			# Atribuindo o valor do seno e coseno na variável direção ou seja o x e o y do 
			# mouse. Usando o normalized para não calcular a velocidade. 
			bullet.dir = Vector2( cos($barrel.global_rotation), sin($barrel.global_rotation) ).normalized()

			# Adicionando um grupo em tempo de execução para limitar a quantidade de tiros de cada tank. 
			bullet.add_to_group(bullet_tank_group)

			# Chamando a animação fire do disparo
			$barrel/anim.play("fire")

			# Colocando o objeto bullet na cena principail.
			get_parent().add_child(bullet)
#
#	# Colando o tanque pra seguir a direção do mouse
#	look_at(get_global_mouse_position())
#
#	# Chamando o método move_and_slide para movimentar o objeto apartir do ponto original 
#	# e colidir com paredes, movimentando para direção x ou y a cada pixel.
#	move_and_slide(Vector2(dir_x , dir_y) * speed)
	
	var rotacao = 0 
	var direcao = 0 
	
	# Controle da rotação
	if (Input.is_action_pressed("ui_right")):
		rotacao += 1
	if (Input.is_action_pressed("ui_left")):
		rotacao -= 1
	# Controle da direção
	if (Input.is_action_pressed("ui_up")):
		direcao += 1
	if (Input.is_action_pressed("ui_down")):
		direcao -= 1
	# Rotacionando o tank
	rotate(ROT_VEL * rotacao * delta) 
	
	# Se diração for diferente de 0
	#if (direcao != 0):
		# Metódo lerp interpola(interompe) linearmente entre dois valores por um valor como normalizador.
		# Vai de 0 a 100 com uma variação(peso) de 1 decimo.
	aceleracao = lerp(aceleracao , MAX_SPEED * direcao , .03)
	#else:
		#aceleracao = lerp(aceleracao, 0, .05)
	
	print(aceleracao)
	
	# Chamando o método move_and_slide para movimentar o objeto apartir do ponto original 
	#  e colidir com paredes, movimentando para direção x ou y a cada pixel.
	move_and_slide(Vector2( cos(rotation), sin(rotation) ) * aceleracao)
	
	# Apontando o barrel para a possição atual do mouse.
	$barrel.look_at(get_global_mouse_position())
	
# Função para alterar o corpo de tank.
func set_bodie(val):
	bodie = val
	if (Engine.editor_hint):# Se a godot estiver no modo editor.
		update()# Execute a função Draw.
		
# Função para alterar o corpo de tank.
func set_barrel(val):
	barrel = val
	if (Engine.editor_hint): # Se a godot estiver no modo editor.
		update() # Execute a função Draw.
	
