shader_type particles;

// Target position in global coordinates that particles should flow toward
uniform vec2 target_position = vec2(0.0, 0.0);
// Source position (galaxy center) in global coordinates
uniform vec2 source_position = vec2(0.0, 0.0);
// Attraction strength - how strongly particles are pulled toward target
uniform float attraction_strength = 200.0;
// Base speed for particles
uniform float base_speed = 80.0;
// Spawn radius around source
uniform float spawn_radius = 30.0;

// Hash function for random number generation
float hash(uint n) {
	n = (n << 13u) ^ n;
	n = n * (n * n * 15731u + 789221u) + 1376312589u;
	return float(n & 0x7fffffffu) / float(0x7fffffff);
}

void start() {
	// Random position within spawn radius around the source
	uint seed = INDEX + uint(TIME * 1000.0);
	float angle = hash(seed) * TAU;
	float radius = hash(seed + 1u) * spawn_radius;

	// Set initial position relative to source
	vec2 spawn_offset = vec2(cos(angle) * radius, sin(angle) * radius);
	TRANSFORM[3].xy = source_position + spawn_offset;

	// Calculate initial velocity toward target
	vec2 to_target = target_position - TRANSFORM[3].xy;
	float dist = length(to_target);

	if (dist > 0.001) {
		vec2 direction = to_target / dist;
		float speed_variance = hash(seed + 2u) * 0.4 + 0.8; // 0.8 to 1.2
		VELOCITY.xy = direction * base_speed * speed_variance;
	} else {
		VELOCITY.xy = vec2(0.0);
	}

	// Don't override COLOR - let default particle rendering handle it
}

void process() {
	// Current particle position
	vec2 current_pos = TRANSFORM[3].xy;

	// Calculate direction and distance to target
	vec2 to_target = target_position - current_pos;
	float dist = length(to_target);

	// Apply attraction force that increases as particle approaches target
	if (dist > 0.001) {
		vec2 direction = to_target / dist;

		// Stronger acceleration as we get closer
		float proximity_factor = 1.0 + (1.0 / max(dist * 0.02, 0.5));
		vec2 acceleration = direction * attraction_strength * proximity_factor * DELTA;

		VELOCITY.xy += acceleration;

		// Clamp maximum velocity to prevent overshooting
		float speed = length(VELOCITY.xy);
		float max_speed = base_speed * 3.0;
		if (speed > max_speed) {
			VELOCITY.xy = (VELOCITY.xy / speed) * max_speed;
		}
	}

	// Don't modify COLOR - let Godot's default particle rendering and color_ramp handle it

	// Kill particle when very close to target
	if (dist < 5.0) {
		ACTIVE = false;
	}
}
