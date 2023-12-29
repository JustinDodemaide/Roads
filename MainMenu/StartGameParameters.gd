extends Node
# When the player chooses a save slot (or makes a new one) in the main menu,
# the MainMenu switches scenes to the PackedScene of the World, meaning
# information can't be passed in traditionally. This singleton just contains
# information for the World scene, and is deallocated immediately after.

var save:int = 0
var num_saves:int
