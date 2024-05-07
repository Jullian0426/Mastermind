class Code
  attr_reader :code

  def initialize(code = nil)
    @code = code || generate_unique_code
  end

  def generate_unique_code
    (1..6).to_a.shuffle.take(4)
  end

  def check_guess(guess)
    feedback = { correct: 0, wrong_position: 0 }
    guess_copy = guess.dup
    code_copy = @code.dup

    # First pass: check for correct number and position
    guess_copy.each_with_index do |g, i|
      if g == code_copy[i]
        feedback[:correct] += 1
        guess_copy[i] = code_copy[i] = nil
      end
    end

    # Second pass: check for correct number but wrong position
    guess_copy.compact.each do |g|
      if index = code_copy.index(g)
        feedback[:wrong_position] += 1
        code_copy[index] = nil
      end
    end

    feedback
  end
end

class Player
  def guess
    puts "Enter your guess (e.g., '1 2 3 4'):"
    gets.chomp.split.map(&:to_i)
  end

  def make_code
    puts "Enter your secret code for the computer to guess (e.g., '1 2 3 4'):"
    input = gets.chomp.split.map(&:to_i)
    if input.uniq.length == 4 && input.all? { |num| num.between?(1, 6) }
      input
    else
      puts "Invalid code! Please enter four unique digits between 1 and 6."
      make_code
    end
  end
end

class Computer
  def initialize
    @possible_guesses = (1..6).to_a.permutation(4).to_a
  end

  def generate_code
    Code.new
  end

  def guess(feedback = nil)
    @possible_guesses.sample
  end
end

class Mastermind
  def initialize
    @player = Player.new
    @computer = Computer.new
    @codebreaker = nil
    @codemaker = nil
  end

  def setup_game
    puts "Do you want to be the codebreaker or the codemaker? (Enter 'breaker' or 'maker'):"
    choice = gets.chomp
    if choice == 'breaker'
      @codebreaker = @player
      @codemaker = @computer
      @secret_code = @computer.generate_code
    else
      @codebreaker = @computer
      @codemaker = @player
      @secret_code = Code.new(@player.make_code)
    end
  end

  def play
    setup_game
    feedback = nil
    12.times do |turn|
      puts "Turn #{turn + 1}:"
      guess = @codebreaker.guess(feedback)  # Pass previous feedback to guess method
      puts "Guess: #{guess.join(' ')}"  # Display the guess
      feedback = @secret_code.check_guess(guess)
      puts "Feedback: Correct: #{feedback[:correct]}, Wrong Position: #{feedback[:wrong_position]}"
      if feedback[:correct] == 4
        puts "The codebreaker has won!"
        return
      end
    end
    puts "The codemaker has won!"
  end
end

# To play the game:
game = Mastermind.new
game.play
