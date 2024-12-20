class_name Arrive
extends AbstractSteering

var targetRadius: float
var slow_radius: float
var max_speed: float
var time_to_target: float

# Arrive algorithm to arrive at a target and slow down in time
# Returns null if no steering is required
func get_steering() -> SteeringOutput2D:
	var steering: SteeringOutput2D = SteeringOutput2D.new()
	# Get the direction to the target
	var direction: Vector2 = target.position - character.position
	var distance: float = direction.length()
	
	# Check if we are there, return no steering
	if distance < targetRadius:
		return null
	
	# If we are outside the slow radius, go max speed
	# Otherwise scale the desired speed down
	var target_speed: float = max_speed
	if distance < slow_radius:
		target_speed = max_speed * distance / slow_radius
		
	# The target velocity combines direction and speed
	var targetVelocity = direction.normalized() * target_speed
	
	# Acceleration tries to get to the target velocity
	steering.linear = targetVelocity - character.velocity
	steering.linear = steering.linear / time_to_target
	
	# We do not care about orientation here
	# steering.angular = 0.0 # Unnecessary operation!
	
	return steering
