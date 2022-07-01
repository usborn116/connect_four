require './lib/classes'

describe Game do

  describe '#add_player' do
    subject(:game_end) { described_class.new }
    let(:player2) {instance_double(Player, name: 'usborn', id: 0, game: game_end, token:'X')}
    
    context 'when called' do
      it 'adds a player to the players list' do
        result = game_end.add_player(player2)
        expect(game_end.players).to include(player2)
        game_end.add_player(player2)
      end
    end
  end

  describe '#current_player' do
    subject(:game_end) { described_class.new }
    let(:player2) {instance_double(Player, name: 'usborn', id: 0, game: game_end, token:'X')}
    context 'when called' do
      before do
        game_end.instance_variable_set(:@current_player_id, 0)
        game_end.instance_variable_set(:@players, [player2])
      end

      it 'returns the current player' do
        expect(game_end.current_player).to eq(player2)
      end
    end
  end

  describe '#play' do
    subject(:game_end) { described_class.new }
    let(:player2) {instance_double(Player, name: 'usborn', id: 0, game: game_end, token:'X')}
    
    context 'when there is a winner' do
      before do
        name = player2.instance_variable_get(:@name)
        allow(game_end).to receive(:current_player).and_return(player2)
        allow(game_end).to receive(:update).and_return(nil)
        allow(game_end).to receive(:winner?).with(player2).and_return(true)
      end

      it "ends the loop" do
        expect(game_end).to receive(:switch_players!).exactly(0).times
      end
    end

    context 'when there is a draw' do
      let(:board) {game_end.instance_variable_get(:@board)}

      before do
        name = player2.instance_variable_get(:@name)
        allow(game_end).to receive(:current_player).and_return(player2)
        allow(game_end).to receive(:winner?).with(player2).and_return(false)
      end

      it "ends the loop" do
        allow(game_end).to receive(:draw?).and_return(true)
        allow(player2).to receive(:select_position!).and_return(2)
        expect(game_end).to receive(:switch_players!).exactly(0).times
      end
    end

    context 'when there is no draw or winner' do
      let(:board) {game.instance_variable_get(:@board)}

      before do
        name = player2.instance_variable_get(:@name)
        allow(game_end).to receive(:current_player).and_return(player2, player2)
        allow(game_end).to receive(:winner?).with(player2).and_return(false, false)
        allow(game_end).to receive(:update).and_return(nil, nil)
        allow(game_end).to receive(:draw?).and_return(false, true)
      end

      it "continues the loop" do
        expect(game_end).to receive(:switch_players!).exactly(1).time
        game_end.play
      end
    end
  end
  describe '#update' do
    context 'when a player makes a move' do
      subject(:game) { described_class.new }
      let(:board) {game.instance_variable_get(:@board)}
      let(:player1) {instance_double(Player, name: 'usborn', id: 0, game: game, token:'X')}

      it "puts the invalid error if a column larger than 3 is received" do
        allow(player1).to receive(:select_position!).and_return(4)
        expect{game.update(player1)}.to output("Invalid choice!\n").to_stdout
      end
    end
  end

  describe '#reassign' do
    context 'when token is placed' do
      subject(:game) { described_class.new }
      let(:board) {game.instance_variable_get(:@board)}
      let(:player1) {instance_double(Player, name: 'usborn', id: 0, game: game, token:'X')}

      it "to change the board" do
        column = 3
        expect{game.reassign(player1, column)}.to (change{game.board})
      end
    end
  end

  describe '#winner?' do
    context 'when the game ends' do
      subject(:game_won) { described_class.new }
      let(:player1) {instance_double(Player, name: 'usborn', id: 0, game: game_won, token:'X')}

      it "to declare that a winner exists" do
        result = true
        allow(WINS).to receive(:any?).and_return(true)
        expect(game_won.winner?(player1)).to eq(true)
      end
    end
  end

  describe '#full' do
    context 'when the board is full' do
      subject(:end_game) { described_class.new }
      let(:board) { end_game.instance_variable_get(:@board) }
      before do
        allow(board).to receive(:all?).and_return(true)
      end

      it "to return true" do
        expect(end_game.full?).to eq(true)
      end
    end
  end

  describe '#other_id' do
    context 'when two players are playing' do
      subject(:two_player_game) { described_class.new }
      let(:id_1) { end_game.instance_variable_get(:@current_player_id) }

      it "to return 1" do
        expect(two_player_game.other_id).to eq(1)
      end
    end
  end

  describe '#switch_players!' do
    context 'when players switch turns' do
      subject(:two_player_game) { described_class.new }
      let(:id_1) { end_game.instance_variable_get(:@current_player_id) }

      it "to change current player" do
        expect{two_player_game.switch_players!}.to change{two_player_game.current_player_id}.by(1)
      end
    end
  end

  describe '#draw?' do
    context 'when the game ends' do
      subject(:game_draw) { described_class.new }
      let(:player1) {instance_double(Player, name: 'usborn', id: 0, game: game_draw, token:'X')}

      it "to return true when there is no winner and the board is full" do
        allow(game_draw).to receive(:winner?).and_return(false)
        allow(game_draw).to receive(:full?).and_return(true)
        expect(game_draw.draw?).to eq(true)
      end

      it "to return false when there is no winner but the board is not full" do
        allow(game_draw).to receive(:winner?).and_return(false)
        allow(game_draw).to receive(:full?).and_return(false)
        expect(game_draw.draw?).to eq(false)
      end

      it "to return false when there is a winner" do
        allow(game_draw).to receive(:winner?).and_return(true)
        expect(game_draw.draw?).to eq(false)
      end
    end
  end
end

describe Player do
  subject(:player) { described_class.new('usborn',0,game,'X') }
  describe '#select_position!' do
    let(:game) { instance_double(Game)}
    let(:board) { game.instance_variable_get(:@board) }

    context 'when given a number between 1 and 4' do
      before do
        allow(game).to receive(:showboard)
        allow(player).to receive(:gets).and_return(2)
      end

      it 'returns the number - 1' do
        expect(player.select_position!).to eq(1)
      end
    end

    context 'when given a number higher than 4' do
      before do
        allow(game).to receive(:showboard).and_return(nil, nil, nil)
        allow(player).to receive(:gets).and_return(10, 10, 1)
      end

      it 'asks again' do
        error = 'Not a number! Choose a position between 1 and 9'
        expect(player).to receive(:puts).with(error).twice
        player.select_position!
      end
    end
  end
end