extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var chase = false
var speed = 70
@onready var anim = $AnimatedSprite2D
var alive = true
var dhealth = 100

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	var player = $"../../Player/Player"
	var direction = (player.position - self.position).normalized()
	if alive:
		if chase == true:
			velocity.x = direction.x * speed
			anim.play("walk")
		else:
			velocity.x = 0
			anim.play("idle")
		if direction.x < 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
			
		if dhealth <= 0:
			death()
		
			
		move_and_slide()


func _on_detect_body_entered(body):
	if body.name == "Player":
		chase = true


func _on_detect_body_exited(body):
	if body.name == "Player":
		chase = false


func _on_death_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		dhealth -= 20
	anim.play("hurt")
	await anim.animation_finished


func death():
	alive = false
	queue_free()


func _on_death_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.health -= 20
	anim.play("fight")
	await anim.animation_finished
