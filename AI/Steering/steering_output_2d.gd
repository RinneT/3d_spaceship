class_name SteeringOutput2D
extends Node

var linear: Vector2 # desired linear velocity
var angular: float # desired rotational velocity

# Print the Steering values to console
func print() -> void:
	print("Linear: " + str(linear) + " | Angular: " + str(angular))

# Resets all steering input to zero!
func reset() -> void:
	linear.x = 0.0
	linear.y = 0.0
	angular = 0.0

# Combine with another SteeringOutput2D
func blend(other: SteeringOutput2D) -> void:
	linear += other.linear
	angular += other.angular

# Limit the ships steering inputs to their maximum allowed values
func limit(character: SpaceShip) -> void:
	# Limit acceleration
	if linear.length() > character.max_linear_acceleration:
		linear /= linear.length() * character.max_linear_acceleration
	if angular > character.max_angular_acceleration:
		angular = character.max_angular_acceleration
	
	# Limit maximum Speed
	# TODO: Both have to account for deceleration being allowed!
	#if character.angular_velocity.y > character.max_angular_acceleration:
	#	angular = 0.0
