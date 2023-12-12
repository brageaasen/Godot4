extends "res://scripts/ai/enemy.gd"

@export var Bullet : PackedScene
@export var rotation_speed : float
@export var gun_cooldown : float
@export var machine_gun_cooldown : float
@export var turret_speed : float

func _ready():
	super._ready() # Make parent also run its ready function
	$GunTimer.wait_time = gun_cooldown
	$MachineGunTimer.wait_time = machine_gun_cooldown

func shoot(bullet):
	# Find path of bullet scene
	var bullet_scene_path = bullet.get_path().get_file()
	
	# Check if allowed to shoot
	if can_shoot:
		can_shoot = false
		
		# Check what type of bullet was shot
		if bullet_scene_path.match("*machine_gun_bullet*"): $MachineGunTimer.start()
		else: $GunTimer.start()
		
		# Calculate direction and recoil
		var dir = Vector2(1, 0).rotated($Weapon.global_rotation)
		var recoil_degree_max = current_recoil * 0.5
		var recoil_radians_actual = deg_to_rad(randf_range(-recoil_degree_max, recoil_degree_max))
		var actual_bullet_direction = dir.rotated(recoil_radians_actual)	
		var recoil_increment = max_recoil * 0.1
		current_recoil = clamp(current_recoil + recoil_increment, 0.0, max_recoil)
		
		emit_signal("shootSignal", bullet, $Weapon/Muzzle.global_position, actual_bullet_direction)

func _physics_process(delta):
	super._physics_process(delta)
	if not alive:
		return
	
	var recoil_increment = max_recoil * 0.05
	if not Input.is_action_pressed("left_click") or Input.is_action_pressed("right_click"):
		current_recoil = clamp(current_recoil - recoil_increment, 0.0, max_recoil)

func _process(delta):
	if target:
		var target_dir = (target.global_position - global_position).normalized()
		var current_dir = Vector2(1, 0).rotated($Weapon.global_rotation)
		$Weapon.global_rotation = lerp(current_dir, target_dir, turret_speed * delta).angle()


func _on_GunTimer_timeout():
	can_shoot = true
	
func _on_MachineGunTimer_timeout():
	can_shoot = true

func _on_detect_radius_body_entered(body):
	if body.name == "Player":
		target = body

func _on_detect_radius_body_exited(body):
	if body == target:
		target = null
