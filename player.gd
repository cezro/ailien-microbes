extends CharacterBody2D

const SPEED = 300.0
const WARP_DISTANCE = 150.0
const WARP_DURATION := 0.5
var last_direction = Vector2.ZERO
var enemies = []
var is_warping := false

@onready var player = $"." 
@onready var sprite := $playerSprite2D

func _ready():
	enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() > 0:
		for enemy in enemies:
			print(enemy.name, " Initial Position: ", enemy.global_position)
	else:
		print("No enemies found!")

func _physics_process(delta: float) -> void:
	if is_warping:
		return
	
	var direction := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)
	
	if direction.length() > 0:
		last_direction = direction.normalized()

	if Input.is_action_just_pressed("ui_accept"):
		warp_to_enemy_behind()

	velocity = direction * SPEED
	move_and_slide()

func warp_to_enemy_behind():
	if is_warping or enemies.is_empty():
		return
	
	var enemy = enemies[0]
	if not enemy or not is_instance_valid(enemy):
		return
	
	var target_pos = enemy.global_position + (enemy.global_position - global_position).normalized() * WARP_DISTANCE
	
	is_warping = true
	var tween = create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	
	tween.tween_property(sprite, "modulate:a", 0.0, WARP_DURATION/2)
	tween.tween_property(sprite, "scale", Vector2(0.1, 0.1), WARP_DURATION/2)
	
	tween.tween_property(self, "global_position", target_pos, WARP_DURATION)
	
	await tween.finished
	tween = create_tween().set_parallel(true)
	tween.tween_property(sprite, "modulate:a", 1.0, WARP_DURATION/2)
	tween.tween_property(sprite, "scale", Vector2(0.3, 0.3), WARP_DURATION/2)
	
	await tween.finished
	is_warping = false
	print("Warped to:", global_position)
