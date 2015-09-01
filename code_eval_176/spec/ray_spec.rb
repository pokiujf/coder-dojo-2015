require 'spec_helper'

describe Ray do

  subject(:ray) { Ray.new(3, 0, 45) }

  it { expect(subject).to be_instance_of Ray }
  it { expect(subject.row_pos).to eql(3) }
  it { expect(subject.column_pos).to eql(0) }
  it { expect(subject.rotation).to eql(45) }
  it 'should call move with prism param' do
    expect(subject).to receive(:move).with(prism: true)
    subject.process_action(:prism)
  end
  it 'should call reflect_position' do
    expect(subject).to receive(:reflect_position)
    subject.process_action(:wall)
  end

  context '#get_rotation_for' do
    let(:tops) { [[0, 1], [0, 5], [0, 8]] }
    let(:bottoms) { [[9, 1], [9, 5], [9, 8]] }
    let(:rights) { [[1, 0], [5, 0], [8, 0]] }
    let(:lefts) { [[1, 9], [5, 9], [8, 9]] }

    context 'for ray sign \'\\\'' do
      let(:sign) { '\\' }
      it 'should return 135 when starting in top or right' do
        (tops + rights).each do |row, column|
          expect(described_class.get_rotation_for(row, column, sign)).to eql(135)
        end
      end
      it 'should return 315 whe starting in bottom or left' do
        (bottoms + lefts).each do |row, column|
          expect(described_class.get_rotation_for(row, column, sign)).to eql(315)
        end
      end
    end

    context 'for ray sign \'/\'' do
      let(:sign) { '/' }
      it 'should return 45 when starting in right or bottom' do
        (rights + bottoms).each do |row, column|
          expect(described_class.get_rotation_for(row, column, sign)).to eql(45)
        end
      end
      it 'should return 225 whe starting in left or top' do
        (lefts + tops).each do |row, column|
          expect(described_class.get_rotation_for(row, column, sign)).to eql(225)
        end
      end
    end
  end
  context '#new_splits' do
    let(:splitters) { ray.new_splits }
    it 'should create two splits' do
      expect(splitters.count).to eql(2)
    end
    it 'splinters should have proper values' do
      splitters.each do |splitter|
        expect(splitter.row_pos).to eql(ray.row_pos)
        expect(splitter.column_pos).to eql(ray.column_pos)
        expect(splitter.length).to eql(ray.length)
        expect(splitter.rotation).to eql((ray.rotation + 90) % 360).or eql((ray.rotation - 90) % 360)
      end
    end
  end
  context '#sign' do
    context 'for rotation 45 & 225' do
      let(:ray_45) { Ray.new(1, 1, 45) }
      let(:ray_225) { Ray.new(1, 1, 225) }
      it { expect(ray_45.sign).to eql('/') }
      it { expect(ray_225.sign).to eql('/') }
    end
    context 'for rotation 135 & 315' do
      let(:ray_135) { Ray.new(1, 1, 135) }
      let(:ray_315) { Ray.new(1, 1, 315) }
      it { expect(ray_135.sign).to eql('\\') }
      it { expect(ray_315.sign).to eql('\\') }
    end
  end
  it { expect(subject.to_a).to be_instance_of(Array) }
  it '#next_coordinates should be current_position + vector value' do

    next_coordinates = {row: subject.row_pos + subject.send('vector')[:row],
                        column: subject.column_pos + subject.send('vector')[:column]}
    expect(subject.next_position).to eql(next_coordinates)
  end
  it { expect(subject.position).to eql([subject.row_pos, subject.column_pos])}

  context 'class constants exception handling' do
    it 'ROTATIONS should have default' do
      expect(described_class::ROTATIONS[0]).to be_instance_of(Hash)
    end
    it 'ROTATION_REFLECTIONS should have default' do
      expect(described_class::ROTATION_REFLECTIONS[0]).to be_instance_of(Hash)
    end
  end
end