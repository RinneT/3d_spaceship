class_name Align
extends AbstractSteering

var max_angular_acceleration: float
var max_rotation: float
var target_radius: float
var slow_radius: float
var time_to_target: float

# Align algorithm to rotate to a target orientation and slow rotation down in time
# Returns null if no steering is required
# To Face the opposite direction, add pi to the target orientation!
func get_steering() -> SteeringOutput2D:
	if !max_angular_acceleration:
		push_error("max_angular_acceleration not set for Align behaviour!")
	if !target_radius:
		push_error("target_radius not set for Align behaviour!")
	if !slow_radius:
		push_error("slow_radius not set for Align behaviour!")
	if !max_rotation:
		push_error("max_rotation not set for Align behaviour!")
	if !time_to_target:
		push_error("time_to_target not set for Align behaviour!")

	var steering: SteeringOutput2D = SteeringOutput2D.new()
	# Get the naive direction to the target
	var rotation_direction: float = target.orientation - character.orientation
	
	# Map the result to the (-pi, pi) interval
	var rotation = rotation_direction # TODO: remap()??
	var rotation_size = abs(rotation_direction)
	
	# Check if we are there, return no steering
	if rotation_size < target_radius:
		return null
	
	# If we are outside the slow radius, use maximum rotation
	# Otherwise, calculate a scaled rotation
	var target_rotation = max_rotation
	if rotation_size < slow_radius:
		target_rotation = max_rotation * rotation_size / slow_radius
	
	# The final target rotation combines speed and direction
	target_rotation *= rotation / rotation_size
	
	# Acceleration tries to get to the target rotation
	steering.angular = target.rotation - character.rotation
	steering.angular /= time_to_target
	
	# Check if the acceleration is too great
	var angular_acceleration: float = abs(steering.angular)
	if angular_acceleration > max_angular_acceleration:
		steering.angular /= angular_acceleration
		steering.angular *= max_angular_acceleration
	
	# We do not care about linear velocity here
	# steering.linear = Vector2() # Unnecessary operation!
	
	return steering
