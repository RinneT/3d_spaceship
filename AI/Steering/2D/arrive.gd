class_name Arrive
extends AbstractSteering

var max_acceleration: float
var target_radius: float
var slow_radius: float
var max_speed: float
var time_to_target: float

# Arrive algorithm to arrive at a target and slow down in time
# Returns null if no steering is required
func get_steering() -> SteeringOutput2D:
	if !max_acceleration:
		push_error("max_acceleration not set for Arrive behaviour!")
	if !target_radius:
		push_error("target_radius not set for Arrive behaviour!")
	if !slow_radius:
		push_error("slow_radius not set for Arrive behaviour!")
	if !max_speed:
		push_error("max_speed not set for Arrive behaviour!")
	if !time_to_target:
		push_error("time_to_target not set for Arrive behaviour!")

	var steering: SteeringOutput2D = SteeringOutput2D.new()
	# Get the direction to the target
	var direction: Vector2 = target.position - character.position
	var distance: float = direction.length()
	
	# Check if we are there, return no steering
	if distance < target_radius:
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
	steering.linear /= time_to_target
	
	# Check if the acceleration is too fast
	if steering.linear.length() > max_acceleration:
		steering.linear = steering.linear.normalized() * max_acceleration
	
	# We do not care about orientation here
	# steering.angular = 0.0 # Unnecessary operation!
	
	return steering
