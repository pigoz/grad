RSpec.describe 'Event' do
  let(:keydown1) { Grad::Event.keydown(18) }
  let(:keyup1)   { Grad::Event.keyup(18) }
  let(:keydown2) { Grad::Event.keydown(19) }
  let(:keyup2)   { Grad::Event.keyup(19) }
  let(:keydown_backspace) { Grad::Event.keydown(51) }
  let(:keyup_backspace)   { Grad::Event.keyup(51) }

  it 'can generate keydown' do
    expect(keydown1.key).to eql(18)
    expect(keydown1).to be_keydown
  end

  it 'can generate keyup' do
    expect(keyup2.key).to eql(19)
    expect(keyup2).to be_keyup
  end

  describe '#post' do
    it 'posts the event' do
      keydown1.post
      keyup1.post
      keydown_backspace.post
      keyup_backspace.post
    end
  end
end
