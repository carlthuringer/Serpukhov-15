# @TODO merge with other test file when you get home.
require 'nac'
require 'test/unit'

class TestTicTacToeStrategy < Test::Unit::TestCase
  def test_alphaBeta
    #
  end

  def test_evaluate_node_winLose
    # Test node evaluation. A winning board should return +infinity, a losing -infinity
    infinity = (1.0/0.0)
    strategy = TicTacToeStrategy.new
    p1 = Player.new("Scott")
    p2 = Player.new("Casey")
    game = NoughtsAndCrosses.new(p1, p2)
    # A game in which p2 wins.
    p1.play(game, "A1")
    p2.play(game, "B2")
    p1.play(game, "A2")
    p2.play(game, "A3")
    p1.play(game, "B1")
    p2.play(game, "C1")

    assert_equal(infinity, strategy.evaluate_node(game, p2))
    assert_equal(-infinity, strategy.evaluate_node(game, p1))

  end

  def test_evaluate_node_tie
    # Test node evaluation. If the game has ended in a tie, the heuristic value is 0.
    strategy = TicTacToeStrategy.new
    p1 = Player.new("Scott")
    p2 = Player.new("Casey")
    game = NoughtsAndCrosses.new(p1, p2)
    # A game in which nobody wins.
    p1.play(game, "A1")
    p2.play(game, "B2")
    p1.play(game, "B1")
    p2.play(game, "C1")
    p1.play(game, "A3")
    p2.play(game, "A2")
    p1.play(game, "C2")
    p2.play(game, "B3")
    p1.play(game, "C3")
    assert_equal(0, strategy.evaluate_node(game, p1))
  end

  def test_evaluate_node_scoring
    # Test the scoring of nodes. +1 for a state where there is one possible win, +2 for a fork negative for opponent's chances.
    strategy = TicTacToeStrategy.new
    p1 = Player.new("Scott")
    p2 = Player.new("Casey")
    game = NoughtsAndCrosses.new(p1, p2)
    # A game in which Player 1 has a chance to win.
    p1.play(game, "B2")
    p2.play(game, "C2")
    p1.play(game, "A3")
    assert_equal(1, strategy.evaluate_node(game, p1))
    assert_equal(-1, strategy.evaluate_node(game, p2))
    
  end

end

class TestNoughtsAndCrosses < Test::Unit::TestCase
  def test_checkWinner_winner
    # Pretty much have to set up and play a whole game. Then see that it reports the right person.
    p1 = Player.new("Scott")
    p2 = Player.new("Casey")
    game = NoughtsAndCrosses.new(p1, p2)
    p1.play(game, "A1")
    p2.play(game, "B2")
    p1.play(game, "A2")
    p2.play(game, "A3")
    p1.play(game, "B1")
    p2.play(game, "C1")
    assert_equal(p1, game.checkWinner) # Game turn will be off by one. So if this works the other player is returned.
  end

  def test_checkWinner_tie
    # Pretty much have to set up and play a whole game. Then see that it reports the right person.
    p1 = Player.new("Scott")
    p2 = Player.new("Casey")
    game = NoughtsAndCrosses.new(p1, p2)
    p1.play(game, "A1")
    p2.play(game, "A3")
    p1.play(game, "A2")
    p2.play(game, "B1")
    p1.play(game, "B3")
    p2.play(game, "B2")
    p1.play(game, "C1")
    p2.play(game, "C3")
    p1.play(game, "C2")
    assert_equal(nil, game.checkWinner) # Game turn will be off by one. So if this works the other player is returned.
  end
end