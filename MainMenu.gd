extends Node2D

func _ready():
	if "--server" in OS.get_cmdline_args():
		Server.init_server()
		get_tree().change_scene("res://World.tscn")

func _on_StartServerButton_pressed():
	Server.init_server()
	get_tree().change_scene("res://World.tscn")

func _on_StartClientButton_pressed():
	Server.init_client()
	get_tree().change_scene("res://World.tscn")
	
func _on_TextEdit_text_changed():
	Server.ip = $TextEdit.text
