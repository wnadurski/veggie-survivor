extends Object
class_name Utility


static func _find_ceil(arr: Array, roll: int) -> int:
	for i in range(0, arr.size()):
		if roll <= arr[i]:
			return i
	return -1

static func weighted_rand(array: Array, weights: Array):
	var prefixes = [weights[0]]
	for i in range(1, weights.size()):
		prefixes.push_back(prefixes[i-1] + weights[i])
		
	var roll = (randi() % prefixes[prefixes.size()-1]) + 1
	
	var index = _find_ceil(prefixes, roll)
	
	return array[index]
	
