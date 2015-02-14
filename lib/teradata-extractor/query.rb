require 'csv'

module TeradataExtractor
  class Query
  
    # @param [com.teradata.jdbc.jdk6.JDK6_SQL_Connection] Teradata connection
    # @param [#to_s] sql Sql query to execute
    def initialize(server_name, username, password)
      @connection = TeradataExtractor::Connection.instance.connection(server_name, username, password)
      @statement ||= @connection.create_statement
    end

    # returns an enumerable, each element of which is a hash in the format {column1: value1, column2: value2}
    def enumerable(sql)
      results = @statement.execute_query(sql)

      Enumerator.new do |y|
        column_count = results.get_meta_data.get_column_count
        while(results.next) do
          row = {}
          1.upto(column_count) do |i|
            column_name = results.get_meta_data.get_column_name(i).to_sym
            row[column_name] = to_ruby_type(results.get_object(i))
          end
          y << row
        end
      end
    end

    # returns an array of column names, and an enumberator, 
    # each item of the enumerator contains a single StringIO object, the value
    # of which is a CSV string containing [step] rows.
    def csv_sting_io(sql, step=1000)
      results = @statement.execute_query(sql)
      #results = conn.execute_query("select TOP 10 country_id, sf_account_id, country_name from emea_analytics.eu_deal_flat")
      column_count = results.get_meta_data.get_column_count
      headers = 1.upto(column_count).map{|i| results.get_meta_data.get_column_name(i)}

      enum = Enumerator.new do |y|
        loop do
          rows = []
          csv_string = CSV.generate do |csv|
            step.times do
              results.next
              values = 1.upto(column_count).map{|i| to_ruby_type(results.get_object(i)) }
              csv << values
            end
          end
          y << StringIO.new(csv_string)
        end
      end

      return [headers, enum]
    end

  protected

    def to_ruby_type(java_object)
      if java_object.is_a?(Java::JavaMath::BigDecimal)
        return java_object.to_string.to_i
      elsif java_object.is_a?(Java::JavaSql::Date)
        return Date.parse(java_object.to_string)
      else
        return java_object
      end
    end

  end
end
