extends CharacterBody2D
class_name PlayerCharacter

@export var speed:int = 325

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('D'):
		$AnimatedSprite2D.flip_h = false
		velocity.x += 1
	if Input.is_action_pressed('A'):
		$AnimatedSprite2D.flip_h = true
		velocity.x -= 1
	if Input.is_action_pressed('S'):
		velocity.y += 1
	if Input.is_action_pressed('W'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(_delta):
	get_input()
	if velocity == Vector2.ZERO:
		#$AnimatedSprite2D.play("idle")
		pass
	else:
		move_and_slide()
		#$AnimatedSprite2D.play("move")

func _input(event):
	pass
