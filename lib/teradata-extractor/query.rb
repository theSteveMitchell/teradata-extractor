require 'csv'

module TeradataExtractor
  class Query
  
    # @param [com.teradata.jdbc.jdk6.JDK6_SQL_Connection] Teradata connection
    # @param [#to_s] sql Sql query to execute
    def initialize(server_name, username, password)

      @connection = TeradataExtractor::Connection.instance.connection(server_name, username, password)
      @statement ||= @connection.create_statement
    end

    def to_enumerable(sql) 
      results = @statement.execute_query(sql)
      #results = conn.execute_query("select TOP 10 country_id, sf_account_id, country_name from emea_analytics.eu_deal_flat")
      e = Enumerator.new do |y|
        column_count = results.getMetaData.getColumnCount;
        while(results.next) do
          row = {}
          1.upto(column_count) do |i|
            column_name = results.getMetaData.getColumnName(i).to_sym
            row[column_name] = results.getObject(i)
          end
          y << row
        end
      end
    end

    def to_csv(sql)
      results = @statement.execute_query(sql)
      #results = conn.execute_query("select TOP 10 country_id, sf_account_id, country_name from emea_analytics.eu_deal_flat")
      CSV.generate do |csv|
        column_count = results.getMetaData.getColumnCount;
        csv << 1.upto(column_count).map{|i| results.getMetaData.getColumnName(i)}

        while(results.next) do
          row = []
          1.upto(column_count) do |i|
            row << results.getObject(i)
          end
          csv << row
        end
      end
    end
  end
end
