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

  it 'correctly encrypts using varied motors' do
    enigma = Enigma.new(
      rotors: [
        Rotor.new(configuration: ConfigurationHelper.rotor_named('IV'),
                  starting_position: AlphabetHelper.index_to_letter(12), ring_setting: AlphabetHelper.index_to_letter(3)),
        Rotor.new(configuration: ConfigurationHelper.rotor_named('V'),
                  starting_position: AlphabetHelper.index_to_letter(5), ring_setting: AlphabetHelper.index_to_letter(2)),
        Rotor.new(configuration: ConfigurationHelper.rotor_named('VII'),
                  starting_position: AlphabetHelper.index_to_letter(10), ring_setting: AlphabetHelper.index_to_letter(1))
      ],
      plugboard: Plugboard.new([]),
      reflector: ConfigurationHelper.reflector_named('B')
    )
    encrypted = enigma.encrypt('ABCDEFGHIJKLMNOPQRSTUVWXYZAAAAAAAAAAAAAAAAAAAAAAAAAABBBBBBBBBBBBBBBBBBBBBBBBBBABCDEFGHIJKLMNOPQRSTUVWXYZ')
    expect(encrypted).to eq('FOTYBPKLBZQSGZBOPUFYPFUSETWKNQQHVNHLKJZZZKHUBEJLGVUNIOYSDTEZJQHHAOYYZSENTGXNJCHEDFHQUCGCGJBURNSEDZSEPLQP')
  end

  it 'correctly encrypts long input' do
    enigma = Enigma.new(
      rotors: [
        Rotor.new(configuration: ConfigurationHelper.rotor_named('VIII'),
                  starting_position: AlphabetHelper.index_to_letter(9), ring_setting: AlphabetHelper.index_to_letter(19)),
        Rotor.new(configuration: ConfigurationHelper.rotor_named('VI'),
                  starting_position: AlphabetHelper.index_to_letter(5), ring_setting: AlphabetHelper.index_to_letter(13)),
        Rotor.new(configuration: ConfigurationHelper.rotor_named('III'),
                  starting_position: AlphabetHelper.index_to_letter(3), ring_setting: AlphabetHelper.index_to_letter(11))
      ],
      plugboard: Plugboard.new([]),
      reflector: ConfigurationHelper.reflector_named('B')
    )

    ciphertext = enigma.encrypt('A' * 500)
    output = 'YJKJMFQKPCUOCKTEZQVXYZJWJFROVJMWJVXRCQYFCUVBRELVHRWGPYGCHVLBVJEVTTYVMWKJFOZHLJEXYXRDBEVEHVXKQSBPYZN' +
             'IQDCBGTDDWZQWLHIBQNTYPIEBMNINNGMUPPGLSZCBRJULOLNJSOEDLOBXXGEVTKCOTTLDZPHBUFKLWSFSRKOMXKZELBDJNRUDUCO' +
             'TNCGLIKVKMHHCYDEKFNOECFBWRIEFQQUFXKKGNTSTVHVITVHDFKIJIHOGMDSQUFMZCGGFZMJUKGDNDSNSJKWKENIRQKSUUHJYMIG' +
             'WWNMIESFRCVIBFSOUCLBYEEHMESHSGFDESQZJLTORNFBIFUWIFJTOPVMFQCFCFPYZOJFQRFQZTTTOECTDOOYTGVKEWPSZGHCTQRP' +
             'GZQOVTTOIEGGHEFDOVSUQLLGNOOWGLCLOWSISUGSVIHWCMSIUUSBWQIGWEWRKQFQQRZHMQJNKQTJFDIJYHDFCWTHXUOOCVRCVYOHL'
    expect(ciphertext).to eq(output)
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

  it 'correctly encryptes using 6 plugs' do
    enigma = Enigma.new(
      rotors: [
        Rotor.new(configuration: ConfigurationHelper.rotor_named('III'),
                  starting_position: AlphabetHelper.index_to_letter(6), ring_setting: 'A'),
        Rotor.new(configuration: ConfigurationHelper.rotor_named('VI'),
                  starting_position: AlphabetHelper.index_to_letter(10), ring_setting: 'A'),
        Rotor.new(configuration: ConfigurationHelper.rotor_named('IV'),
                  starting_position: AlphabetHelper.index_to_letter(0), ring_setting: 'A')
      ],
      plugboard: Plugboard.new(%w[BM DH RS KN GZ FQ]),
      reflector: ConfigurationHelper.reflector_named('B')
    )

    encrypted = enigma.encrypt('WRBHFRROSFHBCHVBENQFAGNYCGCRSTQYAJNROJAKVKXAHGUZHZVKWUTDGMBMSCYQSKABUGRVMIUOWAPKCMHYCRTSDEYTNJLVWNQY')
    expect(encrypted).to eq('FYTIDQIBHDONUPAUVPNKILDHDJGCWFVMJUFNJSFYZTSPITBURMCJEEAMZAZIJMZAVFCTYTKYORHYDDSXHBLQWPJBMSSWIPSWLENZ')
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

  it 'correctly handles the double-stepping of the middle rotor' do
    # From https://cryptii.com/pipes/enigma-machine
    enigma = Enigma.new(
      rotors: [
        Rotor.new(configuration: ConfigurationHelper.rotor_named('III'),
                  starting_position: 'Q', ring_setting: 'A'),
        Rotor.new(configuration: ConfigurationHelper.rotor_named('II'),
                  starting_position: 'E', ring_setting: 'A'),
        Rotor.new(configuration: ConfigurationHelper.rotor_named('I'),
                  starting_position: 'V', ring_setting: 'A')
      ],
      plugboard: Plugboard.new([]),
      reflector: ConfigurationHelper.reflector_named('B')
    )
    encrypted = enigma.encrypt('THISISADOUBLESTEPPINGEXAMPLE')
    expect(encrypted).to eq('MADORQIFXDHODMADHZKRXIJXFZET')
  end
end
