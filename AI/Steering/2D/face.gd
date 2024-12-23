class_name Face
extends Align

# Face algorithm to look at a given target
func get_steering() -> SteeringOutput2D:
	# Work out the distance to the target
	var direction = target.position - character.position
	
	# Check for a zero direction and make no change if so
	if direction.length() == 0:
		return SteeringOutput2D.new()
	
	# Put the target together
	target = target.clone()
	target.orientation = atan2(direction.x, direction.y)
	
	# Delegate to align
	return super.get_steering()
