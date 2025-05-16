# frozen_string_literal: true

require 'yaml'

class RotorConfiguration
  attr_reader :name, :wiring

  def initialize(name:, wiring:)
    @name = name
    @wiring = wiring
  end
end

class Rotor
  attr_reader :position

  def initialize(rotor_configuration:, position:)
    @rotor_configuration = rotor_configuration
    @position = position
  end

  def forward_encode_letter(letter)
    input_index = (letter.ord - 'A'.ord + @position) % 26
    mapped_letter = @rotor_configuration.wiring[input_index]
    output_index = (mapped_letter.ord - 'A'.ord - @position) % 26
    (output_index + 'A'.ord).chr
  end

  def backward_encode_letter(letter)
    input_index = (letter.ord - 'A'.ord + @position) % 26
    index_in_wiring = @rotor_configuration.wiring.index((input_index + 'A'.ord).chr)
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

data = YAML.load_file('enigma.yml')

rotor_i = data['rotors'].find { |r| r['name'] == 'I' }
rotor_ii = data['rotors'].find { |r| r['name'] == 'II' }
rotor_iii = data['rotors'].find { |r| r['name'] == 'III' }

enigma = Enigma.new(
  rotors: [
    Rotor.new(rotor_configuration: RotorConfiguration.new(name: rotor_ii['name'], wiring: rotor_ii['wiring']),
              position: 12),
    Rotor.new(rotor_configuration: RotorConfiguration.new(name: rotor_i['name'], wiring: rotor_i['wiring']),
              position: 7),
    Rotor.new(rotor_configuration: RotorConfiguration.new(name: rotor_iii['name'], wiring: rotor_iii['wiring']),
              position: 19)
  ],
  plugboard: Plugboard.new(%w[AB JP])
)
encrypted = enigma.encrypt('THE WEATHER IS CLEAR')
puts encrypted

enigma = Enigma.new(
  rotors: [
    Rotor.new(rotor_configuration: RotorConfiguration.new(name: rotor_ii['name'], wiring: rotor_ii['wiring']),
              position: 12),
    Rotor.new(rotor_configuration: RotorConfiguration.new(name: rotor_i['name'], wiring: rotor_i['wiring']),
              position: 7),
    Rotor.new(rotor_configuration: RotorConfiguration.new(name: rotor_iii['name'], wiring: rotor_iii['wiring']),
              position: 19)
  ],
  plugboard: Plugboard.new(%w[AB JP])
)
decrypted = enigma.encrypt(encrypted)

puts decrypted
