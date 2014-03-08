# -*- coding: utf-8 -*-
require './jobs.rb'

describe Jobs do
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
  it "checks for enexpected data" do
    expect{Jobs.new('a => b => c => ').result}.to raise_error(RuntimeError,/malformed data/)
  end
  it "checks for enexpected data" do
    expect{Jobs.new('a => bc ').result}.to raise_error(RuntimeError,/one character long job symbols expected/)
  end
end
