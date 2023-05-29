extends CharacterBody2D

@export var move_speed: float = 50
var direction: Vector2
@onready var screen_size = get_viewport_rect().size

@onready var animations = $AnimationPlayer

@export var bullet_scene : PackedScene
@export var default_fire_rate = 0.25
var can_fire = true
var fire_direction: Vector2

var is_active = false

func _ready():
	start()
	
func start():
	position = Vector2(screen_size.x / 2, screen_size.y / 2)
	$GunCooldown.wait_time = default_fire_rate
	$GunCooldown.timeout.connect(_on_gun_cooldown_timeout)
	

func _process(delta):
	if not is_active:
		return
	
	fire_direction = Input.get_vector("fire_left", "fire_right", "fire_up", "fire_down").normalized()
	if fire_direction != Vector2.ZERO:
		fire()

signal frog_died_signal

func _physics_process(delta):
	if not is_active:
		return
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	velocity = direction * move_speed
	move_and_slide()
	for index in get_slide_collision_count():
		var col := get_slide_collision(index)
		var body := col.get_collider()
		if body.is_in_group("enemies"):
			#frog_died_signal.emit()
			#queue_free()
			pass
			
			
	updateanimation()

func updateanimation() :
	var direction
	if velocity.length() ==0:
		animations.stop()
		direction = "Still"
	else:
		direction = "Down"
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"
	
	animations.play("walk" + direction)

func fire():
	if not can_fire:
		return
	can_fire = false
	$GunCooldown.start()
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.start(position + fire_direction * 2, fire_direction)
	
func _on_gun_cooldown_timeout():
	can_fire = true
