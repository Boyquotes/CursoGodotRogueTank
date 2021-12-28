extends Area2D

 
func _ready():
	pass 


func _on_oilSpill_large_body_entered(body):
	# quando o tanque tocar no oleo adiciona o objeto tank ao grupo oleo.
	add_to_group(str(body) + "-oil")


func _on_oilSpill_large_body_exited(body):
	remove_from_group(str(body) + "-oil")
