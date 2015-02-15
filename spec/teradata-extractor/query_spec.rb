describe TeradataExtractor::Query do

  let(:result_set) {
    HashResultSet.new([
         {id: "12345CDX4", units_sold: Java::JavaMath::BigDecimal.value_of(77545733.33), dollars: Java::JavaMath::BigDecimal.value_of(12), sale_date: Java::JavaSql::Date.value_of("2012-02-07"), address: "123 fake Street"},
         {id: "12345CDX5", units_sold: Java::JavaMath::BigDecimal.value_of(12), dollars: Java::JavaMath::BigDecimal.value_of(8), sale_date: Java::JavaSql::Date.value_of("2015-01-05"), address: "456 real Street"}
      ])
  }

  let(:rubified_result_set) {
    [
         {id: "12345CDX4", units_sold: 77545733.33, dollars: 12, sale_date: Date.parse("2012-02-07"), address: "123 fake Street"},
         {id: "12345CDX5", units_sold: 12, dollars: 8, sale_date: Date.parse("2015-01-05"), address: "456 real Street"}
    ]
  }

  before do
    statement = double("statement")
    allow(statement).to receive_messages(:execute_query => result_set)

    connection = double("connection")
    allow(connection).to receive_messages(:create_statement => statement)

    allow(TeradataExtractor::Connection).to receive_message_chain(:instance, :connection).and_return(connection)
  end

  describe "#enumerable" do
    it 'returns an enumerable' do
      expect(
        TeradataExtractor::Query.new(nil,nil,nil).enumerable("")
      ).to be_a(Enumerator)
    end

    it 'contains the correct values from the ResultSet' do
      expect(
        TeradataExtractor::Query.new(nil,nil,nil).enumerable("").to_a
      ).to eq rubified_result_set.to_a
    end

    it 'never yeilds more than the actual number of results' do
      result = TeradataExtractor::Query.new(nil,nil,nil).enumerable("")

      expect(
        result.next
      ).to eq(rubified_result_set[0])

      expect(
        result.next
      ).to eq(rubified_result_set[1])

      expect{
        result.next
      }.to raise_error StopIteration
    end

    context 'data type conversion' do

      before do
        result_set = HashResultSet.new([
              {id: "12345CDX4", units_sold: Java::JavaMath::BigDecimal.value_of(77545733.33), dollars: Java::JavaMath::BigDecimal.value_of(12), sale_date: Java::JavaSql::Date.value_of("2012-02-07"), address: "123 fake Street"},
              {id: "12345CDX5", units_sold: Java::JavaMath::BigDecimal.value_of(12), dollars: Java::JavaMath::BigDecimal.value_of(8), sale_date: Java::JavaSql::Date.value_of("2015-01-05"), address: "456 real Street"}
            ])
      end

      it 'politely manages java datatypes' do
        result = TeradataExtractor::Query.new(nil,nil,nil).enumerable("").to_a

        expect(
          result
        ).to eq(rubified_result_set)

      end
    end

  end

  describe '#csv_string_io' do
    it 'returns an array with headers, enum' do
      expect(
        TeradataExtractor::Query.new(nil,nil,nil).csv_string_io("")
      ).to be_a(Array)
    end

    it 'returns the correct headers array' do
      result = TeradataExtractor::Query.new(nil,nil,nil).csv_string_io("")
      expect(
        result[0]
      ).to eq [:id, :units_sold, :dollars, :sale_date, :address]
    end

    it 'respresents the rows as a string' do
      result = TeradataExtractor::Query.new(nil,nil,nil).csv_string_io("")

      expect(
        result[1].next.string
      ).to eq "12345CDX4,77545733.33,12,2012-02-07,123 fake Street\n12345CDX5,12,8,2015-01-05,456 real Street\n"
    end

    it 'supports custom step size/rows per yeild' do
      result = TeradataExtractor::Query.new(nil,nil,nil).csv_string_io("", 1)

      expect(
        result[1].next.string
      ).to eq "12345CDX4,77545733.33,12,2012-02-07,123 fake Street\n"

      expect(
        result[1].next.string
      ).to eq "12345CDX5,12,8,2015-01-05,456 real Street\n"
    end

    it 'never yeilds more than the actual number of results' do
      result = TeradataExtractor::Query.new(nil,nil,nil).csv_string_io("", 100)

      expect(
        result[1].next.string
      ).to eq "12345CDX4,77545733.33,12,2012-02-07,123 fake Street\n12345CDX5,12,8,2015-01-05,456 real Street\n"

      expect{
        result[1].next
      }.to raise_error StopIteration
    end
  end

end

