class_name Arrive
extends AbstractSteering

# Arrive algorithm to arrive at a target and slow down in time
# Returns null if no steering is required
func get_steering() -> SteeringOutput2D:
	# Get the direction to the target
	var direction: Vector2 = _target.position - _character.position
	var distance: float = direction.length()
	
	# Check if we are there, return no steering
	if distance < character.target_radius_linear:
		return SteeringOutput2D.new()
	
	# If we are outside the slow radius, go max speed
	# Otherwise scale the desired speed down
	var target_speed: float = character.max_linear_speed
	if distance < character.slow_radius_linear:
		target_speed = character.max_linear_speed * distance / character.slow_radius_linear
		
	# The target velocity combines direction and speed
	var targetVelocity = direction.normalized() * target_speed
	
	# Acceleration tries to get to the target velocity
	_steering.linear = targetVelocity - _character.velocity
	_steering.linear /= character.time_to_target_linear
	
	# Check if the acceleration is too fast
	if _steering.linear.length() > character.max_linear_acceleration:
		_steering.linear = _steering.linear.normalized() * character.max_linear_acceleration
	
	# We do not care about orientation here
	# steering.angular = 0.0 # Unnecessary operation!
	
	return _steering
