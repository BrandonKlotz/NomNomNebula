extends TextureRect

func _process(delta):
	var player_vel = Globals.player.velocity
	
	var offset: Vector2 = self.material.get_shader_parameter("offset")
	offset += player_vel * delta * 0.001
	
	material.set_shader_parameter("offset", offset)
