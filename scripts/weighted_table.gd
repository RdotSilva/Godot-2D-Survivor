class_name WeightedTable

var items: Array[Dictionary] = []


func add_item(item, weight: int):
    items.append({"item": item, "weight": weight})