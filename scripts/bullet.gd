extends Area2D

const MAX_DIST = 250
var vel = 400 

# variável do angulo em 90 graus. Usando seget para chamar a função setar direção. 
var dir = Vector2(0,-1) setget setar_direcao

# variável para pegar a posição inicial da bala
onready var init_position = global_position

# Criando variável para saber se um objeto está vivo.
var live = true

func _ready():
	pass 

# Chamado todos os quadros. 'delta' é o tempo decorrido desde o quadro anterior.
func _process(delta):
	# Se a variável live estiver true.
	if (live):
		# se a distância da posiçao da bala para o tank for maior ou iqual a distância máximo
		if (global_position.distance_to(init_position) >= MAX_DIST):
			autodestroy() #Função para destruir a bala.
		translate(dir * vel * delta)
	
# Função criada pra saber quando qualquer instância do objeto bullet saiu da tela
func _on_notifier_screen_exited():
	# Apagar o objeto (liberando espaço na memória). 
	queue_free()
	
# Função para setar o angulo atual do mouse na bala.
func setar_direcao(val):
	dir = val
	# A rotação é o angulo da direção
	rotation = dir.angle()

	# Método para saber se a bala está dentro de outro 
	# corpo físico(só executa quando bate na parede ou enimigos). 
func _on_bullet_body_entered(body):
	# saber o a colisão aconteceu com o leyer 4.
	if (body.collision_layer == 4):
		autodestroy() #Função para destruir a bala.
		
func autodestroy():
	$smoke.emitting = false # Parando a particula da fumaça.
	live = false 			# Setando false a variável live.
	$sprite.visible = false # Deixando o sprite da bala invisivel .
	$ani_destruction.play("explode") # Iniciando a animação da explosão.
	# Desabilitando as colisões
	# chamando a função call_deferred para que o monitoramento seja 
	# parado no final da função principal.
	call_deferred("set_monitoring", false)
	call_deferred("set_monitoring", false)
	# Dando preferência de execução até finalizar a animação de explosão.
	yield($ani_destruction, "animation_finished")
	# Liberando memoria(apaga o objeto).
	queue_free() 
