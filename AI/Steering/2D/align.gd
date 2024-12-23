class_name Align
extends AbstractSteering

# Align algorithm to rotate to a target orientation and slow rotation down in time
# Returns null if no steering is required
# To Face the opposite direction, add pi to the target orientation!
func get_steering() -> SteeringOutput2D:
	# Get the naive direction to the target
	var rotation_direction: float = _target.orientation - _character.orientation
	
	# Map the result to the (-pi, pi) interval
	var rotation = wrapf(rotation_direction, -PI, PI)
	var rotation_size = absf(rotation_direction)
	
	# Check if we are there, return no steering
	if rotation_size < character.target_radius_angular:
		return _steering
	
	# If we are outside the slow radius, use maximum rotation
	# Otherwise, calculate a scaled rotation
	var target_rotation = character.max_rotation_speed
	if rotation_size < character.slow_radius_angular:
		target_rotation *= rotation_size / character.slow_radius_angular
	
	# The final target rotation combines speed and direction
	target_rotation *= rotation / rotation_size
	
	# Acceleration tries to get to the target rotation
	_steering.angular = target_rotation - _character.rotation
	_steering.angular /= character.time_to_target_angular
	
	# Check if the acceleration is too great
	var angular_acceleration: float = absf(_steering.angular)
	if angular_acceleration > character.max_angular_acceleration:
		_steering.angular /= angular_acceleration
		_steering.angular *= character.max_angular_acceleration
	
	# We do not care about linear velocity here
	# steering.linear = Vector2() # Unnecessary operation!
	
	return _steering
