extends Node


# The total number of NPCs collected in the neighborhood.
var total_number_of_npc = 0
# If true, party_house.tscn will play the ending instead of the intro.
var is_ending = false


# Returns the appropriate ending text based on total number of NPCs.
func get_ending_text():
	var text: String
	match total_number_of_npc:
		0:
			text = "Lone"
		1:
			text = "Couple"
		2:
			text = "Three-Way"
		_:
			text = "Wholesome"
	return "%s\nParty" % text
