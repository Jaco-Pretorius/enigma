# frozen_string_literal: true

class ConfigurationHelper
  class << self
    def rotor_named(name)
      ensure_loaded
      @configurations.find { |r| r.name == name }
    end

    def reflector_named(name)
      ensure_loaded
      @reflectors.find { |r| r.name == name }
    end

    private

    def ensure_loaded
      return if @configurations && @reflectors

      data = YAML.load_file('enigma.yml')
      @configurations = data['rotors'].map { |hash| RotorConfiguration.from_yaml(hash) }
      @reflectors = data['reflectors'].map { |hash| Reflector.from_yaml(hash) }
    end
  end
end
