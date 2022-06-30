WINS = [[0, 1, 2, 3], [4, 5, 6, 7], [8, 9, 10, 11], [12, 13, 14, 15], [0, 4, 8, 12], [1,5,9,13], [2,6,10,14],
        [3,7,11,15], [0,5,10,15], [3,6,9,12]].freeze
COLUMNS = [[0,4,8,12], [1,5,9,13], [2,6,10,14], [3,7,11,15]].freeze

class Game
  attr_accessor :players, :board, :current_player_id

  def initialize
    @players = []
    @board = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
    @current_player_id = 0
  end

  def add_player(player)
    @players << player
  end

  def current_player
    @players[current_player_id]
  end

  def showboard
    puts " #{@board[0]} | #{@board[1]} | #{@board[2]} | #{@board[3]} "
    puts '_______________'
    puts " #{@board[4]} | #{@board[5]} | #{@board[6]} | #{@board[7]} "
    puts '_______________'
    puts " #{@board[8]} | #{@board[9]} | #{@board[10]} | #{@board[11]} "
    puts '_______________'
    puts " #{@board[12]} | #{@board[13]} | #{@board[14]} | #{@board[15]} "
    puts ' '
  end

  def play
    loop do
      update(current_player)
      if winner?(current_player)
        puts "#{current_player.name} wins!"
        showboard
        return
      elsif draw?
        puts "It's a draw!"
        showboard
        return
      end
      switch_players!
    end
  end

  def update(player)
    column = player.select_position!.to_i
    if @board[COLUMNS[column][3]] == ' '
        @board[COLUMNS[column][3]] = player.token
    elsif @board[COLUMNS[column][2]] == ' '
        @board[COLUMNS[column][2]] = player.token
    elsif @board[COLUMNS[column][1]] == ' '
        @board[COLUMNS[column][1]] = player.token
    elsif @board[COLUMNS[column][0]] == ' '
        @board[COLUMNS[column][0]] = player.token
    else
      puts 'Invalid! Choose Another Spot!'
      update(player)
    end
  end

  def winner?(player)
    WINS.any? do |line|
      line.all? { |position| @board[position] == player.token }
    end
  end

  def full?
    @board.all? { |x| %w[X O].include?(x) }
  end

  def other_id
    1 - @current_player_id
  end

  def switch_players!
    @current_player_id = other_id
  end

  def draw?
    if !winner?(current_player) && full?
      true
    elsif !winner?(current_player) && !full?
      false
    elsif winner?(current_player)
      false
    end
  end

  def over?
    false unless draw? || winner?(current_player) || full?
  end
end

class Player
  attr_accessor :name, :token, :game, :id

  def initialize(name, id, game, token)
    @name = name
    @game = game
    @token = token
    @id = id
  end

  def select_position!
    @game.showboard
    puts "Select the column to drop your #{token}"
    selection = gets.to_i
    if (1..4).include?(selection)
      selection - 1
    else
      puts 'Not a number! Choose a position between 1 and 9'
      select_position!
    end
  end

  def to_s
    Player.name
  end
end