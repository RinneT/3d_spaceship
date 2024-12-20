class_name Pursue
extends Seek

var max_prediction: float

# Pursue algorithm to find an efficient intercept course to a target
func get_steering() -> SteeringOutput2D:
	var predicted_target: Kinematic2D = target.duplicate()
		
	# Work out the distance to the target
	var direction = target.position - character.position
	var distance = direction.length()
	
	# Work out our current speed
	var speed = character.velocity.length()
	
	# Check if the speed is too small to give a reasonable prediction time
	# Otherwise calculate the prediction time
	var prediction = max_prediction
	if speed > distance / max_prediction:
		prediction = distance / speed
	
	# Put the target together
	predicted_target.position = target.velocity * prediction
	target = predicted_target
	
	# Delegate to seek
	return super.get_steering()
