extends Node2D

onready var pieces = [
	$Piece1, $Piece2, $Piece3,
	$Piece4, $Piece5, $Piece6,
	$Piece7, $Piece8, $Piece9
]

var pieceWidth = 100
var rng = RandomNumberGenerator.new()
var canMove = true

func _ready() -> void:
	rng.randomize()
	setPiecesFrame()
	randomizeArray()
	drawPieces()

func _unhandled_key_input(event: InputEventKey) -> void:
	var p9index = pieces.find($Piece9)

	if canMove:
		if event.pressed:
			if event.scancode == KEY_DOWN:
				if p9index >= 3:
					swapPieces(p9index, p9index - 3)
			if event.scancode == KEY_LEFT:
				if p9index % 3 != 2:
					swapPieces(p9index, p9index + 1)
			if event.scancode == KEY_UP:
				if p9index < 6:
					swapPieces(p9index, p9index + 3)
			if event.scancode == KEY_RIGHT:
				if p9index % 3 != 0:
					swapPieces(p9index, p9index - 1)

func setPiecesFrame() -> void:
	$Piece9.modulate.a = 0

	for i in range(0, pieces.size()):
		pieces[i].get_node("Sprite").frame = i

func randomizeArray() -> void:
	for _x in range(10000):
		var p9index = pieces.find($Piece9)
		var possibilities = getPossibilities(p9index)
		var selectedPossibility = possibilities[rng.randi() % possibilities.size()]

		if selectedPossibility == 'up':
			swapValuesArray(p9index, p9index - 3)
		elif selectedPossibility == 'right':
			swapValuesArray(p9index, p9index + 1)
		elif selectedPossibility == 'down':
			swapValuesArray(p9index, p9index + 3)
		elif selectedPossibility == 'left':
			swapValuesArray(p9index, p9index - 1)

func drawPieces() -> void:
	for i in range(0, pieces.size()):
		pieces[i].position.x += pieceWidth * (i % 3)
		pieces[i].position.y += pieceWidth * int(i / 3.0)

func getPossibilities(index) -> Array:
	if index == 0:
		return ['right', 'down']
	if index == 1:
		return ['right', 'down', 'left']
	if index == 2:
		return ['down', 'left']
	if index == 3:
		return ['up', 'right', 'down']
	if index == 4:
		return ['up', 'right', 'down', 'left']
	if index == 5:
		return ['up', 'down', 'left']
	if index == 6:
		return ['up', 'right']
	if index == 7:
		return ['up', 'right', 'left']
	if index == 8:
		return ['up', 'left']

	return []

func swapValuesArray(index1, index2) -> void:
	var temp = pieces[index1]
	pieces[index1] = pieces[index2]
	pieces[index2] = temp

func swapPieces(index1, index2) -> void:
	canMove = false
	var p1 = pieces[index1].position
	var p2 = pieces[index2].position
	var duration = 0.05

	var tween = create_tween()
	tween.tween_property(pieces[index2], 'global_position', p1, duration)
	tween.parallel().tween_property(pieces[index1], 'global_position', p2, duration)
	tween.tween_callback(self, 'allowMovement')
	tween.tween_callback(self, 'checkWin')

	swapValuesArray(index1, index2)

func allowMovement():
	canMove = true

func checkWin():
	var checkArray = [
		$Piece1, $Piece2, $Piece3,
		$Piece4, $Piece5, $Piece6,
		$Piece7, $Piece8, $Piece9
	]

	if checkArray == pieces:
		canMove = false

		var tween = create_tween()
		tween.tween_property($Piece9, 'modulate:a', 1.0, 0.2)
