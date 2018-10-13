module Codebreaker
  class Game

    require 'yaml'

    USER_ATTEMPTS = 9
    USER_HINTS = 3

    def initialize
      @user_input = ''
      @show_result = ""
      @user_attempts = USER_ATTEMPTS
      @user_hints = USER_HINTS
      @coded = Array.new(4) { rand(1..6) }
    end

    def start
      puts "New game has been started"
      while @user_attempts > 0
        case @user_input = gets.chomp
        when 'exit'
          return
        when /^[1-6]{4}$/
          guessing
          puts @show_result
          want_to_save_result if @show_result == "++++"
        when 'hint'
          show_hint
        else
          puts "You must use 4 digits in rage from 1 to 6"
        end
      end
      puts "No attemts left" if @user_attempts == 0
    end

    def show_hint
      puts @user_hints > 0 ? @coded[rand(0..3)] : "No hints left"
      @user_hints -= 1
    end

    def want_to_save_result
      puts "You won! Want to save your result? y/n"
      want = gets.chomp
      if want == 'y'
        save_data
      else
        puts "Ok! Bye!"
      end
      want_to_resume
    end

    def want_to_resume
      puts "Want to play again? y/n"
      want = gets.chomp
      Game.new.start if want == 'y'
      exit
    end

    def save_data
      puts "Enter your name"
      data = statistics
      data[:user_name] = gets.chomp
      File.write("statistics.yaml", data.to_yaml)
    end

    def statistics
      {
        time: Time.now,
        secret_code: @coded.to_s,
        attempts: USER_ATTEMPTS,
        hints: USER_HINTS,
        user_attempts_left: @user_attempts,
        user_hints_left: @user_hints
      }
    end

    def guessing
      @show_result = ""
      code = @user_input.split("").map {|e| e.to_i}
      comparing = (code.zip @coded)
      i = 0
      comparing.each do |first, second|
        if first == second
          @show_result << "+"
          comparing[i][comparing[i].index(first)] = 0
          comparing[i][comparing[i].index(second)] = 0
        end
        i += 1
      end
      comparing.reject! {|element| element == [0, 0]}
      if comparing.any?
        comparing.transpose[0].each do |e|
          @show_result << "-" if comparing.transpose[1].include? e
        end
      end
      @user_attempts -= 1
      @show_result
    end

  end
end

#Game.new.start
