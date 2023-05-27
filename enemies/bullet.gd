extends Area2D

@export var speed: float = 200.0
var direction: Vector2

func _ready() -> void:
	get_node("VisibleOnScreenNotifier2D").screen_exited.connect(on_screen_exited)
	self.body_entered.connect(on_body_entered)
	
func on_screen_exited() -> void:
	queue_free()

func start(position, direction):
	self.position = position
	self.direction = direction.normalized()

func _physics_process(delta):
	position += direction * speed * delta

func on_body_entered(body):
	if body.is_in_group("enemies"):
		body.queue_free()
		self.queue_free()
