# The game!

class GameBoard
  def initialize(board)
    @board = board 
    @board.nil? board = Array.new(9)
    @win_state = nil
    checkWinner
    @turn = 0
  end
  
  def winner
    @win_state
  end
  
  def checkWinner
    #Columns and rows
    (0..2).each do |index|
      if @board[index] == @board[index+3] && @board[index + 6]
        @win_state = @board[0]
      elsif @board[3 * index] == @board[(3 * index) + 1] && @board[(3 * index) + 2]
        @win_state = @board[3 * index]
      end
    end
    #Diagonals
    if @board[0] == @board[4] && @board[8]
      @win_state = @board[0]
    elsif @board[6] == @board[4] && @board[2]
      @win_state = @board[6]
    end
  end
end