require 'em-twitter'
require 'pubnub'

$stdout.sync = true

EM::run do

  pubnub = Pubnub.new(
    :publish_key => ENV['PUBNUB_PUBLISH_KEY'],
    :subscribe_key => ENV['PUBNUB_SUBSCRIBE_KEY']
  )

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
    pub_callback = lambda { |envelope| puts(envelope.msg) }

    pubnub.publish(
      channel: ENV['PUBNUB_CHANNEL'],
      message: result,
      callback: pub_callback
    )
  end
end
