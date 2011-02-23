# Collection of text for the game.
def welcomeScreen(time)
  screen = %{
              __                       _     _
             / _\\ ___ _ __ _ __  _   _| | __| |__   _____   __
             \\ \\ / _ \\ '__| '_ \\| | | | |/ /| '_ \\ / _ \\ \\ / /
             _\\ \\  __/ |  | |_) | |_| |   < | | | | (_) \\ \V /
             \\__/\\___|_|  | .__/ \\__,_|_|\\_\\|_| |_|\\___/ \\_/
                          |_|
.,.-'`'-.,,.-'`'-.,,.-'`'-.,,.-'`'-=1 5=-'`'-.,,.-'`'-.,,.-'`'-.,,.-'`'-.,,.-'`'

BMEWS MOTD %s
Welcome, comrade to your post on the front lines of the Soviet vigil against the
treachery of the west. If you are not yet familiar with your equipment, ask
Sgt. Dmitriev or Cpl. Zaitsev for manual 1184.b.}
  printf(screen, time)
  
end
def ticTacToeRules
  screen = %{
+-----------------------------------------------------------------------------+
| Welcome to the Noughts and Crosses strategy coach!     __Tactics  Legend__  |
| Using this program you can hone your mind and master   B: Block opponent    |
| logical thinking and prediction. This is a sample      C: Play random corner|
| screen, press 'Enter' to start playing.                D: Force opponent    |
| Parts of the screen are (explained)                    E: Play center       |
|  v(The Game Count)                                     F: Set up a fork     |
|  Game 1    v(player name and move history.)            O: Play opposite crnr|
|  Player X: EDVAC  ; Moves: B2-E,C3-F,B1-B,A3-T,        R: Play randomly     |
|  Player O: Nikolay; Moves: A1,C1,B3,                   S: Play random side  |
|                                                        T: Stop a fork       |
|     A  B  C <(coordinate references)                                        |
|  1 [O][X][O]                                                                |
|  2 [ ][X][ ] (The Game Board)                                               |
|  3 [X][O][X]                                                                |
|                                                                             |
|  What is the coordinate of your next move? <(Prompt for input)              |
|                                                                             |
| Players alternate X and O, placing their mark on the board. The first with  |
| three in a row is the winner. If the board fills with no winner, it is      |
| a draw. Good luck!                                                          |
+-----------------------------------------------------------------------------+
  }
  printf(screen)
end