require './lib/classes'

describe Game do

  describe '#initialize' do
    subject(:game) { described_class.new }

    context 'when called' do
      it 'adds players' do
        expect(subject.players).not_to be_empty
      end

      it 'creates a board' do
        expect(subject.board.board).to eql([" ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "])
      end

      it 'sets the initial player id' do
        expect(subject.current_player_id).to eql(0)
      end
    end
  end

  describe '#play' do
    subject(:game) { described_class.new }
    let(:player1) {instance_double(Player, name: 'usborn', token:'X')}
    let(:player2) {instance_double(Player, name: 'ash', token:'O')}
    
    context 'when there is a winner' do

      before do
        allow(game).to receive(:winner?).with(subject.players[0]).and_return(true)
      end

      it "ends the loop" do
        expect(game).to receive(:switch_players!).exactly(0).times
      end

      it 'calls showboard' do
        expect(game.board).to receive(:showboard).exactly(1).times
        game.play
      end

    end

    context 'when there is a draw' do

      before do
        allow(game).to receive(:draw?).and_return(true)
      end

      it "ends the loop" do
        expect(game).to receive(:switch_players!).exactly(0).times
        game.play
      end

      it 'calls showboard' do
        expect(game.board).to receive(:showboard).exactly(1).times
        game.play
      end
    end

    context 'when there is no draw or winner' do

      before do
        allow(game).to receive(:current_player).and_return(player1, player1)
        allow(game).to receive(:update).and_return(nil, nil)
        allow(game).to receive(:draw?).and_return(false, true)
      end

      it "continues the loop" do
        expect(game).to receive(:switch_players!).exactly(1).time
        game.play
      end

      it "switches the players" do
        game.play
        expect(game.current_player_id).to eql(1)
      end

    end

  end

end

describe Board do
  subject(:board) {described_class.new}

  describe '#update_board' do

    it "changes the board with X" do
      board.update_board(0, 'X')
      expect(board.board[12]).to eql('X')
    end

    it "changes the board with O" do
      board.update_board(0, 'O')
      expect(board.board[12]).to eql('O')
    end

    it "keeps the right spaces empty" do
      board.update_board(0, 'O')
      expect(board.board[8]).to eql(' ')
    end

    it "returns an invalid response" do
      board.board[0] = 'X'
      board.board[4] = 'X'
      board.board[8] = 'X'
      board.board[12] = 'X'      
      expect(board).to receive(:update_board).with(0, 'X').and_return('Invalid! Choose Another Spot!')
      board.update_board(0, 'X')
    end

  end
end

describe Player do
  subject(:player) { described_class.new }
  describe '#select_position!' do
    let(:game) { instance_double(Game)}
    let(:board) { instance_double(Board)}

    context 'when given a number between 1 and 4' do
      before do
        allow(board).to receive(:showboard)
        allow(player).to receive(:gets).and_return(2)
      end

      it 'returns the number - 1' do
        expect(player.select_position!).to eq(1)
      end
    end

    context 'when given a number higher than 4' do
      before do
        allow(board).to receive(:showboard).and_return(nil, nil, nil)
        allow(player).to receive(:gets).and_return(10, 10, 1)
      end

      it 'asks again' do
        error = 'Not valid! Choose a position between 1 and 9'
        expect(player).to receive(:puts).with(error).twice
        player.select_position!
      end
    end
  end
end