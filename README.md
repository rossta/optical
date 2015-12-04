# OptiCal

A visual history of tweet frequency

![optical](optical.png)

Visit [OptiCal](http://opticalfuzz.herokuapp.com/) and enter a Twitter handle.

Lovingly crafted with [ember.js](http://emberjs.com/), [d3.js](http://d3js.org/), [twitter](https://github.com/sferik/twitter), and [sinatra](http://www.sinatrarb.com/).

More on [Devpost](http://devpost.com/software/optical)!

## Development

Clone the project:

```
$ git clone https://github.com/rossta/optical.git && cd optical && bundle
```
Running OptiCal currently requires Ruby 2.2.2, Ruby's Bundler gem, and
credentials for using the Twitter API. Create a [new Twitter
app](https://apps.twitter.com/) to generate the necessary access keys and
tokens. Optical (via the Twitter gem) will pick these up when exported as
environment variables as shown below:

```
$ export TWITTER_CONSUMER_KEY=aaaaaaaaaaaaaaaaaaaaaa
$ export TWITTER_CONSUMER_SECRET=bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
$ export TWITTER_OAUTH_TOKEN=cccccccccccccccccccccccccccccccccccccccccccccccccc
$ export TWITTER_OAUTH_TOKEN_SECRET=dddddddddddddddddddddddddddddddddddddddddd
$ bundle exec thin start # starts the web server
```

You can also install the `foreman` gem which will allow you to run the app with
the `Procfile`:

```
$ gem install foreman
$ foreman start # starts the web server
```

If everything works, you should be able to visit `http://localhost:5000` in your
web browser.
