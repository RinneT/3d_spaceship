class_name Pursue
extends Seek

# Pursue algorithm to find an efficient intercept course to a target
func get_steering() -> SteeringOutput2D:
	# Work out the distance to the target
	var direction = _target.position - _character.position
	var distance = direction.length()
	
	# Work out our current speed
	var speed = character.velocity.length()
	
	# Check if the speed is too small to give a reasonable prediction time
	# Otherwise calculate the prediction time
	var prediction = character.max_prediction
	if speed > distance / character.max_prediction:
		prediction = distance / speed
		
	# Put the target together
	_target.position = _target.velocity * prediction
	
	# Delegate to seek
	return super.get_steering()
