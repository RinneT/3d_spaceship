extends RigidBody3D

@export var behaviour: AbstractSteering
@export var max_acceleration: float = 10.0
@export var max_speed: float = 100.0
@export var max_angular_acceleration: float = 1.0
@export var max_rotation: float = 3.0
@export var slow_radius: float = 10.0
@export var target_radius: float = 0.1
@export var time_to_target: float = 0.1

var character: Kinematic2D = Kinematic2D.new()
var target: Kinematic2D = Kinematic2D.new()
var steering: SteeringOutput2D
var pointer: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	behaviour = Align.new()
	behaviour.max_rotation = max_rotation
	behaviour.slow_radius = slow_radius
	behaviour.target_radius = target_radius
	behaviour.time_to_target = time_to_target
	behaviour.max_angular_acceleration = max_angular_acceleration
	behaviour.character = character
	behaviour.target = target
	
	pointer = get_parent().get_node("CursorPointer")
	character.initFrom3D(self)
	target.initFromNode3D(pointer)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Update the ai data
	character.update3D(self)
	character.print("Spaceship")
	
	# Update the target data
	target.updateNode3D(pointer)
	character.print("Pointer")
	
	# Update the steering
	steering = behaviour.get_steering()
	if steering:
		steering.print()
	
	if steering:
		# Apply the steering behaviours
		# Convert 2D torque into 3D torque
		var steering_torque_3d: Vector3 = Vector3.UP * steering.angular
		apply_torque(steering_torque_3d)
		# Convert 2D thrust into 3D thrust
		var steering_force_3d: Vector3 = Vector3(steering.linear.x, 0, steering.linear.y)
		apply_central_force(steering_force_3d)
