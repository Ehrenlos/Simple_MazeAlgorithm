extends Node2D

var creating = false

const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {Vector2(1, 0): E, Vector2(-1, 0): W,
                  Vector2(0, 1): S, Vector2(0, -1): N}
var tile_size = 16
var width = 25 
var height = 20 
var starting_cell = Vector2(0, 0)
var show_process = true
onready var Map = $TileMap


func _ready():
	randomize()
	tile_size = Map.cell_size
	make_maze()

func _input(event):
	if event.is_action_pressed("ui_select") && !creating:
		make_maze()


func make_maze():
	$TileMap.position.x = tile_size.x * height / 2
	creating = true
	var unvisited = [] 
	var stack = []
	Map.clear()
	for x in range(width):
		for y in range(height):
			unvisited.append(Vector2(x, y))
			Map.set_cellv(Vector2(x, y), N|E|S|W)
	var current = starting_cell
	unvisited.erase(current)
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			var dir = next - current
			var current_walls = Map.get_cellv(current) - cell_walls[dir]
			var next_walls = Map.get_cellv(next) - cell_walls[-dir]
			Map.set_cellv(current, current_walls)
			Map.set_cellv(next, next_walls)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
		if show_process:
			yield(get_tree(), 'idle_frame')
	creating = false

func check_neighbors(cell, unvisited):
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list
