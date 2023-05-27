extends CharacterBody2D

var movement_speed: float = 24.0
var navigation_agent: NavigationAgent2D
var player: Node2D
var stored_delta: float = 0.0

# Initial setup for the agent
func setup(player: Node2D):
	self.player = player
	navigation_agent = $NavigationAgent2D

	# Set navigation agent properties
	navigation_agent.avoidance_enabled = true
	navigation_agent.radius = 12.0
	navigation_agent.target_desired_distance = navigation_agent.radius * 2.0
	navigation_agent.path_desired_distance = navigation_agent.radius * 2.0
	navigation_agent.neighbor_distance = navigation_agent.radius * 200.0

	# Connect signals
	navigation_agent.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)

	# Call deferred setup
	call_deferred("actor_setup")

# Handle computed velocity by updating agent's position
func _on_navigation_agent_2d_velocity_computed(safe_velocity : Vector2):
	global_transform.origin += safe_velocity * stored_delta

# Actor setup function
func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(player.global_position)

# Set target position for the agent
func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

# Physics process function
func _physics_process(delta: float):
	set_movement_target(player.global_position)
	stored_delta = delta
	
	# Skip remaining logic if navigation is finished
	if navigation_agent.is_navigation_finished():
		return

	# Calculate the next position
	var current_agent_position : Vector2 = global_transform.origin
	var next_path_position : Vector2 = navigation_agent.get_next_path_position()

	# Check distance to next path position
	if current_agent_position.distance_to(next_path_position) < navigation_agent.radius:
		next_path_position = navigation_agent.get_next_path_position()

	# Calculate new velocity
	var new_velocity: Vector2 = (next_path_position - current_agent_position).normalized() * movement_speed

	# Set agent's velocity
	navigation_agent.set_velocity(new_velocity)
	navigation_agent.set_velocity_forced(new_velocity)
