class_name util

static func hllerp(current, target, halfLife: float, delta: float):
	if halfLife <= 0: return target;
	var t = 1 - pow(2, -delta / halfLife);
	return current + (target - current) * t;
