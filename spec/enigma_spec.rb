require_relative '../enigma'

RSpec.describe Enigma do
  it 'correctly encryptes using basic settings' do
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
end
