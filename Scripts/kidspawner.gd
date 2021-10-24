extends Timer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const KID = preload("res://Scenes/kid.tscn")

# TODO don't hardcode
const CANVASWIDTH = 384
const CANVASHEIGHT = 225


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_kidspawner_timeout():
	var kid = KID.instance()
	var perimeter_pos = randi() % (2 * (CANVASWIDTH + CANVASHEIGHT))
	if perimeter_pos < 2 * CANVASWIDTH:
		# top or bottom spawn
		kid.global_position.x = perimeter_pos % CANVASWIDTH
		if perimeter_pos < CANVASWIDTH:
			# top
			kid.global_position.y = 0
		else:
			# botom
			kid.global_position.y = CANVASHEIGHT
	else:
		# left or right spawn
		perimeter_pos -= 2 * CANVASHEIGHT
		if perimeter_pos < 2 * CANVASHEIGHT:
			kid.global_position.y = perimeter_pos % CANVASHEIGHT
			if perimeter_pos < CANVASHEIGHT:
				# left
				kid.global_position.x = 0
			else:
				# right
				kid.global_position.x = CANVASWIDTH
	kid.state = "candy"
	self.add_child(kid)


