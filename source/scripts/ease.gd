extends Node


func InSine(x: float):
	return 1 - cos((x * PI) / 2)


func OutSine(x: float):
	return sin((x * PI) / 2)


func OutBounce(x: float):
	const n1 = 7.5625
	const d1 = 2.75

	if (x < 1 / d1):
		return n1 * x * x
	elif (x < 2 / d1):
		x -= 1.5 / d1
		return n1 * x * x + 0.75
	elif (x < 2.5 / d1):
		x -= 2.25 / d1
		return n1 * x * x + 0.9375
	else:
		x -= 2.625 / d1
		return n1 * x * x + 0.984375
