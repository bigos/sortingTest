# -*- coding: utf-8 -*-
require './jobs.rb'

describe Jobs do
  it "no jobs" do
    expect(Jobs.new('').sort).to eq('')
  end
  it "single job" do
    expect(Jobs.new('a =>').sort).to eq('a')
  end
  it "unimportant order" do
    expect(Jobs.new("a =>
      b =>
      c =>").sort).to eq('abc')
  end
  it "one priority" do
    expect(Jobs.new('a =>
      b => c
      c =>').sort).to eq('acb')
  end
  it "multiple priorities" do
    expect(Jobs.new('a =>
      b => c
      c => f
      d => a
      e => b
      f =>').sort).to eq('afcbde')
  end
  it "reports an error" do
    expect{Jobs.new('a =>
      b =>
      c => c').sort}.to raise_error(RuntimeError,/jobs can’t depend on themselves/)
  end
  it "reports another error" do
    expect{Jobs.new('a =>
      b => c
      c => f
      d => a
      e =>
      f =>b').sort}.to raise_error(RuntimeError,/jobs can’t have circular dependencies/)
  end
  it "checks for enexpected data" do
    expect{Jobs.new('a => b => c => ').sort}.to raise_error(RuntimeError,/malformed data/)
  end
  it "checks for enexpected data" do
    expect{Jobs.new('a => bc ').sort}.to raise_error(RuntimeError,/one character long job symbols expected/)
  end
end
