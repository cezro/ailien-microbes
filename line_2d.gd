extends Line2D

@onready var player_pos = $"../Player"
@onready var enemy_pos = $"../EnemyStatic"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_point(Vector2())
	add_point(enemy_pos.global_position - player_pos.global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_position()


func update_position() -> void:
	global_position = player_pos.global_position
	set_point_position(1, enemy_pos.global_position - player_pos.global_position)
