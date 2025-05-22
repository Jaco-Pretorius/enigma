# frozen_string_literal: true

require_relative '../lib/alphabet_helper'
require_relative '../lib/analysis/ioc_score'

RSpec.describe 'Analysis Functions' do
  it 'calculates index of Coincidence' do
    input = <<-TEXT
      To be, or not to be, that is the question—
      Whether 'tis Nobler in the mind to suffer
      The Slings and Arrows of outrageous Fortune,
      Or to take Arms against a Sea of troubles,
      And by opposing end them?
      William Shakespeare - Hamlet
    TEXT

    sanitized_input = AlphabetHelper.sanitize(input)
    score = IocScore.calculate(AlphabetHelper.word_to_indexes(sanitized_input))
    expect(score.round(5)).to eq(0.06773)
  end
end
