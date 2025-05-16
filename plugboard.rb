# frozen_string_literal: true

class Plugboard
  def initialize(plugs)
    # plugs = ["ab", "gd", ...]
    @plugs = {}
    used_letters = []

    plugs.each do |pair|
      l1 = pair[0]
      l2 = pair[1]

      unless used_letters.include?(l1) || used_letters.include?(l2)
        @plugs[l1] = l2
        used_letters << l1 << l2
      end
    end

    @invert_plugs = @plugs.invert
    # Example: {"a"=>"b", "g"=>"d", ...}
  end

  def forward_encode_letter(l)
    @plugs.fetch(l, l)
  end

  def backward_encode_letter(l)
    @invert_plugs.fetch(l, l)
  end
end
