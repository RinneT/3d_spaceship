class_name VelocityMatch
extends AbstractSteering

# Try to match the velocity of a target
func get_steering() -> SteeringOutput2D:
	# Acceleration tries to get to the target velocity
	_steering.linear = _target.velocity - _character.velocity
	_steering.linear /= character.time_to_target_linear
	
	# We do not care about orientation here
	# steering.angular = 0.0 # Unnecessary operation!
	
	return _steering
