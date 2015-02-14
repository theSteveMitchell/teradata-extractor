describe TeradataExtractor::Query do

  let(:result_set) {
    HashResultSet.new([
        {id: "12345CDX4", units_sold: 77545733, dollars: 12, refund_percentage: 44, address: "123 fake Street"},
        {id: "12345CDX5", units_sold: 12, dollars: 8, refund_percentage: 99, address: "456 real Street"}
      ])
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
      ).to eq result_set.to_a
    end

  end

end

