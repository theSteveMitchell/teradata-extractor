require 'java'
include_class 'java.sql.ResultSet'

# HashResultSet is a lightweight implementation of Java::JavaSql::ResultSet for testing.
# Internally it's implemented with an enumerator for simplicity.
# behavior characteristics are consistent with Java::JavaSql::ResultSet:
# 1. column names are accessed through a SqlResultSetMetaData object
# 2. the "cursor position" is conceptually at the end of a row, so you must call "next" before retreiving the first row
# 3. calling "next" when there are no more rows will return false (not raise)
# 4. row indexes and column indexes on the metadata object are 1-based.
class HashResultSet
  include Java::JavaSql::ResultSet

  # results is an aray of hashes.
  def initialize(results)
    @results = Enumerator.new(results)
    # ResultSet places a cursor at the end of a row, so you must call next before fetching 
    @position = 0
  end

  def get_meta_data()
    CachedResultSetMetaData.new(@results)
  end

  # ResultSet requires a call to next before fetching first row.
  def next
    if @position > @results.count-1
      return false
    end

    if @position > 0
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
  include Java::JavaSql::ResultSetMetaData

  def initialize(results)
    @results = results
  end

  def get_column_count
    @results.peek.count
  end

  def get_column_name(i)
    # ResultSetMetaData has 1-based indices
    @results.peek.keys[i-1]
  end

  def get_column_names
    @results.peek.keys
  end

end
