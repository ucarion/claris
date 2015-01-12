require 'wolfram'

Wolfram.appid = ENV['WOLFRAM_APP_ID']

module WolframUtil
  def self.calculate(query)
    result = Wolfram.fetch(query)
    as_hash = Wolfram::HashPresenter.new(result).to_hash

    as_hash[:pods]['Result']
  end
end
