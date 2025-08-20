# TODO: Move functions from weighted table into item spawner

class_name ItemSpawner

var items: Array[Dictionary] = []
var weight_sum = 0


func add_item(item, weight: int):
    items.append({"item": item, "weight": weight})
    weight_sum += weight