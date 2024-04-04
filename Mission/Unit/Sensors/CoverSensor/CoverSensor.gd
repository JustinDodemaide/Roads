extends Node2D

var north:bool
var east:bool
var south:bool
var west:bool

func update():
	north = $CoverN.is_colliding() or $CoverNE.is_colliding() or $CoverNW.is_colliding()
	east = $CoverE.is_colliding() or $CoverNE.is_colliding() or $CoverSE.is_colliding()
	south = $CoverS.is_colliding() or $CoverSE.is_colliding() or $CoverSW.is_colliding()
	west = $CoverW.is_colliding() or $CoverSW.is_colliding() or $CoverNW.is_colliding()

func has_cover_in_direction(direction:Global.CARDINAL) -> bool:
	if direction == Global.CARDINAL.NORTH and north:
		return true
	if direction == Global.CARDINAL.NORTHEAST and (north and east):
		return true
	if direction == Global.CARDINAL.EAST and east:
		return true
	if direction == Global.CARDINAL.SOUTHEAST and (south and east):
		return true
	if direction == Global.CARDINAL.SOUTH and south:
		return true
	if direction == Global.CARDINAL.SOUTHWEST and (south and west):
		return true
	if direction == Global.CARDINAL.WEST and west:
		return true
	if direction == Global.CARDINAL.NORTHWEST and (north and west):
		return true
	return false
