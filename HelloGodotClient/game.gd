extends Node2D

func _ready() -> void:
	$ServerConnection.open()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_game_state_sync_timer_timeout() -> void:
	$ServerConnection.send_game_state($GameState)

func _on_tree_exiting() -> void:
	$ServerConnection.close()
