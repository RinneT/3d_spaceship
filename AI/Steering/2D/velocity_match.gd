class_name VelocityMatch
extends AbstractSteering

var time_to_target: float

# Try to match the velocity of a target
func get_steering() -> SteeringOutput2D:
	var steering: SteeringOutput2D = SteeringOutput2D.new()
	
	# Acceleration tries to get to the target velocity
	steering.linear = target.velocity - character.velocity
	steering.linear /= time_to_target
	
	# We do not care about orientation here
	# steering.angular = 0.0 # Unnecessary operation!
	
	return steering
