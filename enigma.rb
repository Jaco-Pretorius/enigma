# frozen_string_literal: true

require 'yaml'
require_relative 'rotor_configuration'
require_relative 'rotor'
require_relative 'reflector'
require_relative 'plugboard'
require_relative 'alphabet_helper'
require_relative 'configuration_helper'

class Enigma
  def initialize(rotors:, plugboard:, reflector:)
    @rotors = rotors
    @plugboard = plugboard
    @reflector = reflector
  end

  def encrypt(message)
    cleaned = message.upcase.chars.select { |c| ('A'..'Z').include?(c) }
    letter_indexes = cleaned.map { |letter| AlphabetHelper.letter_to_index(letter) }
    encrypted_indexes = letter_indexes.map do |index|
      rotate
      encrypt_letter(index)
    end
    encrypted_indexes.map { |index| AlphabetHelper.index_to_letter(index) }.join
  end

  private

  def rotate
    if @rotors[1].notches.include?(@rotors[1].position)
      puts 'double-stepping'
      @rotors[1].rotate
      @rotors[2].rotate
    elsif @rotors[0].notches.include?(@rotors[0].position)
      puts 'stepping'
      @rotors[1].rotate
    end
    @rotors[0].rotate
  end

  def encrypt_letter(letter)
    # Pass through plugboard
    letter = @plugboard.encode_letter(letter)

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
    @plugboard.encode_letter(letter)
  end
end

rotor_i = ConfigurationHelper.rotor_named('I')
rotor_ii = ConfigurationHelper.rotor_named('II')
rotor_iii = ConfigurationHelper.rotor_named('III')
reflector_b = ConfigurationHelper.reflector_named('B')

enigma = Enigma.new(
  rotors: [
    Rotor.new(configuration: rotor_iii, starting_position: 'A', ring_setting: 'A'),
    Rotor.new(configuration: rotor_ii, starting_position: 'A', ring_setting: 'A'),
    Rotor.new(configuration: rotor_i, starting_position: 'A', ring_setting: 'A')
  ],
  plugboard: Plugboard.new([]),
  reflector: reflector_b
)
encrypted = enigma.encrypt('ACHTUNG')
puts encrypted

enigma = Enigma.new(
  rotors: [
    Rotor.new(configuration: rotor_iii, starting_position: 'A', ring_setting: 'A'),
    Rotor.new(configuration: rotor_ii, starting_position: 'A', ring_setting: 'A'),
    Rotor.new(configuration: rotor_i, starting_position: 'A', ring_setting: 'A')
  ],
  plugboard: Plugboard.new([]),
  reflector: reflector_b
)
decrypted = enigma.encrypt(encrypted)

puts decrypted
