extends CharacterBody2D

var speed := 48 # The speed of the enemy.
var amplitude := 3 # The amplitude of the sinus curve.
var frequency := 4 # The frequency of the sinus curve.
var time := 0.0 # The time, needed to calculate the sinus curve.
var direction = Vector2.ZERO
var player

func setup(player: Node2D):
    self.player = player

func _ready():
    direction = Vector2.RIGHT # The direction in which the enemy is moving.

func _physics_process(delta):
    time += delta
    var vertical_movement = sin(time * frequency) * amplitude
    var movement = direction * speed * delta
    movement.y += vertical_movement
    var col = move_and_collide(movement)
    if col:
        direction = get_random_direction_in_cone(col)
        
func get_random_direction_in_cone(collision):
    var cone_angle = PI/4 # 45 degree cone
    var random_angle = (randf() - 0.5) * cone_angle
    var new_direction = collision.get_normal().rotated(random_angle)
    return new_direction.normalized()



        
signal on_queue_free_custom()
    
func queue_free_custom():
    on_queue_free_custom.emit()
    queue_free()
