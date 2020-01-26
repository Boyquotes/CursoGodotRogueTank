extends Area2D

# variável para controle de velocidade da bala.
var vel = 250 

# variável do angulo em 90 graus. Usando seget para chamar a função setar direção. 
var dir = Vector2(0,-1) setget setar_direcao

func _ready():
	pass 

# Chamado todos os quadros. 'delta' é o tempo decorrido desde o quadro anterior.
func _process(delta):
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