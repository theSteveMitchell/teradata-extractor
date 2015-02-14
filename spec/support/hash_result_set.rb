require 'java'
include_class 'java.sql.ResultSet'

class HashResultSet
  include Java::JavaSql::ResultSet

  # results is an aray of hashes.
  def initialize(results)
    @results = Enumerator.new(results)
    # ResultSet places a cursor at the end of a row, so you must call next before fetching 
    @position = 1
  end

  def get_meta_data()
    CachedResultSetMetaData.new(@results)
  end

  # ResultSet requires a call to next before fetching first row.
  def next
    if @position > @results.count
      return false
    end

    if @position > 1
      @results.next
    end

    @position += 1
    return true
  end

  def get_object(i)
    hash = @results.peek
    # ResultSet has 1-based indices
    key = hash.keys[i-1]
    hash[key]
  end

  # anything outside the scope we pass to enumerable.
  def method_missing(m, *args)
    @results.send(m)
  end

end

class CachedResultSetMetaData
  def initialize(results)
    @results = results
  end

  def get_column_count
    @results.first.count
  end

  def get_column_name(i)
    # ResultSet has 1-based indices
    @results.first.keys[i-1]
  end

  def get_column_names
    @results.first.keys
  end

end
