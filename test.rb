require './jobs.rb'
describe Fixnum do
  it 'returns the sum of its arguments' do
    expect(1.+2).to eq(3)
  end
  it "reports an error" do
    expect{2/0}.to raise_error(ZeroDivisionError,'divided by 0')
  end
end

describe Jobs do
  it "arrays equality" do
    expect(['a','b','c']).to eq(['a','b','c'])
  end

  if
  end

end
