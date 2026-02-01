extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -330.0

@onready var animated_sprite = $AnimatedSprite2D

# Variável para controlar se está pulando
var is_jumping = false

func _ready():
	animated_sprite.play("idle")

func _physics_process(delta: float) -> void:
	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta
		is_jumping = true
	else:
		is_jumping = false

	# Pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
		animated_sprite.play("jump")

	# Movimento
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		
		# Direção
		animated_sprite.flip_h = direction < 0
		
		# Animação apenas se não estiver pulando
		if not is_jumping:
			animated_sprite.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		# Idle apenas se não estiver pulando
		if not is_jumping:
			animated_sprite.play("idle")

	move_and_slide()
