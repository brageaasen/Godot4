extends Control

func update_healthbar(value):
	var tween = create_tween()
	tween.tween_property($MarginContainer/Container/HealthBar, "value", value, 0.2).set_trans(Tween.TRANS_LINEAR)

func update_experiencebar(value):
	var tween = create_tween()
	tween.tween_property($MarginContainer/Container/ExperienceBar, "value", value, 0.2).set_trans(Tween.TRANS_LINEAR)

func _on_player_ammo_updated(bullet, ammo_count):
	var bullet_scene_path = bullet.get_path().get_file()
	if bullet_scene_path.match("*player_bullet*"):
		$AmmoStorage.text = "Ammo: " + str(ammo_count)
	elif bullet_scene_path.match("*machine_gun_bullet*"):
		$MachineGunAmmoStorage.text = "Ammo: " + str(ammo_count)
