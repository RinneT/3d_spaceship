extends Camera3D

var pointer : MeshInstance3D
var arrow : Node3D
var ship : RigidBody3D
var max_torque_pitch: float = 20.0
var max_torque_yaw: float = 40.0
var max_torque_roll: float = 10.0
var proportionate_factor: float = 10.0
var derivative_factor: float = 10.0
var integral_factor: float = 0.01
var integral: float = 0.0

var torque := Vector3()
var last_rotation := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pointer = get_parent().get_node("CursorPointer")
	arrow = get_parent().get_node("Direction_Arrow")
	ship = get_parent().get_node("Space_Ship")
	
	# Init for PID controller
	last_rotation = ship.rotation.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	set_cursor_position(delta)
	#ship.apply_torque(torque)

func set_cursor_position(delta: float):
	# https://www.youtube.com/watch?v=mJRDyXsxT9g
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 1000
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.collide_with_areas = true
	ray_query.from = from
	ray_query.to = to
	# Check for collisions with the invisible zero plane at the mouse pointer location
	var raycast_result = space.intersect_ray(ray_query)
	#print (raycast_result)
	
	if !raycast_result.is_empty():
		# Set the "Cursor Pointer" to the previously found collision position
		var pos = raycast_result["position"]
		pointer.global_position = pos
		
		# Make the direction arrow look at the collision position
		arrow.look_at(pos, Vector3.UP)
		
		#var torque_vec = get_torque_vector(ship, pos)
		#ship.apply_torque(torque_vec)
		

# Find the desired rotation torque vector
# TODO: As of now, this changes orientation along the ships y axis depending on the direction
# TODO: It also inverts the direction not at 180 degree, but somewhere in the rear right corner
# From https://forum.godotengine.org/t/how-to-find-a-torque-to-rotate-an-object-towards-a-desired-rotation/13914/3
func get_torque_vector(source : RigidBody3D, target: Vector3) -> Vector3:
	var desired_rotation := Quaternion(source.transform.looking_at((target),Vector3.UP).basis)
	var quat_change := Quaternion(source.transform.basis).inverse() * desired_rotation
	var angle = 2 * acos(quat_change.w)
	var axis: Vector3
	if (angle == 0):
		axis = Vector3.ZERO
	else:
		axis = (1 / sin(angle/2)) * Vector3(quat_change.x, quat_change.y, quat_change.z)
	var direction_vector = axis.normalized()
	var rot := Vector3(source.rotation.x, source.rotation.z, source.rotation.y)
	print("Angle: " + str(angle) + " : " + str(axis) + " : " + str(rot.signed_angle_to(target, Vector3.UP)))

	return pid_control(angle, direction_vector, source.angular_velocity)

# Calculate the forces required to make the ship look at a point using # PID control
func pid_control(angle: float, vector: Vector3, angular_velocity: Vector3) -> Vector3:
	# Proportionate: The farther we are from the goal (the higher the angle), the higher we want to thrust
	var proportionate_vector: Vector3 = angle * vector * proportionate_factor
	# Derivative: Use the current rotational velocity and subtract it from the desired velocity.
	# This will produce countertrust to stop the rotation in time
	var derivative_vector: Vector3 = angular_velocity * derivative_factor * -1
	# Integral: This will add a bit of additional trust,
	# in case the proportionate and derivative cancel each other out
	# This could be tuned on each axis
	var integral_value: float = integral + angle * integral_factor
	var integral_vector: = derivative_vector * integral_value * -1
	
	# The desired torque is the sum of proportionate, derivative and integral
	var desired_torque: Vector3 = proportionate_vector + derivative_vector + integral_vector
	# Clamp the desired torque to the maximum the thrusters can manage
	var torque_vector: Vector3 = Vector3(clamp(desired_torque.x, -max_torque_pitch, max_torque_pitch),
		clamp(desired_torque.y, -max_torque_roll, max_torque_roll),
		clamp(desired_torque.z, -max_torque_yaw, max_torque_yaw))
	
	#print("PID: Angle: " + str(angle) + " Base Vector: " + str(vector) + " Proportionate: " + str(proportionate_vector) + " Derivative: " + str(derivative_vector) + " Integral: " + str(integral_vector) + " Desired Torque: " + str(desired_torque) + " Clamped Torque: " + str(torque_vector))
	return torque_vector
