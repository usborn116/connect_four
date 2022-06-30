require './lib/playgame'
require './lib/classes'

describe Player
  describe "#select_position!"
  subject(:new_player){described_class.new}
    context "add a new player to the Game's players"
      before do

      it "increases player count"
        expect(new_player)
    end 
  end
end