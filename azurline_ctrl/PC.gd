extends Node
func _init():
	pass

func getPlayerName():
	return Steam.getPersonaName().to_ascii().get_string_from_utf8()

func getPlayerId():
	return Steam.getSteamID()