class_name GameState
extends Node

var time_passed: float = 0

var as_dict: get = _get_as_dict

func _ready() -> void:
	time_passed = 0

func _process(delta: float) -> void:
	time_passed += delta

func _get_as_dict() -> Dictionary:
	return { 'time_passed': time_passed }
