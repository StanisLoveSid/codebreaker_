require "spec_helper"

module Codebreaker
  RSpec.describe Game do

    subject(:game) { Game.new }

    [
      [[1,2,3,4], '1234', '++++'], [[5,1,4,3], '4153', '++--'],
      [[6,2,3,5], '2365', '+---'], [[1,2,2,1], '2112', '----'], [[1,2,3,4], '1235', '+++'],
      [[1,2,3,4], '6254', '++'], [[1,2,3,4], '4444', '+'], [[1,2,3,4], '4326', '---'],
      [[1,2,3,4], '3525', '--'], [[1,2,3,4], '4255', '+-'],
      [[1,2,3,4], '1524', '++-'], [[1,2,3,4], '5431', '+--'], [[1,2,3,4], '6666', ''],
      [[1,1,1,5], '1231', '+-'], [[1,2,3,1], '1111', '++']
    ].each do |item|
      it "Secret code is #{item[0]}, guessed is #{item[1]}, have to return #{item[2]}" do
        subject.instance_variable_set(:@coded, item[0])
        subject.instance_variable_set(:@user_input, item[1])
        expect(subject.guessing).to eq item[2]
      end
    end

    it "#initialize" do
      expect(subject.instance_variable_get(:@coded)).to match([1..6, 1..6, 1..6, 1..6])
      expect(subject.instance_variable_get(:@user_hints)).to be 3
      expect(subject.instance_variable_get(:@user_attempts)).to be 9
      expect(subject.instance_variable_get(:@show_result)).to be_empty
      expect(subject.instance_variable_get(:@user_input)).to be_empty
    end

    it "shows hint" do
      subject.instance_variable_set(:@user_hints, 3)
      expect(subject.show_hint).to match 1..6
      expect(subject.instance_variable_get(:@user_hints)).to be 2
    end

    it "shows no hints" do
      subject.instance_variable_set(:@user_hints, 0)
      expect { subject.show_hint }.to output(/No hints left/).to_stdout
    end

    it "shows statisctics" do
      expect(subject.statistics[:attempts]).to eq Game::USER_ATTEMPTS
      expect(subject.statistics[:hints]).to eq Game::USER_HINTS
      expect(subject.statistics[:user_attempts_left]).to be_between(0, 9)
      expect(subject.statistics[:user_hints_left]).to be_between(0, 3)
      expect(subject.statistics[:secret_code]).to match([1..6, 1..6, 1..6, 1..6].to_s)
    end

    it "saves data" do
      subject.save_data
      allow(subject).to receive(:gets).and_return('John')
      expect(File.exist?('statistics.yaml')).to eq true
    end
    it "asks for saving" do
      subject.want_to_save_result
      allow(subject).to receive(:gets).and_return('y')
      expect(subject).to receive(:save_data)
      expect(subject).to receive(:want_to_resume)
    end

    it "asks for resuming" do
      allow(subject).to receive(:want_to_resume)
      allow(subject).to receive(:gets).and_return('y')
      expect(subject).to receive(:start)
    end

  end
end
