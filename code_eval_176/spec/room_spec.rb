require 'spec_helper'

describe Room do
  let(:matrix) { [['#', '#', '#', '#', '#', '#', '#', '/', '#', '#'],
                  ['#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#'],
                  ['#', ' ', ' ', 'o', ' ', ' ', 'o', ' ', ' ', '#'],
                  ['#', ' ', ' ', ' ', ' ', 'o', ' ', 'o', ' ', '#'],
                  ['#', ' ', 'o', ' ', ' ', ' ', '*', 'o', ' ', '/'],
                  ['/', ' ', 'o', ' ', 'o', ' ', ' ', ' ', ' ', '\\'],
                  ['#', ' ', '*', ' ', '*', ' ', '*', 'o', ' ', '#'],
                  ['#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#'],
                  ['#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#'],
                  ['#', '#', '#', '/', '#', '\\', '#', '#', '#', '#']] }
  subject(:room) { Room.new(matrix) }
  let(:ray) { subject.rays.first }
  it 'shoould find all rays on the matrix' do
    expect(subject.rays.count).to eql(6)
  end
  it 'should put ray sign when space_action' do
    ray.process_action(:space)
    expect {subject.process_action(:space, ray)}.to change {subject.get_element_in(*ray.position)}.from(' ').to(ray.sign)
  end
  it 'should put \'X\' sign when perpendicular action' do
    expect {subject.process_action(:perpendicular, ray)}.to change {subject.get_element_in(*ray.position)}.to('X')
  end
  it 'should add 2 rays when prism' do
    expect { subject.process_action(:prism, ray) }.to change { subject.rays.count }.by(2)
  end
  it 'should remove 1 ray when action removal' do
    expect { subject.process_action(:removal, ray) }.to change { subject.rays.count}.by(-1)
  end
  it 'should get proper elements from matrix' do
    expect(subject.get_element_in(0, 5)).to eql('#')
    expect(subject.get_element_in(2, 3)).to eql('o')
    expect(subject.get_element_in(6, 2)).to eql('*')
    expect(subject.get_element_in(5, 9)).to eql('\\')
    expect(subject.get_element_in(9, 3)).to eql('/')
  end
end
