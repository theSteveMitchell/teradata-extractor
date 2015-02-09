# teradata-extractor
Get your data from Teradata AND GET TO THE CHOPPER!

A pretty thin wrapper around the jdbc-teradata driver that encapsulates the ugly java bits and gives you back a nice ruby enumerable thing.  Because you don't want to get out of Java Territory as soon as you can.

# usage

```ruby
#Gemfile
gem 'teradata-extractor'
```

```console
bundle install
```

```ruby 
chopper = RubyExtractor.new({server_name: 'skynet-td.com' user:  "Dutch" password: "DillionIsAJerk123"

results = 






