class_name Face
extends Align

# Face algorithm to look at a given target
func get_steering() -> SteeringOutput2D:
	var predicted_target: Kinematic2D = target.clone()
	
	# Work out the distance to the target
	var direction = target.position - character.position
	
	# Check for a zero direction and make no change if so
	if direction.length() == 0:
		return null
	
	# Put the target together
	predicted_target.orientation = atan2(-direction.x, direction.y)
	target = predicted_target
	
	# Delegate to align
	return super.get_steering()
