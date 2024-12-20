class_name LookWhereYoureGoing
extends Align

# Function to make a character look where they are going
func get_steering() -> SteeringOutput2D:
	var steering: SteeringOutput2D = SteeringOutput2D.new()
	
	# Check for a zero direction and make no change if so
	if character.velocity.length() == 0:
		return null
	
	# Otherwise set the target direction based on velocity
	var target: Kinematic2D = character.duplicate()
	target.orientation = atan2(-character.velocity.x, character.velocity.y)
	
	# Delegate to align
	return super.get_steering()
