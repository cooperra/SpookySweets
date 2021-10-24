extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var state = "default"
export(Vector2) var waypoint = null
var active_spooker : Node2D = null
var active_funnel_target : Node2D = null
const SPEED = 20
const SPOOKSPEED = 60
const SPOOKDISTANCE = 100

# TODO don't hardcode
const CANVASWIDTH = 384
const CANVASHEIGHT = 225

const CANDY = preload("res://Scenes/candy_bag.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if not waypoint:
		randomize_waypoint()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if active_spooker:
		# become spooked if still in the spook zone
		# update current waypoint, even if already spooked
		# but first, candy dropping
		if state == "candy":
			var candy = CANDY.instance()
			candy.position = position
			get_parent().add_child(candy)
		state = "spooked"
		var waypoint_direction = active_spooker.global_position.direction_to(global_position)
		waypoint = global_position + (waypoint_direction * SPOOKDISTANCE)
		# Screem if needed
		if not $Scream.playing:
			$Scream.play()
	if state == "default":
		# TODO change waypoint on bump
		move_to_waypoint(delta, SPEED)
		if global_position.distance_squared_to(waypoint) <= 36:
			# We reached the waypoint
			randomize_waypoint()
	if state == "candy":
		# TODO change waypoint on bump
		move_to_waypoint(delta, SPEED)
		if global_position.distance_squared_to(waypoint) <= 36:
			# We reached the waypoint
			randomize_waypoint()
	elif state == "spooked":
		# Funnel overrides waypoint when spooked
		if active_funnel_target:
			waypoint = active_funnel_target.global_position
		# Move to waypoint
		# TODO spook kids we bump into!
		move_to_waypoint(delta, SPOOKSPEED)
		if global_position.distance_squared_to(waypoint) <= 36:
			# We reached the waypoint and don't need to be spooked anymore
			state = "default"
			randomize_waypoint()
	# sprite update time
	var sprite_frames = {
		"default": 0,
		"candy": 1,
		"spooked": 2,
	}
	$AnimatedSprite.frame = sprite_frames[state]


func move_to_waypoint(delta, speed):
	var move_direction = global_position.direction_to(waypoint)
	var move_velocity = move_direction * speed
	$AnimatedSprite.flip_h = move_velocity.x < 0
	# can overshoot, but that's OK
	return move_and_collide(move_velocity * delta)

func randomize_waypoint():
	waypoint = Vector2(rand_range(0, CANVASWIDTH), rand_range(0, CANVASHEIGHT))

func enter_house(house):
	# TODO do more stuff
	queue_free()
