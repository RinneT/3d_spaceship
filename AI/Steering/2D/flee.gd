class_name Flee
extends AbstractSteering

var maxAcceleration: float

# Flee algorithm to find the direction to move away from a
# Does not re-orient the character!
func get_steering() -> SteeringOutput2D:
	var steering: SteeringOutput2D = SteeringOutput2D.new()
	# Get the inverse direction from the target
	steering.linear = character.position - target.position

	# Give full acceleration along this direction
	steering.linear = steering.linear.normalized()
	steering.linear *= maxAcceleration
	
	# We do not care about orientation here
	# steering.angular = 0.0  # Unnecessary operation!
	
	return steering
