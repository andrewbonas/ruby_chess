require_relative '../lib/board.rb'
require_relative '../lib/tokens.rb'

RSpec.describe Board do
  describe '#create_board' do
    it 'The board creates eight rows' do
      subject.create_board
    expect(subject.create_board).to eq(8)
    end
  end

  describe '#add_white_tokens' do
    it 'white tokens are added from token class to board' do
      subject.add_white_tokens
    expect(subject.add_white_tokens).to eq(Rook.new('white').to_s)
    end
  end

  describe '#add_black_tokens' do
    it 'Black tokens are added from token class to board' do
      subject.add_black_tokens
    expect(subject.add_black_tokens).to eq(Rook.new('black').to_s)
    end
  end

   describe '#user_input' do
     context 'a valid input was made' do
       before do
         allow(subject).to receive(:valid_input?) { true }
       end
       it 'breaks the loop' do
         allow(subject).to receive(:gets).and_return('a2a4')
         expect(subject).to receive(:valid_input?).once
         subject.user_input
       end
     end
   end
end