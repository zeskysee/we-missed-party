extends Node2D
# Introduction cutscene controller. Most of the interactions are done through
# signals in the introduction.tscn scene. This is just extra setup code.


# Reference to the party house node.
var party_house

# AnimationPlayer for the PlayerSprite.
onready var player_player = $PlayerInteraction/PlayerPlayer


func _ready():
	var player_speech2 = $PlayerInteraction/Speech2
	var player_speech3 = $PlayerInteraction/Speech3
	if is_instance_valid(party_house):
		# If party house exists, use its camera after player_speech2.
		player_speech2.connect("tree_exited", party_house, "view_outside")
		party_house.connect("house_transformed", player_speech3, "play")
	else:
		# Otherwise, go to player_speech3 directly.
		player_speech2.connect("tree_exited", player_speech3, "play")


# Play the shocked animation for the PlayerSprite.
func shock():
	player_player.play("shocked")
