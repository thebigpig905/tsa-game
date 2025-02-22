extends AudioStreamPlayer2D



var rng = RandomNumberGenerator.new()



# changes pitch to a random number
func _process(delta):
	
	if self.playing:
		self.pitch_scale = rng.randf_range(0.1, 2.4)
		
