extends Node


enum Platform {
	DESKTOP,
	MOBILE,
	WEB,
	UNKNOWN,
}


func get_current_platform() -> Platform:
	match OS.get_name():
		"Windows", "macOS", "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
			return Platform.DESKTOP
		"Android", "iOS":
			return Platform.MOBILE
		"Web":
			return Platform.WEB
		_:
			return Platform.UNKNOWN


func is_desktop() -> bool:
	return get_current_platform() == Platform.DESKTOP


func is_mobile() -> bool:
	return get_current_platform() == Platform.MOBILE


func is_web() -> bool:
	return get_current_platform() == Platform.WEB
