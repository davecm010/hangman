class Hangman

  require_relative 'round_variants'
  require 'yaml'

  attr_accessor :random_word, :user_guesses, :guesses_left

  def initialize
    @random_word = nil
    @user_guesses = []
    @guesses_left = 6
    game_menu
  end

  def game_menu
    puts %{
              HANGMAN

          'n' --- NEW GAME
          'l' --- LOAD GAME
          'q' --- QUIT
     }
     input = nil
     until ['n','l','q'].include? input
       puts "please type either 'n', 'l', or 'q':"
       input = gets.chomp.strip.downcase
     end
     case input
     when 'n'
       @random_word = random_word
       @user_guesses = []
       @guesses_left = 6
       play_game
     when 'l'
       load_game
     when 'q'
       puts "Goodbye!"
       exit
     end
   end

   def load_game
     puts ""
     puts "Saved Files:"
     Dir["saves/*"].each_with_index {|file, i| puts "#{i+1}) #{file[6..-1]}"}
     puts "Enter the name of your saved game:"
     file_name = gets.chomp.strip
     if !File.exist?("saves/#{file_name}") || file_name == ''
       game_menu
     else
       file = YAML.load_file("saves/#{file_name}")
       @random_word = file[:random_word]
       @user_guesses = file[:user_guesses]
       @guesses_left = file[:guesses_left]
       File.delete("saves/#{file_name}")
       play_game
     end
   end

   def save_game
     puts "Save file as (name):"
     file_name = gets.chomp.strip
     yaml = YAML.dump({
       random_word: @random_word,
       user_guesses: @user_guesses,
       guesses_left: @guesses_left
       })
     File.open("saves/#{file_name}", "w") {|save| save.write(yaml)}
     exit
   end

   def play_game
     display_hangman(@guesses_left)
     loop do
       show_board
       player_guess
       display_hangman(@guesses_left)
       game_over?
     end
   end

  def random_word
    word = File.readlines("5desk.txt").sample.strip.upcase
    if word.length >= 5 && word.length <= 12
      return word
    else
      random_word
    end
  end

  def show_board
    @random_word.split('').each do |char|
      if @user_guesses.include? char
        print " #{char} "
      else
        print " _ "
      end
    end
    puts %{
            }
  end

  def player_guess
    puts "Pick a letter (guesses left: #{@guesses_left})    {type 'save' to save and quit game}"
    letter = gets.chomp.strip.upcase
    until answer_check(letter)
      letter = gets.chomp.strip.upcase
    end
    @user_guesses << letter
    guess_check(letter)
  end

  def answer_check(letter)
    case letter
    when'SAVE'
      save_game
    when letter.length > 1
      puts "That answer is more than one character! Try again:"
      return false
    when @user_guesses.include?(letter)
      puts "That letter has already been used! Try again:"
      return false
    else
      return true
    end
  end

  def guess_check(letter)
    unless @random_word.include? letter
      @guesses_left -= 1
    end
  end

  def game_over?
    if @random_word.split('').all? {|char| @user_guesses.include? char}
      puts "Congrats YOU WIN!"
      puts "correct word: #{@random_word}"
      game_menu
    elsif @guesses_left == 0
      puts "correct word: #{@random_word}"
      puts "You have run out of guesses, GAME OVER."
      game_menu
    end
  end

end

hangman = Hangman.new
