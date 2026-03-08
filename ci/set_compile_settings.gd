@tool
extends Node

func _ready() -> void:
	print("Set editor settings required for build!")
	var settings = EditorInterface.get_editor_settings()
	# Can't be "JAVA_HOME" because Godot overwrites this!
	var java_sdk_path = OS.get_environment("GODOT_JAVA_HOME")
	print("Setting JAVA_HOME for the Java SDK path: ", java_sdk_path)
	settings.set_setting("export/android/java_sdk_path", java_sdk_path)
	print("Changed setting")
	get_tree().quit()
