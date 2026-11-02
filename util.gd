class_name util

static func hllerp(current, target, halfLife: float, dt: float):
	if halfLife <= 0: return target;
	var t = 1 - pow(2, -dt / halfLife);
	return current + (target - current) * t;
