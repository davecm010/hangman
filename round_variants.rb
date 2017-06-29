def display_hangman(guesses_left)
  case guesses_left
  when 6
    puts %{
             ___
            |   |
                |
                |
                |
          ______|

                }
  when 5
    puts %{
             ___
            |   |
            O   |
                |
                |
          ______|

                }

  when 4
    puts %{
             ___
            |   |
            O   |
            |   |
                |
          ______|

                }
  when 3
    puts %{
             ___
            |   |
            O   |
            |\\  |
                |
          ______|

                }
  when 2
    puts %{
             ___
            |   |
            O   |
           /|\\  |
                |
          ______|

                }
  when 1
    puts %{
             ___
            |   |
            O   |
           /|\\  |
             \\  |
          ______|

                }
  when 0
    puts %{
             ___
            |   |
            O   |
           /|\\  |
           / \\  |
          ______|

                }
  end
end
