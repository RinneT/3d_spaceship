class_name Flee
extends AbstractSteering

# Flee algorithm to find the direction to move away from a
# Does not re-orient the character!
func get_steering() -> SteeringOutput2D:
	# Get the inverse direction from the target
	_steering.linear = _character.position - _target.position

	# Give full acceleration along this direction
	_steering.linear = _steering.linear.normalized()
	_steering.linear *= character.max_linear_acceleration
	
	# We do not care about orientation here
	# steering.angular = 0.0  # Unnecessary operation!
	
	return _steering
