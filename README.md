# teradata-extractor
Get your data from Teradata AND GET OUTTA THERE!

A beautifully thin wrapper around the jdbc-teradata driver that encapsulates the ugly java bits and gives you back a nice ruby enumerable thing.  Because you want to get out of Java Territory as soon as you can.

# compatibility note
Since connecting to Teradata from MRI ruby is not really a thing yet, this gem wraps jdbc-teradata, which of course only runs on JRuby.

# usage

```ruby
#Gemfile
gem 'teradata-extractor'
```

```console
bundle install
```

```ruby 
extractor = TeradataExtractor::Query.new("server_name", "user", "password")

#ruby Enumerator
enum = extractor.to_enumerable("select Top 2 name, id, email_address, favorite_liquor from td.people_stuff")
=> #<Enumerator: #<JRuby::Generator::Threaded:...>
enum.to_a
=> [{:name => "Steve", :id => 111, :email_address => "thestevemitchell@gmail.com", :favorite_liquor => "ALL"},
{:name => "Jerry", :id => 231, :email_address => "Jerry@jerrinson.com", :favorite_liquor => "none"}]
#You get the idea...it's a ruby Enumberable

#ruby String in CSV format (take a look at postgres_upsert)
csv = extractor.to_enumerable("select Top 2 name, id, email_address, favorite_liquor from td.people_stuff")
=> "name,id,email_address,favorite_liquor\nSteve,111,thestevemitchell@gmail.com,ALL\nJerry,231,Jerry@jerrinson.com,none\n"
```

## Note on Patches/Pull Requests

* Fork the project
* add your feature/fix to your fork(rpsec tests pleaze)
* submit a PR
* Do something nice for a stranger
* If you find an issue but can't fix in in a PR, please log an issue.  I'll do my best.






