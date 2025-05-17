# frozen_string_literal: true

class Plugboard
  def initialize(plugs)
    # plugs = ["ab", "gd", ...]
    @plugs = {}
    used_letters = []

    plugs.each do |pair|
      l1 = AlphabetHelper.letter_to_index(pair[0])
      l2 = AlphabetHelper.letter_to_index(pair[1])

      unless used_letters.include?(l1) || used_letters.include?(l2)
        @plugs[l1] = l2
        used_letters << l1 << l2
      end
    end

    @invert_plugs = @plugs.invert
    # Example: {"a"=>"b", "g"=>"d", ...}
  end

  def forward_encode_letter(letter)
    @plugs.fetch(letter, letter)
  end

  def backward_encode_letter(letter)
    @invert_plugs.fetch(letter, letter)
  end
end
