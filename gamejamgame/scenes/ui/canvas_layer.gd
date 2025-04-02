extends CanvasLayer

signal addtime(seconds)

func _on_tileset_test_addtime(seconds: Variant) -> void:
	$Panel.add_time(seconds)
