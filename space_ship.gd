extends RigidBody3D

@export var behaviour: AbstractSteering
@export var behaviour2: AbstractSteering
@export var behaviour3: AbstractSteering
@export var max_acceleration: float = 10.0
@export var max_speed: float = 100.0
@export var max_angular_acceleration: float = 10.0
@export var max_rotation: float = 30.0
@export var slow_radius_angular: float = 5.0
@export var slow_radius_linear: float = 30.0
@export var target_radius_angular: float = 0.1
@export var target_radius_linear: float = 5.0
@export var time_to_target: float = 1.0
@export var max_prediction: float = 5.0

var character: Kinematic2D = Kinematic2D.new()
var target: Kinematic2D = Kinematic2D.new()
var steering: SteeringOutput2D
var pointer: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Behaviour #1: Look in the direction of the target
	behaviour = Face.new()
	behaviour.max_rotation = max_rotation
	behaviour.slow_radius = slow_radius_angular
	behaviour.target_radius = target_radius_angular
	behaviour.time_to_target = time_to_target
	behaviour.max_angular_acceleration = max_angular_acceleration
	behaviour.character = character
	behaviour.target = target
	
	# Behaviour #2: Move to the target
	behaviour2 = Arrive.new()
	behaviour2.max_acceleration = max_acceleration
	behaviour2.max_speed = max_speed
	behaviour2.slow_radius = slow_radius_linear
	behaviour2.target_radius = target_radius_linear
	behaviour2.time_to_target = time_to_target
	behaviour2.character = character
	behaviour2.target = target
	
	# Behaviour #3: Look in the same direction as the arrow
	behaviour3 = Align.new()
	behaviour3.max_rotation = max_rotation
	behaviour3.slow_radius = slow_radius_angular
	behaviour3.target_radius = target_radius_angular
	behaviour3.time_to_target = time_to_target
	behaviour3.max_angular_acceleration = max_angular_acceleration
	behaviour3.character = character
	behaviour3.target = target
	
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
	steering = behaviour2.get_steering()
	var distance = (target.position - character.position).length()
	print("Distance: " + str(distance))
	if distance < target_radius_linear:
		steering.blend(behaviour3.get_steering())
	else:
		steering.blend(behaviour.get_steering())
	
	if steering:
		steering.print()
		# Apply the steering behaviours
		# Convert 2D torque into 3D torque
		var steering_torque_3d: Vector3 = Vector3.UP * steering.angular
		apply_torque(steering_torque_3d)
		# Convert 2D thrust into 3D thrust
		var steering_force_3d: Vector3 = Vector3(steering.linear.x, 0, steering.linear.y)
		apply_central_force(steering_force_3d)
