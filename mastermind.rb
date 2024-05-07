class Player
  attr_accessor :role

  def initialize(role)
    @role = role
  end
end

class CodeMaker < Player
  attr_reader :secret_code

  def initialize(role, colors)
    super(role)  # Calls Player's initialize method
    @secret_code = generate_secret_code(colors)
    puts "CodeMaker's secret code is #{@secret_code}"
  end

  def generate_secret_code(colors)
    colors.sample(4)
  end
  
  def provide_feedback(guess)
    exact_matches = 0
    color_matches = 0

    guess_copy = guess.dup
    secret_copy = @secret_code.dup

    # First pass: Check for exact matches
    guess_copy.each_with_index do |color, index|
      if color == secret_copy[index]
        exact_matches += 1
        guess_copy[index] = nil
        secret_copy[index] = nil
      end
    end

    # Second pass: Check for color matches
    guess_copy.each do |color|
      if color && secret_copy.include?(color)
        color_matches += 1
        secret_copy[secret_copy.index(color)] = nil
      end
    end

    [exact_matches, color_matches]
  end
end


class CodeBreaker < Player
  def make_guess
    puts "Enter your guess (e.g., Red Blue Green Yellow):"
    gets.chomp.split
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
    puts "Current game state:"
    @guesses.each_with_index do |guess, index|
      feedback = @feedbacks[index]
      puts "#{index + 1}: #{guess.join(' ')} - Exact Matches: #{feedback[0]}, Color Matches: #{feedback[1]}"
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
    puts "Welcome to Mastermind!"
    while @turns_left > 0
      guess = @codebreaker.make_guess
      feedback = @codemaker.provide_feedback(guess)
      @board.add_guess(guess, feedback)
      @board.display
      if feedback[0] == 4  # All pegs are correct
        puts "Congratulations, you've cracked the code!"
        return
      end
      @turns_left -= 1
    end
    puts "Game over! You've used all your turns."
    puts "The secret code was: #{@codemaker.secret_code.join(', ')}"
  end
end

game = Game.new
game.play