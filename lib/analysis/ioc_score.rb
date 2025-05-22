# frozen_string_literal: true

class IocScore
  class << self
    def calculate(letter_indexes)
      histogram = Array.new(26, 0)

      letter_indexes.each do |index|
        histogram[index] += 1
      end

      n = letter_indexes.length
      total = 0.0

      histogram.each do |v|
        total += v * (v - 1)
      end

      n > 1 ? total / (n * (n - 1)).to_f : 0.0
    end
  end
end
