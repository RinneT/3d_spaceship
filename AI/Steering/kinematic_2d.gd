extends Node
class_name Kinematic2D

var position: Vector2
var orientation: float
var velocity: Vector2
var rotation: float 

# Returns a copy of this object
func clone() -> Kinematic2D:
	var dup: Kinematic2D = Kinematic2D.new()
	dup.position = position
	dup.orientation = orientation
	dup.velocity = velocity
	dup.rotation = rotation
	return dup

# Update the Kinematic2D object from a RigidBody2D parent
func update2D(object: RigidBody2D) -> void:
	position = object.position
	orientation = object.rotation
	velocity = object.linear_velocity
	rotation = object.angular_velocity

# Update the Kinematic2D object from a RigidBody3D parent.
# Assumes the object operates on the x/z axis
func update3D(object: RigidBody3D) -> void:
	position.x = object.position.x
	position.y = object.position.z
	orientation = atan2(object.rotation.x, object.rotation.z)
	velocity.x = object.linear_velocity.x
	velocity.y = object.linear_velocity.z
	rotation = object.angular_velocity.y

# Update the Kinematic2D object from a RigidBody3D parent.
# Assumes the object operates on the x/z axis
func updateNode3D(object: Node3D) -> void:
	position.x = object.position.x
	position.y = object.position.z
	orientation = object.rotation.y

# Creates a new initialized Kinematic2D object from a RigidBody2D
func initFrom2D(object: RigidBody2D) -> void:
	position = object.position
	orientation = object.rotation
	velocity = object.linear_velocity
	rotation = object.angular_velocity

# Creates a new initialized Kinematic2D object from a RigidBody3D
func initFrom3D(object: RigidBody3D) -> void:
	position = Vector2(object.position.x, object.position.z)
	orientation = atan2(object.rotation.x, object.rotation.z)
	velocity = Vector2(object.linear_velocity.x, object.linear_velocity.z)
	rotation = object.angular_velocity.y

# Creates a new initialized Kinematic2D object from a Node3D
func initFromNode3D(object: Node3D) -> void:
	position = Vector2(object.position.x, object.position.z)
	orientation = atan2(object.rotation.x, object.rotation.z)
	velocity = Vector2()
	rotation = 0

# Prints the data of a Kinematic2D object to console
func print(name: String = "Kinematic2D") -> void:
	print(name + " Position: " + str(position) + " | Orientation: " + str(orientation) + " | Velocity: " + str(velocity) + " | Rotation: " + str(rotation))
