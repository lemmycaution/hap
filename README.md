# Hap

An Interface to help creating multi-server high scalable APIs on Heroku!

Hap is a CLI and a bit much more to manage `App per Resource` APIs powered by Goliath and HaProxy

## Installation

Add this line to your application's Gemfile:

    gem 'hap'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hap

## Usage

Beware!, before start, this gem has not been fully tested on various platforms and i'm using it with ruby 2.0 on mac os x, but designed to work on heroku, so it works on heroku :)

Go and create you firt hap app by running

    $ hap new my_intergalactic_api [--bundle] [--remote]

Ok, get in the directory

    $ cd my_intergalactic_api

Then create the very first endpoint of this little api 

    $ hap endpoint showmeok

Run it locally, then head to localhost:5000/showmeok (!wow!)

   $ hap server	

Well, to deploy this tiny api you need a heroku account and api key, if you have already, run;

    $ hap deploy

Viola! Your highly scalable, haproxy powered multi-app (not dyno!) api deployed!

If you missed the address of you api, you can find all data about heroku apps under deploy directory.

Good luck

Drop me a line if you liked or interested in this, @onuruyar at twitter.

ps: Thanks https://github.com/kiafaldorius/ for his buildpack, it rocks!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
