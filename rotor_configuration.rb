# frozen_string_literal: true

class RotorConfiguration
  class << self
    def from_yaml(hash)
      new(name: hash['name'], wiring: hash['wiring'], notch: hash['notch'])
    end
  end

  attr_reader :name, :wiring, :notch

  def initialize(name:, wiring:, notch:)
    @name = name
    @wiring = wiring
    @notch = notch
  end
end
