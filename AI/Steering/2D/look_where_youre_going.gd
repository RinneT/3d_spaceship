class_name LookWhereYoureGoing
extends Align

# Function to make a character look where they are going
func get_steering() -> SteeringOutput2D:
	# Check for a zero direction and make no change if so
	if character.velocity.length() == 0:
		return _steering
	
	# Otherwise set the target direction based on velocity
	_target.orientation = atan2(-character.velocity.x, _character.velocity.y)
	
	# Delegate to align
	return super.get_steering()
