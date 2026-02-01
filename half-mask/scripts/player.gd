extends CharacterBody2D

enum PlayerState { idle, walk, jump, dead }

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 200.0 
const JUMP_VELOCITY = -400.0

var status: PlayerState

func _ready() -> void:
	go_to_idle_state()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	match status:
		PlayerState.idle: idle_state()
		PlayerState.walk: walk_state()
		PlayerState.jump: jump_state()
		PlayerState.dead: dead_state()
			
	move_and_slide()

func go_to_idle_state():
	status = PlayerState.idle
	# Checagem correta para AnimatedSprite2D:
	if anim.sprite_frames.has_animation("idle"): 
		anim.play("idle")
	
func go_to_walk_state():
	status = PlayerState.walk
	if anim.sprite_frames.has_animation("walk"): 
		anim.play("walk")
	
func go_to_jump_state():
	status = PlayerState.jump
	if anim.sprite_frames.has_animation("jump"): 
		anim.play("jump")
	velocity.y = JUMP_VELOCITY
	
func idle_state():
	move()
	if velocity.x != 0:
		go_to_walk_state()
	elif Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_UP):
		go_to_jump_state()
	
func walk_state():
	move()
	if velocity.x == 0:
		go_to_idle_state()
	elif Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_UP):
		go_to_jump_state()
		
func jump_state():
	move()
	if is_on_floor():
		if velocity.x == 0: go_to_idle_state()
		else: go_to_walk_state()

func dead_state():
	pass

func move():
	var dir = 0
	if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D): dir += 1
	if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A): dir -= 1
	
	velocity.x = dir * SPEED
	
	if dir < 0: anim.flip_h = true
	elif dir > 0: anim.flip_h = false
