extends RigidBody3D

class_name SpaceShip

var behaviour: AbstractSteering
var behaviour2: AbstractSteering
var behaviour3: AbstractSteering

# Spaceship properties
@export var max_linear_acceleration: float = 100000.0
@export var max_linear_speed: float = 100000.0
@export var max_angular_acceleration: float = 100000.0
@export var max_rotation_speed: float = 90000.0
@export var slow_radius_angular: float = 5.0
@export var slow_radius_linear: float = 30.0
@export var target_radius_angular: float = 0.1
@export var target_radius_linear: float = 5.0
@export var time_to_target_angular: float = 1.0
@export var time_to_target_linear: float = 1.0
@export var max_prediction: float = 5.0

var thrusters_up: Array[GPUParticles3D] = []
var thrusters_down: Array[GPUParticles3D] = []
var thrusters_left: Array[GPUParticles3D] = []
var thrusters_right: Array[GPUParticles3D] = []

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
	
	init_thrusters()


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
		engage_thrusters(steering_force_3d)

func engage_thrusters(steering_force_3d: Vector3) -> void:
	reset_thrusters()
	if steering_force_3d.x > 0:
		for i in thrusters_left:
			i.visible = true
	if steering_force_3d.x < 0:
		for i in thrusters_right:
			i.visible = true

func reset_thrusters() -> void:
	for i in thrusters_up:
		i.visible = false
	for i in thrusters_down:
		i.visible = false
	for i in thrusters_left:
		i.visible = false
	for i in thrusters_right:
		i.visible = false

# Position the Thruster Paricle system at the right locations
func init_thrusters() -> void:
	for i in get_node("Space_Ship_Mesh").get_children():
		var child_name = i.name
		if child_name.contains("thruster"):
			if child_name.ends_with("up"):
				thrusters_up.append(add_thruster(i))
			if child_name.ends_with("down"):
				thrusters_down.append(add_thruster(i))
			if child_name.ends_with("left"):
				thrusters_left.append(add_thruster(i))
			if child_name.ends_with("right"):
				thrusters_right.append(add_thruster(i))


# Creates a new Thruster Particle instance at the position of a thruster mesh
func add_thruster(thruster_mesh: MeshInstance3D) -> GPUParticles3D:
	var particles: GPUParticles3D = get_node("Thruster_Particles")
	var new_particles: GPUParticles3D = particles.duplicate()
	new_particles.name = thruster_mesh.name + "_particles"
	# new_particles.visible = true # TODO: change dynamically
	thruster_mesh.add_child(new_particles)
	return new_particles
