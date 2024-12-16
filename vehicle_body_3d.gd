@tool
extends VehicleBody3D

enum Vehicle {
	Sphere, Car, Tank, Bike,
	Airplane, Helicopter, Spacecraft, Hovercraft,
	Submarine, Rocket, Boat, Walker
}

var old_type: Vehicle = Vehicle.Car
var direction: Vector2
@export var type: Vehicle = Vehicle.Car
@export var wheels: Array[VehicleWheel3D]
@export var camera: Camera3D
@export var settings: Dictionary = {}

func _input(event: InputEvent) -> void:
	match type:
		Vehicle.Sphere:
			direction = Vector2(Input.get_axis("left", "right"),Input.get_axis("forward", "backward"))
			#linear_velocity = lerp()
		Vehicle.Car:
			steering = move_toward(steering, Input.get_axis("right", "left") * settings.max_steer, settings.steer)
			engine_force = move_toward(engine_force, Input.get_axis("backward", "forward") * settings.max_force, settings.force)


#func _physics_process(delta: float) -> void:
	#
	## Camera position based on camera_offset
	#if camera:
		#camera.position = position + settings.get("camera_offset", Vector3.ZERO)


func _physics_process(delta: float) -> void:
	if type != old_type:
		update_settings()
		old_type = type
		notify_property_list_changed()
	match type:
		Vehicle.Sphere:
			#angular_velocity = linear_velocity
			#look_at(Vector3(direction.x,0,direction.y))
			
			linear_velocity += Vector3(direction.x,0,direction.y)*clamp(settings.force*delta,-settings.max_force,settings.max_force)
			#look_at(linear_velocity*10)
			camera.position = position + Vector3(0,10,0)
			print(linear_velocity.normalized())


# Updates the settings dictionary based on the vehicle type.
func update_settings():
	match type:
		Vehicle.Sphere:
			settings["camera_offset"] = Vector3(0, 3, 1)
			settings["force"] = 2.5
			settings["max_force"] = 150.0
			settings["max_brake"] = 3.0
			settings["steer"] = 0.4
			settings["max_steer"] = 0.8
		Vehicle.Car:
			settings["camera_offset"] = Vector3(0, 3, 1)
			settings["force"] = 10.0
			settings["max_force"] = 150.0
			settings["max_brake"] = 3.0
			settings["steer"] = 0.4
			settings["max_steer"] = 0.8
		Vehicle.Tank:
			settings["camera_offset"] = Vector3(0, 4, 2)
			settings["force"] = 10.0
			settings["max_force"] = 100.0
			settings["max_brake"] = 4.0
			settings["steer"] = 0.25
			settings["max_steer"] = 0.5
		Vehicle.Bike:
			settings["camera_offset"] = Vector3(0, 2, 1)
			settings["force"] = 10.0
			settings["max_force"] = 40.0
			settings["max_brake"] = 1.5
			settings["steer"] = 0.5
			settings["max_steer"] = 1.0
