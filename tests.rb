# UNIT TESTS TRANSFORM AND ROLL OUT
require 'test/unit'
require 'nac'

class TestNoughtsAndCrosses < Test::Unit::TestCase
  def test_checkWinner_winner1
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

  def test_checkWinner_winner2
    player1, player2 = Player.new("Scott"), Player.new("Casey")
    game = NoughtsAndCrosses.new(player1, player2)
    # Play a game in which player 1 wins.
    player1.play(game, "A1")
    player2.play(game, "A2")
    player1.play(game, "B2")
    player2.play(game, "A3")
    player1.play(game, "C3")
    player2.play(game, "C2")
    assert_equal(player1, game.checkWinner)
  end

  def test_checkWinner_no_winner
    player1, player2 = Player.new("Scott"), Player.new("Casey")
    game = NoughtsAndCrosses.new(player1, player2)
    # Play a game in neither player wins.
    player1.play(game, "A1")
    player2.play(game, "A2")
    player1.play(game, "A3")
    player2.play(game, "B2")
    player1.play(game, "B1")
    player2.play(game, "B3")
    player1.play(game, "C2")
    player2.play(game, "C1")
    player1.play(game, "C3")
    assert_equal(nil, game.checkWinner)
  end

  def test_checkWinner_few_moves
    player1, player2 = Player.new("Scott"), Player.new("Casey")
    game = NoughtsAndCrosses.new(player1, player2)
    # Play a game in which neither player has finished.
    player1.play(game, "A1")
    player2.play(game, "A2")
    assert_equal(nil, game.checkWinner)
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