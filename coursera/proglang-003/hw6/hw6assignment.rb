# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  All_My_Pieces = [
    [[[0, 0], [1, 0], [0, 1], [1, 1]]],  # square (only needs one)
    rotations([[0, 0], [-1, 0], [1, 0], [0, -1]]), # T
    [[[0, 0], [-1, 0], [1, 0], [2, 0]], # long (only needs two)
     [[0, 0], [0, -1], [0, 1], [0, 2]]],
    rotations([[0, 0], [0, -1], [0, 1], [1, 1]]), # L
    rotations([[0, 0], [0, -1], [0, 1], [-1, 1]]), # inverted L
    rotations([[0, 0], [-1, 0], [0, -1], [1, -1]]), # S
    rotations([[0, 0], [1, 0], [0, -1], [-1, -1]]), # Z
    # new 3 pieces
    [[[-2, 0], [-1, 0], [0, 0], [1, 0], [2, 0]], # long with length five block (only needs two)
     [[0, -2], [0, -1], [0, 0], [0, 1], [0, 2]]],
    rotations([[-1, -1], [0, -1], [-1, 0], [0, 0], [1, 0]]), # 2.a piece
    rotations([[0, -1], [0, 0], [1, 0]])
  ]
  # your enhancements here
  def self.next_piece (board)
    MyPiece.new(All_My_Pieces.sample, board)
  end
  
  def self.cheat_piece (board)
    MyPiece.new([[[0, 0]]], board)
  end
end

class MyBoard < Board
  # your enhancements here
  def initialize (game)
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    @current_block = MyPiece.next_piece(self)
    @score = 0
    @game = game
    @delay = 500

    # the flag to show the cheat button clicked
    @cheat_enabled = false
  end

  def cheat
    if !@cheat_enabled and @score >= 100
      @cheat_enabled = true
    end
  end

  # gets the next piece
  def next_piece
    if @cheat_enabled
      @cheat_enabled = false
      @score -= 100
      @current_block = MyPiece.cheat_piece(self)
    else
      @current_block = MyPiece.next_piece(self)
    end
    @current_pos = nil
  end

  # gets the information from the current piece about where it is and uses this
  # to store the piece on the board itself.  Then calls remove_filled.
  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position

    # compute block length because there are three different size (3, 4, 5)
    (0..(locations.size-1)).each{|index|
      current = locations[index]
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] = @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end
end

class MyTetris < Tetris
  # your enhancements here
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def key_bindings
    super
    # make the piece that is falling rotate 180 degrees
    @root.bind('u' , proc { 2.times { @board.rotate_clockwise } })

    # cheat
    @root.bind('c' , proc { @board.cheat })
  end
end


