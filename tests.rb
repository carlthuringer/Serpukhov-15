# UNIT TESTS TRANSFORM AND ROLL OUT
require 'test/unit'
require 'nac'

class TestCheckWinner < Test::Unit::TestCase
  def test_winner
    player1, player2 = Player.new("Scott"), Player.new("Casey")
    game = NoughtsAndCrosses.new(player1, player2)
    # Play a game in which player 1 wins.
    player1.play(game, "A1")
    player2.play(game, "A2")
    player1.play(game, "B2")
    player2.play(game, "A3")
    player1.play(game, "C3")
    assert_equal(player1, game.checkWinner)
  end
end

class TestGameBoard < Test::Unit::TestCase
  def test_boardSlicer
    board = [
      "X", "O", "O",
      "O", "X", "O",
      "O", "X", "O"]
    sliced = [
      ["X", "O", "O"],
      ["O", "X", "O"],
      ["O", "X", "O"],
      ["X", "O", "O"],
      ["O", "X", "X"],
      ["O", "O", "O"],
      ["X", "X", "O"],
      ["O", "X", "O"]
    ]

    board = GameBoard.new(board)
    assert_equal(sliced, board.boardSlicer)
  end
end