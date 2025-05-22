# frozen_string_literal: true

module AlphabetHelper
  ALPHABET_SIZE = 26
  A_ORD = 'A'.ord

  module_function

  def letter_to_index(letter)
    (letter.ord - A_ORD) % ALPHABET_SIZE
  end

  def index_to_letter(index)
    (index % ALPHABET_SIZE + A_ORD).chr
  end

  private_constant :ALPHABET_SIZE, :A_ORD
end
