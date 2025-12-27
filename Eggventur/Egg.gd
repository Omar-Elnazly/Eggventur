extends Area3D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":  # your chicken node
		queue_free()             # remove egg
		body.collect_egg()       # call function on chicken
