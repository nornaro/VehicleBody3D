@tool
extends VehicleBody3D

enum Vehicle {
	Sphere, Car, Tank, Bike,
	Airplane, Helicopter, Spacecraft, Hovercraft,
	Submarine, Rocket, Boat, Walker
}

var direction: Vector2
var type: Vehicle = Vehicle.Sphere
@export var wheels: Array[VehicleWheel3D]
@export var camera: Camera3D
@export var settings: Dictionary = {
			"camera_offset" = Vector3(0, 3, 1),
			"force" = 2.5,
			"max_force" = 150.0,
			"max_brake" = 3.0,
			"steer" = 0.4,
			"max_steer" = 0.8,
			"drive" = "A", # A:AllWD, F: FrontWD, B: BackWD, 4: 4WD
}

func _input(event: InputEvent) -> void:
	match type:
		Vehicle.Sphere:
			direction = Vector2(Input.get_axis("left", "right"),Input.get_axis("forward", "backward"))
			#linear_velocity = lerp()
		Vehicle.Car:
			steering = move_toward(steering, Input.get_axis("right", "left") * settings.max_steer, settings.steer)
			engine_force = move_toward(engine_force, Input.get_axis("backward", "forward") * settings.max_force, settings.force)
		Vehicle.Tank:
			# Get the raw axis inputs
			var right_left_input = Input.get_axis("right", "left")
			var forward_backward_input = Input.get_axis("backward", "forward")

			# Normalize the inputs so that both have 50% power if both are active
			if abs(right_left_input) > 0 and abs(forward_backward_input) > 0:
				right_left_input *= 0.5
				forward_backward_input *= 0.5

			# Apply the steering and engine force calculations
			steering = move_toward(steering, right_left_input * settings.max_steer, settings.steer)
			engine_force = move_toward(engine_force, forward_backward_input * settings.max_force, settings.force)


func _physics_process(delta: float) -> void:
	match type:
		Vehicle.Sphere:
			linear_velocity += Vector3(direction.x,0,direction.y)*clamp(settings.force*delta,-settings.max_force,settings.max_force)
			camera.position = position + settings.camera_offset


func _ready() -> void:
	type = Vehicle[StringName(get_meta("type"))]
	match type:
		Vehicle.Sphere:
			pass
		Vehicle.Car:
			pass
		Vehicle.Tank:
			pass
