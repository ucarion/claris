require 'wolfram'

Wolfram.appid = '8LP92V-AP4WW9G5J3'

module WolframUtil
  def self.calculate(query)
    result = Wolfram.fetch(query)
    as_hash = Wolfram::HashPresenter.new(result).to_hash

    as_hash[:pods]['Result']
  end
end
