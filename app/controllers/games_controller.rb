require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def included?(input, random_array)
    letter_array = input.split('')
    letter_array.each { |letter| random_array.include?(letter) }
  end

  def score
    proposition = params[:name]
    array_random = params[:letters]
    @score = if included?(proposition, array_random)
        if english_word?(proposition)
        score = compute_score(proposition)
        [score, "well done"]
      else
        [0, "not an english word"]
      end
    else
      [0, "not in the grid"]
    end
  end
end

def english_word?(word)
  response = open("https://wagon-dictionary.herokuapp.com/#{word}")
  json = JSON.parse(response.read)
  return json['found']
end

def compute_score(attempt)
  attempt.size * (1.0)
end