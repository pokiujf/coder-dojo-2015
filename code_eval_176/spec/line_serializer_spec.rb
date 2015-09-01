require 'spec_helper'

describe LineSerializer do
  let(:line) { '###########        ##  o  o  ##    o o ## o   *o ## o o    ## * * *o ##        ##        ####/######' }
  let(:matrix) { [['#', '#', '#', '#', '#', '#', '#', '#', '#', '#'],
                  ['#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#'],
                  ['#', ' ', ' ', 'o', ' ', ' ', 'o', ' ', ' ', '#'],
                  ['#', ' ', ' ', ' ', ' ', 'o', ' ', 'o', ' ', '#'],
                  ['#', ' ', 'o', ' ', ' ', ' ', '*', 'o', ' ', '#'],
                  ['#', ' ', 'o', ' ', 'o', ' ', ' ', ' ', ' ', '#'],
                  ['#', ' ', '*', ' ', '*', ' ', '*', 'o', ' ', '#'],
                  ['#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#'],
                  ['#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#'],
                  ['#', '#', '#', '/', '#', '#', '#', '#', '#', '#']] }
  it 'should properly serialize line' do
    expect(described_class.serialize(line)).to eql(matrix)
  end
  it 'should properly deserialize matrix' do
    expect(described_class.deserialize(matrix)).to eql(line)
  end
end