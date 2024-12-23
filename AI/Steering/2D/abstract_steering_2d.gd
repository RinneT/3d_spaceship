extends Node
class_name AbstractSteering

# Steering behaviour scripts for 2D space based on
# "Artifical Intelligence for Games" by Ian Millington and John Funge
# A few customizations have been made.
# E.g. the steering behaviours will always return the desired velocity,
# without care for the characters boundaries.
# Capping must be conducted separately

var character: SpaceShip
var _character: Kinematic2D
var target: Kinematic2D # Currently unused
var _target: Kinematic2D
var _steering: SteeringOutput2D

# Initializes the required variables
func init(character: SpaceShip, target: Kinematic2D):
	self.target = target
	self._target = target.clone()
	self.character = character
	self._character = Kinematic2D.new()
	self._character.initFrom3D(character)
	self._steering = SteeringOutput2D.new()
	self._steering.reset()

# Update with Node3D target data and reset the steering
func updateNode3D(target: Node3D):
	_character.update3D(character)
	_target.updateNode3D(target)
	_steering.reset()

# Update with RigidBody3D target data and reset the steering
func updateRigidBody3D(target: RigidBody3D):
	_character.update3D(character)
	_target.update3D(target)
	_steering.reset()

# Return an empty steering output
func get_steering() -> SteeringOutput2D:
	push_error("Called get_steering in AbstractSteering class! Instantiate a behaviour class instead!")
	return SteeringOutput2D.new()
