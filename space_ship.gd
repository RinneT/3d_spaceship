extends RigidBody3D

class_name SpaceShip

var behaviour: AbstractSteering
var behaviour2: AbstractSteering
var behaviour3: AbstractSteering

# Spaceship properties
@export var max_linear_acceleration: float = 10.0
@export var max_linear_speed: float = 100.0
@export var max_angular_acceleration: float = 10.0
@export var max_rotation_speed: float = 30.0
@export var slow_radius_angular: float = 5.0
@export var slow_radius_linear: float = 30.0
@export var target_radius_angular: float = 0.1
@export var target_radius_linear: float = 5.0
@export var time_to_target_angular: float = 1.0
@export var time_to_target_linear: float = 1.0
@export var max_prediction: float = 5.0

var target: Kinematic2D = Kinematic2D.new()
var steering: SteeringOutput2D
var pointer: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Behaviour #1: Look in the direction of the target
	behaviour = Face.new()
	behaviour.init(self, target)
	
	# Behaviour #2: Move to the target
	behaviour2 = Arrive.new()
	behaviour2.init(self, target)
	
	# Behaviour #3: Look in the same direction as the arrow
	behaviour3 = Align.new()
	behaviour3.init(self, target)
	
	pointer = get_parent().get_node("CursorPointer")
	target.initFromNode3D(pointer)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Update the steering
	behaviour.updateNode3D(pointer)
	behaviour2.updateNode3D(pointer)
	behaviour3.updateNode3D(pointer)
	steering = behaviour2.get_steering()
	var distance = (pointer.position - self.position).length()
	print("Distance: " + str(distance))
	if distance < target_radius_linear:
		steering.blend(behaviour3.get_steering())
	else:
		steering.blend(behaviour.get_steering())
	
	if steering:
		steering.print()
		steering.limit(self)
		# Apply the steering behaviours
		# Convert 2D torque into 3D torque
		var steering_torque_3d: Vector3 = Vector3.UP * steering.angular
		apply_torque(steering_torque_3d)
		# Convert 2D thrust into 3D thrust
		var steering_force_3d: Vector3 = Vector3(steering.linear.x, 0, steering.linear.y)
		apply_central_force(steering_force_3d)
