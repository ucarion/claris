require 'httparty'
require 'json'
require 'nokogiri'

module Wikipedia
  class << self
    APPLICATION_NAME = 'JarvisBot (ulysse@ulysse.io)'
    BASE_URL = 'http://en.wikipedia.org/w/api.php'

    def article_summary(article_name)
      opts = {
        action: :query,
        prop: :extracts,
        titles: article_name,
        exintro: true,
        exsectionformat: :plain,
        format: :json
      }

      response = send_get_request(opts)
      introduction = response['query']['pages'].values.first['extract']

      Nokogiri::HTML(introduction).css('p').first.text
    end

    def search_articles(query)
      opts = {
        action: :query,
        list: :search,
        srsearch: query,
        format: :json
      }

      response = send_get_request(opts)
      response['query']['search'].map { |result| result['title'] }
    end

    private

    def send_get_request(options)
      response = HTTParty.get(BASE_URL, query: options, headers: {
        'User-Agent' => APPLICATION_NAME
      })

      JSON.parse(response.body)
    end
  end
end
