require "sinatra"
require "sinatra/json"
require "sprockets"
require 'coffee_script'
require 'handlebars_assets'
require 'twitter'
require 'csv'
require 'htmlentities'
require "retryable"

module AssetHelpers
  def asset_path(source)
    "/assets/" + settings.sprockets.find_asset(source).digest_path
  end

  def self.configure!(sprockets, root)
    HandlebarsAssets::Config.ember = true
    %w{ stylesheets javascripts images }.each do |type|
      sprockets.append_path(File.join(root, 'assets', type))
      sprockets.append_path(File.join(root, 'vendor', type))
    end
    sprockets.context_class.instance_eval do
      include AssetHelpers
    end
  end
end

class OptiCal::App < Sinatra::Base
  TWEET_HEADINGS = %w[ id posted_at screenname text ]

  helpers Sinatra::JSON

  set :root, File.expand_path('../../../', __FILE__)
  set :sprockets, Sprockets::Environment.new(root)

  configure do
    AssetHelpers.configure! sprockets, root
  end

  configure :development do
    require 'rack-livereload'
    use Rack::LiveReload
  end

  configure :production do
    sprockets.js_compressor = :uglifier
    sprockets.css_compressor = :scss
  end

  helpers do
    include AssetHelpers
  end

  get "/" do
    erb :layout
  end

  get "/:screenname" do
    erb :layout
  end

  get "/calendars/:screenname" do
    tweets = get_timeline_tweets(params[:screenname].to_s)
    data = tweets.map do |tweet|
      posted_at = tweet.send(:created_at).utc.strftime("%Y-%m-%d")
      text = HTMLEntities.new.decode(tweet.full_text)
      { id: tweet.id, posted_at: posted_at, text: text }
    end
    json calendar: { id: tweets.first.from_user, screenname: tweets.first.from_user, data: data }
  end

  private

  MAX_NUM_TOTAL = 700
  MAX_NUM_RESULTS = 200

  def get_timeline_tweets(screenname)
    opts = {}
    count = MAX_NUM_TOTAL
    opts[:count] = MAX_NUM_RESULTS
    collect_with_max_id do |max_id|
      opts[:max_id] = max_id unless max_id.nil?
      if count > 0
        tweets = Twitter.user_timeline(screenname, opts)
        count -= tweets.length
        tweets
      end
    end.flatten.compact
  end

  def collect_with_max_id(collection=[], max_id=nil, &block)
    tweets = retryable(:tries => 3, :on => Twitter::Error::ServerError, :sleep => 0) do
      yield(max_id)
    end
    return collection if tweets.nil?
    collection += tweets
    tweets.empty? ? collection.flatten : collect_with_max_id(collection, tweets.last.id - 1, &block)
  end
end
