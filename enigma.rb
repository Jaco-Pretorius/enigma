class RotorWiring
  class << self
    def I
      new(
        name: 'I',
        mapping: 'EKMFLGDQVZNTOWYHXUSPAIBRCJ'
      )
    end

    def II
      new(
        name: 'II',
        mapping: 'AJDKSIRUXBLHWTMCQGZNPYFVOE'
      )
    end

    def III
      new(
        name: 'III',
        mapping: 'BDFHJLCPRTXVZNYEIWGAKMUSQO'
      )
    end
  end

  attr_reader :name, :mapping

  private

  def initialize(name:, mapping:)
    @name = name
    @mapping = mapping
  end

  private_class_method :new
end

class Rotor
  attr_reader :position

  def initialize(rotor_wiring:, position:)
    @rotor_wiring = rotor_wiring
    @position = position
  end

  def forward_encode_letter(letter)
    input_index = (letter.ord - 'A'.ord + @position) % 26
    mapped_letter = @rotor_wiring.mapping[input_index]
    output_index = (mapped_letter.ord - 'A'.ord - @position) % 26
    (output_index + 'A'.ord).chr
  end

  def backward_encode_letter(letter)
    input_index = (letter.ord - 'A'.ord + @position) % 26
    index_in_wiring = @rotor_wiring.mapping.index((input_index + 'A'.ord).chr)
    output_index = (index_in_wiring - @position) % 26
    (output_index + 'A'.ord).chr
  end

  def rotate
    @position = (@position + 1) % 26
  end
end

# This appears to be Reflector B-wide https://en.wikipedia.org/wiki/Enigma_rotor_details
class Reflector
  MAPPING = {
    'A' => 'Y', 'B' => 'R', 'C' => 'U', 'D' => 'H', 'E' => 'Q',
    'F' => 'S', 'G' => 'L', 'H' => 'D', 'I' => 'P', 'J' => 'X',
    'K' => 'N', 'L' => 'G', 'M' => 'O', 'N' => 'K', 'O' => 'M',
    'P' => 'I', 'Q' => 'E', 'R' => 'B', 'S' => 'F', 'T' => 'Z',
    'U' => 'C', 'V' => 'W', 'W' => 'V', 'X' => 'J', 'Y' => 'A',
    'Z' => 'T'
  }.freeze

  class << self
    def encode(letter)
      MAPPING.fetch(letter)
    end
  end

  private_constant :MAPPING
end

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

class Enigma
  def initialize(rotors:, plugboard:)
    @rotors = rotors
    @plugboard = plugboard
  end

  def encrypt(message)
    cleaned = message.upcase.chars.select { |c| ('A'..'Z').include?(c) }
    cleaned.map do |letter|
      rotate
      encrypt_letter(letter)
    end.join
  end

  private

  def rotate
    # Rotate the rightmost rotor every time
    @rotors[0].rotate

    # If rightmost rotor has completed a full rotation, step the middle rotor
    @rotors[1].rotate if @rotors[0].position == 0

    # If middle rotor has also completed a full rotation, step the leftmost rotor
    @rotors[2].rotate if @rotors[1].position == 0 && @rotors[0].position == 0
  end

  def encrypt_letter(l)
    # Pass through plugboard
    l = @plugboard.forward_encode_letter(l)

    # Forward through rotors
    @rotors.each do |rotor|
      l = rotor.forward_encode_letter(l)
    end

    # Reflect
    l = Reflector.encode(l)

    # Backward through rotors in reverse
    @rotors.reverse.each do |rotor|
      l = rotor.backward_encode_letter(l)
    end

    # Back through plugboard
    @plugboard.backward_encode_letter(l)
  end
end

enigma = Enigma.new(
  rotors: [
    Rotor.new(rotor_wiring: RotorWiring.II, position: 12),
    Rotor.new(rotor_wiring: RotorWiring.I, position: 7),
    Rotor.new(rotor_wiring: RotorWiring.III, position: 19)
  ],
  plugboard: Plugboard.new(%w[AB JP])
)
encrypted = enigma.encrypt('THE WEATHER IS CLEAR')
puts encrypted

enigma = Enigma.new(
  rotors: [
    Rotor.new(rotor_wiring: RotorWiring.II, position: 12),
    Rotor.new(rotor_wiring: RotorWiring.I, position: 7),
    Rotor.new(rotor_wiring: RotorWiring.III, position: 19)
  ],
  plugboard: Plugboard.new(%w[AB JP])
)
decrypted = enigma.encrypt(encrypted)

puts decrypted
