# frozen_string_literal: true

require 'yaml'

class RotorConfiguration
  class << self
    def from_yaml(hash)
      new(name: hash['name'], wiring: hash['wiring'])
    end
  end

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

class Reflector
  def initialize(wiring:)
    alphabet = ('A'..'Z').to_a
    @mapping = wiring.chars.map.with_index { |letter, index| [alphabet[index], letter] }.to_h
  end

  def encode(letter)
    @mapping.fetch(letter)
  end
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
  def initialize(rotors:, plugboard:, reflector:)
    @rotors = rotors
    @plugboard = plugboard
    @reflector = reflector
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

  def encrypt_letter(letter)
    # Pass through plugboard
    letter = @plugboard.forward_encode_letter(letter)

    # Forward through rotors
    @rotors.each do |rotor|
      letter = rotor.forward_encode_letter(letter)
    end

    # Reflect
    letter = @reflector.encode(letter)

    # Backward through rotors in reverse
    @rotors.reverse.each do |rotor|
      letter = rotor.backward_encode_letter(letter)
    end

    # Back through plugboard
    @plugboard.backward_encode_letter(letter)
  end
end

data = YAML.load_file('enigma.yml')

configurations = data['rotors'].map { |hash| RotorConfiguration.from_yaml(hash) }
rotor_i = configurations.find { |r| r.name == 'I' }
rotor_ii = configurations.find { |r| r.name == 'II' }
rotor_iii = configurations.find { |r| r.name == 'III' }

reflector_b = data['reflectors'].find { |r| r['name'] == 'B' }

enigma = Enigma.new(
  rotors: [
    Rotor.new(rotor_configuration: rotor_ii, position: 12),
    Rotor.new(rotor_configuration: rotor_i, position: 7),
    Rotor.new(rotor_configuration: rotor_iii, position: 19)
  ],
  plugboard: Plugboard.new(%w[AB JP]),
  reflector: Reflector.new(wiring: reflector_b['wiring'])
)
encrypted = enigma.encrypt('THE WEATHER IS CLEAR')
puts encrypted

enigma = Enigma.new(
  rotors: [
    Rotor.new(rotor_configuration: rotor_ii, position: 12),
    Rotor.new(rotor_configuration: rotor_i, position: 7),
    Rotor.new(rotor_configuration: rotor_iii, position: 19)
  ],
  plugboard: Plugboard.new(%w[AB JP]),
  reflector: Reflector.new(wiring: reflector_b['wiring'])
)
decrypted = enigma.encrypt(encrypted)

puts decrypted
