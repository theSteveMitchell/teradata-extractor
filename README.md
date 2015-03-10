# teradata-extractor
Get your data from Teradata AND GET OUTTA THERE!

A beautifully thin wrapper around the jdbc-teradata driver that encapsulates the ugly java bits and gives you back a nice ruby enumerable thing.  Because you want to get out of Java Territory as soon as you can.

Rather than dealing with java.sql.ResultSets that require awkward parsing and use of metadata, you can just deal with an enumerable hash array, or a CSV string. 

# JRuby only, dawg
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

> #ruby Enumerator
> enum = extractor.enumerable("select Top 2 name, id, email_address, favorite_liquor from td.people_stuff")
=> #<Enumerator: #<JRuby::Generator::Threaded:...>
> enum.to_a
=> [{:name => "Steve", :id => 111, :email_address => "thestevemitchell@gmail.com", :favorite_liquor => "ALL"},
{:name => "Jerry", :id => 231, :email_address => "Jerry@jerrinson.com", :favorite_liquor => "none"}]
> #You get the idea...it's a ruby Enumberable

> #ruby String in CSV format
> headers, rows = extractor.csv_string_io("select Top 2 name, id, email_address, favorite_liquor from td.people_stuff")
=> [[::name, :id, :email_address, :favorite_liquor],
 #<Enumerator: #<JRuby::Generator::Threaded:...>
> rows.class
=> Enumerator
> rows.next
=> "Steve,111,thestevemitchell@gmail.com,ALL\nJerry,231,Jerry@jerrinson.com,none\n"
> #Next returns MORE THAN ONE ROW in CSV format.  See note on fetch_size  
```

## Note on fetch_size

Both #enumerator and #csv_string_io have an optional second parameter, "fetch_size".  When calling #enumerator, fetch_size is purely a performance concern.  The enumerator returned will still yeild only 1 row when iterated using enum.next.  Fetch size is an instruction to the Teradata resultSet object that tells it how many results it should fetch from the database at a time.

When calling #csv_string_io, fetch_size is significant.  For convenience, #csv_string_io bundles rows into groups.  So each call to rows.next will yeild a StringIO representing 1000 rows by default.  If you like you can pass fetch_size of 1 to get a single row at a time.  But if you're using something like https://github.com/theSteveMitchell/postgres_upsert, getting rows in a group is much more efficient, and convenient.  You can just...

```ruby 
extractor = TeradataExtractor::Query.new(server_name, user_name, password)
headers, enum = extractor.csv_string_io("select name, id, email_address, favorite_liquor from td.people_stuff")
enum.each do |csv_stringio|
  Person.pg_upsert(csv_stringio, {header: false, columns: headers})
end
```

## Note on Patches/Pull Requests

* Fork the project
* add your feature/fix to your fork(specs please)
* submit a PR
* Lay back and bask in the karma you've earned.  
* If you find an issue but can't fix in in a PR, please log an issue.  I'll do my best.






