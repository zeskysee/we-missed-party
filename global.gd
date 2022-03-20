extends Node


# The total number of NPCs collected in the neighborhood.
var total_number_of_npc = 0
# If true, party_house.tscn will play the ending instead of the intro.
var is_ending = false


# Returns the appropriate ending text based on total number of NPCs.
func get_ending_text():
	var text: String
	
	if total_number_of_npc >= 19:
		return "Super-Duper\nWholesome Party"			
	elif total_number_of_npc >= 9:
		return "Crazy Wholesome\nParty"
	
	match total_number_of_npc:
		0:
			text = "Love Yourself"
		1:
			text = "Couple"
		2:
			text = "Three-Musketeers"
		3:
			text = "Fantastic Four"
		4:
			text = "Guardian of Galaxy\nParty"
		5:
			text = "Justice League\nParty"
		_:
			text = "Wholesome"
				
				
	return "%s\nParty" % text
