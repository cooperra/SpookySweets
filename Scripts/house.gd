extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var souls_count = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Door_body_entered(body):
	# Triggers when kids enter the door
	$AnimationPlayer.play("ConsumptionGlow")
	$FoomSound.play()
	body.enter_house(self)
	souls_count += 1
	$Souls.text = "Souls " + str(souls_count)
	$Souls.visible = true


func _on_Funnel_body_entered(body):
	body.active_funnel_target = $Funnel/Target


func _on_Funnel_body_exited(body):
	if body.active_funnel_target == $Funnel/Target:
		body.active_funnel_target = null
