class_name SteeringOutput2D
extends Node

var linear: Vector2 # desired linear velocity
var angular: float # desired rotational velocity

# Print the Steering values to console
func print() -> void:
	print("Linear: " + str(linear) + " | Angular: " + str(angular))

# Combine with another SteeringOutput2D
# TODO: the limits should be kept here!
func blend(other: SteeringOutput2D) -> void:
	linear += other.linear
	angular += other.angular
