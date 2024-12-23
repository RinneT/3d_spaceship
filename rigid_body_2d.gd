extends RigidBody2D

@export var behaviour: AbstractSteering
@export var max_acceleration: float = 10.0
@export var max_speed: float = 100.0
@export var max_angular_acceleration: float = 100.0
@export var max_rotation: float = 300.0
@export var slow_radius: float = 10.0
@export var target_radius: float = 0.1
@export var time_to_target: float = 0.1

var character: Kinematic2D = Kinematic2D.new()
var target: Kinematic2D = Kinematic2D.new()
var steering: SteeringOutput2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	behaviour = Face.new()
	behaviour.max_rotation = max_rotation
	behaviour.slow_radius = slow_radius
	behaviour.target_radius = target_radius
	behaviour.time_to_target = time_to_target
	behaviour.max_angular_acceleration = max_angular_acceleration
	behaviour._character = character
	behaviour.target = target


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pos: Vector2 = get_global_mouse_position()
	#look_at(pos)
	
		# Update the ai data
	character.update2D(self)
	character.print("Spaceship")
	
	# Update the target data
	target.position = pos
	character.print("Pointer")
	
	# Update the steering
	steering = behaviour.get_steering()
	if steering:
		steering.print()
	
	if steering:
		# Apply the steering behaviours
		apply_torque(steering.angular)

		apply_central_force(steering.linear)
