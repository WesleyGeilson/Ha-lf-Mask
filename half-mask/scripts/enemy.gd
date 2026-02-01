extends CharacterBody2D

enum EnimeState {
	walk,
	attack,
	dead,
}
const FIREBOLL = preload("uid://bhen4n4gjheop")

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $hitbox
@onready var wall_detector: RayCast2D = $WallDetector
@onready var ground_detector: RayCast2D = $GroundDetector
@onready var player_detector: RayCast2D = $PlayerDetector
@onready var fire_start_position: Node2D = $FireStartPosition

const SPEED = 30.0
const  JUMP_VELOCITY = -400.0

var status: EnimeState

var direction = -1
var can_throw = true

func  _ready() -> void:
	go_to_walk_state()


func _physics_process(delta):
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match status:
		EnimeState.walk:
			walk_state(delta)
			
		EnimeState.attack:
			attack_state(delta)
		
		EnimeState.dead:
			dead_state(delta)
		
	move_and_slide()
	
func go_to_walk_state():
	status = EnimeState.walk
	anim.play("walk")
	
func go_to_attack_state():
	status=EnimeState.attack
	anim.play("attack")
	velocity=Vector2.ZERO
	can_throw = true
	
	
func  go_to_dead_state():
	status = EnimeState.dead
	anim.play("dead")
	hitbox.process_mode=Node.PROCESS_MODE_DISABLED
	velocity = Vector2.ZERO
	
func walk_state(_delta):
	velocity.x = SPEED * direction
	
	if wall_detector.is_colliding():
		scale.x *= -1
		direction *= -1
		
	if not ground_detector.is_colliding():
		scale.x *= -1
		direction *= -1
	
	if player_detector.is_colliding():
		go_to_attack_state()
		return
	
func attack_state(_delta):
	if anim.frame == 3 && can_throw:
		throw_fireboll()
		can_throw = false
		
func dead_state(_delta):
	pass

func take_demage():
	go_to_dead_state()

func throw_fireboll():
	var new_fire = FIREBOLL.instantiate()
	add_sibling(new_fire)
	new_fire.position = fire_start_position.global_position
	new_fire.set_direction(self.direction)

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "attack":
		go_to_walk_state()
		return
