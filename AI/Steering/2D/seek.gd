class_name Seek
extends AbstractSteering

# Seek algorithm to find the direction to a point
# Does not re-orient the character!
func get_steering() -> SteeringOutput2D:
	# Get the direction to the target
	_steering.linear = _target.position - _character.position
	
	# Give full acceleration along this direction
	_steering.linear = _steering.linear.normalized()
	_steering.linear *= character.max_linear_acceleration
	
	# We do not care about orientation here
	# steering.angular = 0.0  # Unnecessary operation!
	
	return _steering
