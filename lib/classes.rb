class Board 
  attr_accessor :board

  COLUMNS = [[0,4,8,12], [1,5,9,13], [2,6,10,14], [3,7,11,15]].freeze

  def initialize
    @board = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
  end

  def update_board(column, token)
    return board[COLUMNS[column][3]] = token if board[COLUMNS[column][3]] == ' '
    return board[COLUMNS[column][2]] = token if board[COLUMNS[column][2]] == ' '
    return board[COLUMNS[column][1]] = token if board[COLUMNS[column][1]] == ' '
    return board[COLUMNS[column][0]] = token if board[COLUMNS[column][0]] == ' '
    return 'Invalid! Choose Another Spot!'
  end

  def showboard
    puts " #{board[0]} | #{board[1]} | #{board[2]} | #{board[3]} "
    puts '_______________'
    puts " #{board[4]} | #{board[5]} | #{board[6]} | #{board[7]} "
    puts '_______________'
    puts " #{board[8]} | #{board[9]} | #{board[10]} | #{board[11]} "
    puts '_______________'
    puts " #{board[12]} | #{board[13]} | #{board[14]} | #{board[15]} "
    puts ' '
  end

end

class Game
  attr_accessor :players, :current_player_id, :board

  WINS = [[0, 1, 2, 3], [4, 5, 6, 7], [8, 9, 10, 11], [12, 13, 14, 15], [0, 4, 8, 12], [1,5,9,13], [2,6,10,14],
        [3,7,11,15], [0,5,10,15], [3,6,9,12]].freeze

  def initialize
    @players = add_players
    @board = Board.new
    @current_player_id = 0
  end

  def play
    until winner?(current_player) || draw?
      update(current_player)
      switch_players!
    end
    board.showboard
    puts "#{current_player.name} wins!" if winner?(current_player)
    puts "It's a draw!" if draw?
  end

  private

  def add_players
    puts 'Player 1'
    p1 = Player.new
    puts 'Player 2'
    p2 = Player.new
    [p1,p2]
  end

  def current_player
    players[current_player_id]
  end

  def update(player)
    board.showboard
    column = player.select_position!
    reassign(player, column)
  end

  def reassign(player, column)
    p board.update_board(column, player.token)
  end

  def winner?(player)
    WINS.any? do |line|
      line.all? { |position| board.board[position] == player.token }
    end
  end

  def full?
    board.board.all? { |circle| %w[X O].include?(circle) }
  end

  def other_id
    1 - current_player_id
  end

  def switch_players!
    self.current_player_id = other_id
  end

  def draw?
    !winner?(current_player) && full?
  end
end

class Player
  attr_reader :name, :token

  def initialize
    @name = get_name
    @token = get_token
  end

  def select_position!
    p "Select the column to drop your #{token}"
    selection = gets.to_i
    return selection - 1 if selection.between?(1,4)
    puts 'Not valid! Choose a position between 1 and 9'
    select_position!
  end

  def to_s
    Player.name
  end

  private

  def get_name
    puts 'What is your name?'
    return gets.chomp
  end
  
  def get_token
    puts 'Choose X or O'
    return gets.chomp
  end

end