class_name Utils

const SAVE_UID_LENGTH: int = 10
const UID_LENGTH: int = 10
	
static func gen_save_uid() -> String:
	return "save_" + _gen_random_str(SAVE_UID_LENGTH)

static func gen_uid(prefix: String) -> String:
	return prefix + "_" + _gen_random_str(UID_LENGTH)

static func _gen_random_str(length: int) -> String:
	var charset: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	var result: String = ""
	for _i: int in range(length):
		var random_index: int = randi() % charset.length()
		result += charset[random_index]
	return result

static func clear_node(node: Node) -> void:
	for n: Node in node.get_children():
		node.remove_child(n)
		n.queue_free()

static func rotation_to_vector(angle:float) -> Vector2:
	return Vector2(cos(angle), sin(angle))
