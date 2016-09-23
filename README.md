# LifeGuard

The intention is to manipulate the ActiveRecord connection pool with Rack middleware. A caveat here is that a cleaner solution would be using differently configured instances routed through nginx or another HTTP frontend, but depending on your circumstances and deployment this might be a solution that works for you. Right now this gem is intended for ActiveRecord 4 and up, although it could be made to work with ActiveRecord 3. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'life_guard'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install life_guard

## Usage

  This is a Rack middleware and although the the target platform is Rails, you could theoretically use this in Sinatra or other compatible web framework. Currently the code routes the target ActiveRecord database via a specified HTTP header. An untrusted client could strip or craft headers, so keep in mind you would need to enforce any read/write restrictions to a given database at a different layer of your application.

  For Rails, you'll want to add the following to your `config/application.rb`:

  ```
  Rails.application.middleware.insert_before ActionDispatch::Callbacks, LifeGuard::Rack, life_guard_options
  ```

  where `life_guard_options` is a hash of the following form:

  ```
  { :failure_message => "Something totally went wrong",
    :header => "HEADER_NAME", :transformation => dbproc}
  ```

  `:header` could be something like `HTTP_REFERER`. For information on the options available to you refer to the [Rack spec](http://www.rubydoc.info/github/rack/rack/file/SPEC)

  `dbproc` would reference a function that would allow you to modify the ActiveRecord configuration for your environment to suit your needs. This function takes two arguments: the default configuration and the value of the header specified in the `life_guard_options`. The options are what you typically specify in your `database.yml` - You can find more about that [here](http://guides.rubyonrails.org/configuring.html#configuring-a-database), but the function might look something like this:

  ```  
  dbproc = Proc.new do |config, header|
    database_regex = %r|^(?:https?://)?([^-.:]+)|
    if header.match(database_regex).try('[]',1) == "foo"
      config['database'] = "foo_stats"
    end
  end
  ```

  which would let you route referred requests from a host starting with `foo` to the `foo_stats` database.

  Finally, as a fallback if your function produces an invalid database connection, that gets rescued and a 404 is returned, although you're advised to make your function only capable of modifying the configuration in a valid way in any kind of non-private environment.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/life_guard/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

This gem is released under the [MIT License](http://www.opensource.org/licenses/MIT).
https://opensource.org/licenses/MIT
