extends Node
class_name Main

# This mostly exists as a root for scene switches and to play synced music independent of scenes

enum Sound {
	CONFIRM
}

@onready var musicAudio : AudioStreamPlayer = $MusicAudio
@onready var current_music_dict : Array = main_music_dict.keys()
@onready var sounds = {
	'Confirm': $Sounds/ConfirmSound,
}

var special_music_dict : Dictionary = {
	# put special music like a winning theme in here
}
var main_music_dict : Dictionary = {
	# put general music in here
	# 'My Song' : 'res://assets/audio/music/my_song.ogg'
	'Main_Theme': 'res://assets/audio/song_main.wav'
}

var current_song := ""
var sync := false


func _ready() -> void:
	GameManager.main = self
	_start_synced_music()

func _start_synced_music() -> void:
	if !multiplayer.is_server():
		return
	_play_track.rpc(_get_random_track())

func _get_random_track() -> String:
	if current_music_dict.size() == 0:
		current_music_dict = main_music_dict.keys()
	return current_music_dict.pop_at(randi() % current_music_dict.size())

func _play_sound(title):
	print("Play sound", title)
	print(sounds)
	if sounds.has(title):
		sounds[title].play()

@rpc("call_local")
func _play_track(track : String) -> void:
	if !main_music_dict.get(track):
		print(track + ' is not a key in the music dict!')
		return
	musicAudio.stream = load(main_music_dict[track])
	current_song = track
	musicAudio.play()
	if multiplayer.is_server():
		musicAudio.finished.connect(_start_synced_music)

@rpc("call_local")
func _play_special(track : String) -> void:
	if !special_music_dict.get(track):
		print(track + ' is not a key in the music dict!')
		return
	musicAudio.stream = load(special_music_dict[track])
	musicAudio.play()
