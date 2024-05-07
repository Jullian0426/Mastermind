class Player
  attr_accessor :role

  def initialize(role)
    @role = role
  end
end

class CodeMaker < Player
  attr_reader :secret_code

  def initialize(role, colors)
    super(role)
    @secret_code = generate_secret_code(colors)
  end

  def generate_secret_code(colors)
    Array.new(4) { colors.sample }
  end

  def provide_feedback(guess)
    # Logic to provide feedback based on the guess
  end
end

class CodeBreaker < Player
  def make_guess
    # Logic for making a guess
  end
end


class Board
  def initialize
    @guesses = []
    @feedbacks = []
  end

  def add_guess(guess, feedback)
    @guesses << guess
    @feedbacks << feedback
  end

  def display
    @guesses.each_with_index do |guess, index|
      puts "Guess #{index + 1}: #{guess.join(', ')} - Feedback: #{@feedbacks[index]}"
    end
  end
end


class Game
  def initialize
    @colors = ["Red", "Blue", "Green", "Yellow", "Orange", "Purple"]
    setup_players
    @board = Board.new
    @turns_left = 12
  end

  def setup_players
    puts "Do you want to be the codemaker or the codebreaker? (Enter 'codemaker' or 'codebreaker')"
    role = gets.chomp
    if role == 'codemaker'
      @codemaker = CodeMaker.new(role, @colors)
      @codebreaker = CodeBreaker.new('codebreaker')
    else
      @codemaker = CodeMaker.new('codemaker', @colors)
      @codebreaker = CodeBreaker.new(role)
    end
  end

  def play
    while @turns_left > 0
      guess = @codebreaker.make_guess
      feedback = @codemaker.provide_feedback(guess)
      @board.add_guess(guess, feedback)
      break if feedback == "Win condition"
      @turns_left -= 1
    end
    @board.display
  end
end
