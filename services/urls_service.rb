# frozen_string_literal: true

class UrlsService
  URLS_KEY = 'visited_urls'

  def initialize
    @redis = Redis.new
  end

  def add_urls(links_arr)
    timestamp = Time.now.to_i
    links_arr
      .select { |url| valid_url?(url) }
      .each { |link| @redis.zadd(URLS_KEY, 0, "#{timestamp}|#{link}") }
  end

  def uniq_domains(from, to)
    urls_from_redis(from, to)
      .map { |el| el.split('|')[1] }
      .map do |url|
        url = "http://#{url}" unless url.start_with?('http')
        URI.parse(url).host
      end
      .uniq
  end

  private

  def urls_from_redis(from, to)
    @redis.zrangebylex(URLS_KEY, "[#{from.to_i}", "(#{to.to_i + 1}")
  end

  def valid_url?(url)
    return false unless url

    url = "http://#{url}" unless url.start_with?('http')

    uri = URI.parse(url)
    (uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)) && !uri.host.nil?
  end
end
