#!/bin/env python

def check_done():
	for i in range(3):
		if map[i][0] == map[i][1] == map[i][2] != " " \
		or map[0][i] == map[1][i] == map[2][i] != " ":
			print a, "win!"
			return True
	if map[0][0] == map[1][1] == map[2][2] != " " \
	or map[0][2] == map[1][1] == map[2][0] != " ":
		print a, "win!"
		return True

	if " " not in map[0] and " " not in map[1] and " " not in map[2]:
		print "Draw!"
		return True

	return False

def step(pos):
	if not 1 <= pos <= 9:
		return False
	pos -= 1
	row = pos / 3
	col = pos % 3
	if map[row][col] != " ":
		return False
	map[row][col] = a
	return True
	
def print_board():
	for i in range(3):
		print "|".join(map[i])

map = [
	[" ", " ", " "],
	[" ", " ", " "],
	[" ", " ", " "],
]

a = "O"

print_board()
while not check_done():
	if a == "O":
		a = "X"
	else:
		a = "O"
	pos = int(raw_input(a + " input pos[1-9]: "))
	while not step(pos):
		print "input error"
		pos = int(raw_input(a + " input pos[1-9]: "))
	print_board()
	