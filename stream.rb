require 'em-twitter'

$stdout.sync = true

EM::run do

  options = {
    :path   => '/1/statuses/filter.json',
    :params => {
      :track            => ENV['TRACK_TERM']
    },
    :oauth  => {
      :consumer_key     => ENV['TWITTER_APP_KEY'],
      :consumer_secret  => ENV['TWITTER_APP_SECRET'],
      :token            => ENV['TWITTER_ACCESS_TOKEN'],
      :token_secret     => ENV['TWITTER_ACCESS_SECRET']
    }
  }

  client = EM::Twitter::Client.connect(options)

  client.each do |result|
    puts result
  end
end
