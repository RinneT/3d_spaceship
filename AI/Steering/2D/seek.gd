class_name Seek
extends AbstractSteering

var max_acceleration: float

# Seek algorithm to find the direction to a point
# Does not re-orient the character!
func get_steering() -> SteeringOutput2D:
	if !max_acceleration:
		push_error("max_acceleration not set for Seek behaviour!")
	var steering: SteeringOutput2D = SteeringOutput2D.new()
	# Get the direction to the target
	steering.linear = target.position - character.position
	
	# Give full acceleration along this direction
	steering.linear = steering.linear.normalized()
	steering.linear *= max_acceleration
	
	# We do not care about orientation here
	# steering.angular = 0.0  # Unnecessary operation!
	
	return steering
