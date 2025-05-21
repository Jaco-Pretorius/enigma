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

  it 'correctly encryptes using 10 plugs' do
    enigma = Enigma.new(
      rotors: [
        Rotor.new(configuration: ConfigurationHelper.rotor_named('III'),
                  starting_position: AlphabetHelper.index_to_letter(20), ring_setting: AlphabetHelper.index_to_letter(4)),
        Rotor.new(configuration: ConfigurationHelper.rotor_named('II'),
                  starting_position: AlphabetHelper.index_to_letter(1), ring_setting: AlphabetHelper.index_to_letter(5)),
        Rotor.new(configuration: ConfigurationHelper.rotor_named('I'),
                  starting_position: AlphabetHelper.index_to_letter(0), ring_setting: AlphabetHelper.index_to_letter(5))
      ],
      plugboard: Plugboard.new(%w[AG HR YT KI FL WE NM SD OP QJ]),
      reflector: ConfigurationHelper.reflector_named('B')
    )

    encrypted = enigma.encrypt('RNXYAZUYTFNQFMBOLNYNYBUYPMWJUQSBYRHPOIRKQSIKBKEKEAJUNNVGUQDODVFQZHASHMQIHSQXICTSJNAUVZYIHVBBARPJADRH')
    expect(encrypted).to eq('CFBJTPYXROYGGVTGBUTEBURBXNUZGGRALBNXIQHVBFWPLZQSCEZWTAWCKKPRSWOGNYXLCOTQAWDRRKBCADTKZGPWSTNYIJGLVIUQ')
  end
end
