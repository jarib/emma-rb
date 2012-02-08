# Emma

Ruby gem wrapping the [EMMA library](http://emma.sourceforge.net/).

## Installation

Add this line to your application's Gemfile:

    gem 'emma'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install emma

## Usage

Instrument a war:

    $ emma-instrument-war --filter "com.example.*" /path/to/some.war

From Ruby:

```ruby
emma = Emma::Control.new(:metadata_file => "coverage.em")
emma.get # connects to the app
emma.report :format => "html"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
