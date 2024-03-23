extends GdUnitPatch

func _init():
	super(GdUnit4Version.parse("v0.9.6"))

func execute() -> bool:
	var patches := Array()
	if Engine.has_meta(PATCH_VERSION):
		patches = Engine.get_meta(PATCH_VERSION)
	patches.append(version())
	Engine.set_meta(PATCH_VERSION, patches)
	return true
