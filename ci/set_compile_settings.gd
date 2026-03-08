@tool
extends Node

func _ready() -> void:
	print("Set editor settings required for build!")
	var settings = EditorInterface.get_editor_settings()
	var java_sdk_path = OS.get_environment("JAVA_HOME")
	settings.set_setting("export/android/java_sdk_path", java_sdk_path)
