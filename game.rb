# The game!

class GameBoard
  # Attributes.
  # board keeps an array of the current state of the board.
  # win_state stores the winner of the game.
  # turn is a counter for how many turns have been taken.
  # Interesting fact: Nowhere does the board become picky about what symbols are used with it. You can play Ys and Ps, Bs and Gs, or P, B & Js. :D 
  attr_reader :board, :winner, :turn  
  
  
  def initialize(board = [])
    @board = board #If you don't do this, the passed-in array doesn't become a class attribute. :(
    #Because we'll soon need to address the array by position, I want to make sure it either has a complete board, or re-initialize it with 9 nil objects. 
    if @board.nil? || @board.length != 9 
      @board = Array.new(9)
    end
    #And because we allow a game board to be passed in, we want to check for a winner immediately.
    checkWinner
  end
  def checkWinner
    # A simple iterator/index with If/else statements. This is not much shorter than an explicit test for all 6 row/columns. 
    #Columns and rows
    (0..2).each do |index|
      #columns
      if @board[index] == @board[index+3] && @board[index] == @board[index + 6]
        #All that matters is we identify the symbol we're testing for concurrence in a row or column.  
        @board[index].nil? ? nil : @winner = @board[index]
      end
      #rows
      if @board[3 * index] == @board[(3 * index) + 1] && @board[3 * index] == @board[(3 * index) + 2]
        @board[3 * index].nil? ? nil : @winner = @board[3 * index]
      end
    end
    #Diagonals. These are explicit. There are only two diagonals on a 3x3 board. If the board size wasn't fixed, this would be an iterator as well.
    if @board[0] == @board[4] && @board[0] == @board[8]
      @board[0].nil? ? nil : @winner = @board[0]
    elsif @board[6] == @board[4] && @board[6] == @board[2]
      @board[6].nil? ? nil : @winner = @board[6]
    end
  end
  
  def mark(symbol, address)
    #Symbol is provided by the player. Presumably an X or O.
    #address is currently restricted to a single digit identifying a place on the array.
    if @board[address].nil?
      @board[address] = symbol
      checkWinner
    else
      raise ArgumentError, "Location is already marked."
    end
  end
end