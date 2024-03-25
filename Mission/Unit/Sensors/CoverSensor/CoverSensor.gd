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
