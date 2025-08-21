# TODO: Move functions from weighted table into item spawner

class_name ItemSpawner

var items: Array[Dictionary] = []
var weight_sum = 0


func add_item(item, weight: int):
    items.append({"item": item, "weight": weight})
    weight_sum += weight


func remove_item(item_to_remove):
    items = items.filter(func (item): return item["item"] != item_to_remove)
    weight_sum = 0

    for item in items:
        weight_sum += item["weight"]

