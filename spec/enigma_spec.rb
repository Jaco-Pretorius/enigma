# frozen_string_literal: true

require_relative '../enigma'

RSpec.describe Enigma do
  it 'correctly encrypts using basic settings' do
    enigma = Enigma.new(
      rotors: [
        Rotor.new(configuration: ConfigurationHelper.rotor_named('III'), starting_position: 'A', ring_setting: 'A'),
        Rotor.new(configuration: ConfigurationHelper.rotor_named('II'), starting_position: 'A', ring_setting: 'A'),
        Rotor.new(configuration: ConfigurationHelper.rotor_named('I'), starting_position: 'A', ring_setting: 'A')
      ],
      plugboard: Plugboard.new([]),
      reflector: ConfigurationHelper.reflector_named('B')
    )

    encrypted = enigma.encrypt('ABCDEFGHIJKLMNOPQRSTUVWXYZAAAAAAAAAAAAAAAAAAAAAAAAAABBBBBBBBBBBBBBBBBBBBBBBBBBABCDEFGHIJKLMNOPQRSTUVWXYZ')
    expect(encrypted).to eq('BJELRQZVJWARXSNBXORSTNCFMEYHCXTGYJFLINHNXSHIUNTHEORXOPLOVFEKAGADSPNPCMHRVZCYECDAZIHVYGPITMSRZKGGHLSRBLHL')
  end

  it 'correctly encryptes using 4 plugs' do
    enigma = Enigma.new(
      rotors: [
        Rotor.new(configuration: ConfigurationHelper.rotor_named('III'), starting_position: 'A', ring_setting: 'A'),
        Rotor.new(configuration: ConfigurationHelper.rotor_named('II'), starting_position: 'A', ring_setting: 'A'),
        Rotor.new(configuration: ConfigurationHelper.rotor_named('I'), starting_position: 'A', ring_setting: 'A')
      ],
      plugboard: Plugboard.new(%w[AC FG JY LW]),
      reflector: ConfigurationHelper.reflector_named('B')
    )

    encrypted = enigma.encrypt('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
    expect(encrypted).to eq('QREBNMCYZELKQOJCGJVIVGLYEMUPCURPVPUMDIWXPPWROOQEGI')
  end
end
