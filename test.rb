# -*- coding: utf-8 -*-
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

  it "no jobs" do
      expect(Jobs.new('').result).to eq('')
    end
  it "single job" do
    expect(Jobs.new('a =>').result).to eq('a')
  end
  it "unimportant order" do
    expect(Jobs.new("a =>
b =>
c =>").result).to eq('abc')
  end
  it "one priority" do
    expect(Jobs.new('a =>
b => c
c =>').result).to eq('acb')
  end
  it "multiple priorities" do
    expect(Jobs.new('a =>
b => c
c => f
d => a
e => b
f =>').result).to eq('afcbde')
  end
  it "reports an error" do
    expect{Jobs.new('a =>
b =>
c => c').result}.to raise_error(RuntimeError,/jobs can’t depend on themselves/)
  end
  it "reports another error" do
    expect{Jobs.new('a =>
b => c
c => f
d => a
e =>
f =>b').result}.to raise_error(RuntimeError,/jobs can’t have circular dependencies/)
  end
end
