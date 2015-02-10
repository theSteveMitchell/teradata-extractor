require 'singleton'
require 'jdbc/teradata'

module TeradataExtractor
  class Connection
    include Singleton

    def connection(server_name, username, password)
      Jdbc::Teradata.load_driver
      import Java::com.teradata.jdbc.TeraDriver
      teradataurl = "jdbc:teradata://#{server_name}/CHARSET=UTF8,TMODE=ANSI"
      java.sql.DriverManager.get_connection(teradataurl, username, password)
    end
  end
end
