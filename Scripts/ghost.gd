extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var SPEED = 40
export(Vector2) var waypoint = null


# TODO don't hardcode
const CANVASWIDTH = 384
const CANVASHEIGHT = 225


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		waypoint = get_global_mouse_position()
	if Input.is_action_pressed("ui_down"):
		global_translate(Vector2(0, SPEED * delta))
		waypoint = null
	if Input.is_action_pressed("ui_up"):
		global_translate(Vector2(0, -SPEED * delta))
		waypoint = null
	if Input.is_action_pressed("ui_right"):
		global_translate(Vector2(SPEED * delta, 0))
		waypoint = null
	if Input.is_action_pressed("ui_left"):
		global_translate(Vector2(-SPEED * delta, 0))
		waypoint = null
	if waypoint:
		move_to_waypoint(delta, SPEED)
		if global_position.distance_squared_to(waypoint) <= 36:
			# We reached the waypoint
			waypoint = null
	# warp to fit in screen
	if global_position.x < 0:
		global_position.x += CANVASWIDTH
	if global_position.x > CANVASWIDTH:
		global_position.x -= CANVASWIDTH
	if global_position.y < 0:
		global_position.y += CANVASHEIGHT
	if global_position.y > CANVASHEIGHT:
		global_position.y -= CANVASHEIGHT


func _on_SpookZone_body_entered(body):
	# Triggers when kids enter the spook zone
	body.active_spooker = self
	$BooSound.play()
	#SPEED = 80


func _on_SpookZone_body_exited(body):
	# Triggers when kids leave the spook zone
	if body.active_spooker == self:
		# Unset if they are currently spooked by us
		body.active_spooker = null
		#SPEED = 30


func move_to_waypoint(delta, speed):
	var move_direction = global_position.direction_to(waypoint)
	var move_velocity = move_direction * speed
	#$AnimatedSprite.flip_h = move_velocity.x < 0
	# can overshoot, but that's OK
	return global_translate(move_velocity * delta)
