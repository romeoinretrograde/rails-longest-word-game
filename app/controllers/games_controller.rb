require "open-uri"

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)


  def new
    # This methods gets a sample that contains 5 items, which are all vowels
    @letters = Array.new(5) { VOWELS.sample }
    # Then, it adds a sample with 5 items, that are all consonants
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    # And finally, it shuffles the letters.
    @letters.shuffle!
  end

  def score
    # The letters are a param for the score. It has to be split so it counts as an array
    @letters = params[:letters].split
    # The word is also a param, or it's empty. That's upcased.
    @word = (params[:word] || "").upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
  end

  private

  def included?(word, letters)
    # This method calls the characters of the word, and for each of those characters, it checks if the ammount of times
    # that letter is used in the word is smaller or equal to the ammount of times that character is showed in the letters of the game
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    # This method calls the wagon dictionary to check for the word. The attribute "found" in the json tells you if the
    # word is in the dictionary or not.
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
