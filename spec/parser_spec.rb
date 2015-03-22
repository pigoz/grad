RSpec.describe Grad::Parser, '#parse' do
  it 'parses a SendInput event' do
    x = subject.parse <<-AHK.strip_heredoc.chomp
      SendInput {Numpad3 down}
    AHK
    expect(x[:command].to_s).to eql('SendInput')
    expect(x[:key].to_s).to eql('Numpad3')
    expect(x[:state].to_s).to eql('down')
  end

  it 'parses a simple SendInput event' do
    x = subject.parse <<-AHK.strip_heredoc.chomp
      SendInput {Numpad3}
    AHK
    expect(x[:command].to_s).to eql('SendInput')
    expect(x[:key].to_s).to eql('Numpad3')
    expect(x[:state]).to be nil
  end

  it 'parses a Sleep event' do
    x = subject.parse <<-AHK.strip_heredoc.chomp
      Sleep, 1337
    AHK
    expect(x[:command].to_s).to eql('Sleep')
    expect(x[:ms].to_s).to eql('1337')
  end

  it 'parses many events' do
    x = subject.parse <<-AHK.strip_heredoc.chomp
      SendInput {Numpad3 down}
      Sleep, 123
      SendInput {Numpad3 up}
    AHK
    expect(x[0][:command].to_s).to eql('SendInput')
    expect(x[0][:key].to_s).to eql('Numpad3')
    expect(x[0][:state].to_s).to eql('down')
    expect(x[1][:command].to_s).to eql('Sleep')
    expect(x[1][:ms].to_s).to eql('123')
    expect(x[2][:command].to_s).to eql('SendInput')
    expect(x[2][:key].to_s).to eql('Numpad3')
    expect(x[2][:state].to_s).to eql('up')
  end

  it 'parses a complex file' do
    f = IO.read(File.expand_path('../fixtures/gerudo.ahk', __FILE__))
    x = subject.parse(f.chomp)
    expect(x.size).to eql(496)
  end
end
