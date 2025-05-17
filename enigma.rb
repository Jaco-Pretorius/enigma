# frozen_string_literal: true

require 'yaml'
require_relative 'rotor_configuration'
require_relative 'rotor'
require_relative 'reflector'
require_relative 'plugboard'
require_relative 'alphabet_helper'

class Enigma
  def initialize(rotors:, plugboard:, reflector:)
    @rotors = rotors
    @plugboard = plugboard
    @reflector = reflector
  end

  def encrypt(message)
    cleaned = message.upcase.chars.select { |c| ('A'..'Z').include?(c) }
    cleaned.map do |letter|
      AlphabetHelper.letter_to_index(letter)
    end.map do |index|
      rotate
      encrypt_letter(index)
    end.map do |index|
      AlphabetHelper.index_to_letter(index)
    end.join
  end

  private

  def rotate
    @rotors[0].rotate do
      @rotors[1].rotate do
        @rotoes[2].rotate
      end
    end
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
    Rotor.new(configuration: rotor_ii, starting_position: 'M'),
    Rotor.new(configuration: rotor_i, starting_position: 'H'),
    Rotor.new(configuration: rotor_iii, starting_position: 'T')
  ],
  plugboard: Plugboard.new(%w[AB JP]),
  reflector: Reflector.new(wiring: reflector_b['wiring'])
)
encrypted = enigma.encrypt('THE WEATHER IS CLEAR')
puts encrypted

enigma = Enigma.new(
  rotors: [
    Rotor.new(configuration: rotor_ii, starting_position: 'M'),
    Rotor.new(configuration: rotor_i, starting_position: 'H'),
    Rotor.new(configuration: rotor_iii, starting_position: 'T')
  ],
  plugboard: Plugboard.new(%w[AB JP]),
  reflector: Reflector.new(wiring: reflector_b['wiring'])
)
decrypted = enigma.encrypt(encrypted)

puts decrypted
