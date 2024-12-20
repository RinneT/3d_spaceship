extends RigidBody3D

@export var behaviour: AbstractSteering
var character: Kinematic2D = Kinematic2D.new()
var target: Kinematic2D = Kinematic2D.new()
var steering: SteeringOutput2D
var pointer: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	behaviour = Arrive.new()
	behaviour.max_speed = 1.0
	behaviour.slow_radius = 15.0
	behaviour.targetRadius = 1
	behaviour.time_to_target = 0.1
	behaviour.character = character
	behaviour.target = target
	
	pointer = get_parent().get_node("CursorPointer")
	#behaviour = behaviour.new()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Update the ai data
	character.position.x = position.x
	character.position.y = position.z
	
	# Update the target data
	target.position.x = pointer.global_position.x
	target.position.y = pointer.global_position.z
	
	# Update the steering
	steering = behaviour.get_steering()
	
	if steering:
		# Apply the steering behaviours
		# Convert 2D torque into 3D torque
		var steering_torque_3d: Vector3 = Vector3()
		apply_torque(steering_torque_3d)
		# Convert 2D thrust into 3D thrust
		var steering_force_3d: Vector3 = Vector3(steering.linear.x, 0, steering.linear.y)
		apply_central_force(steering_force_3d)
