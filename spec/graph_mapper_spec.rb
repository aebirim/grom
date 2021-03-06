require 'spec_helper'

describe Grom::GraphMapper do
  let(:extended_class) { Class.new { extend Grom::GraphMapper } }
  let(:through_split_graph_result) { extended_class.through_split_graph(BLANK_PARTY_MEMBERSHIP_TTL_BY_PARTY) }

  describe '#get_id' do
    it 'should return the id if given a uri' do
      expect(extended_class.get_id(RDF::URI.new('http://id.example.com/123'))).to eq '123'
    end

    it 'should return "type" if given an RDF.type uri' do
      expect(extended_class.get_id(RDF.type)).to eq 'type'
    end
  end

  describe '#create_hash_from_ttl' do

    it 'should create an array of hash representations from ttl statements' do
      result = extended_class.create_hash_from_ttl(PEOPLE_TTL)
      expect(result[0][:id]).to eq '1'
      expect(result[0][:forename]).to eq 'Daenerys'
      expect(result[0][:surname]).to eq 'Targaryen'
      expect(result[0][:middleName]).to eq 'Khaleesi'
      expect(result[0][:dateOfBirth]).to eq '1947-06-29'
      expect(result[1][:id]).to eq '2'
      expect(result[1][:forename]).to eq 'Arya'
      expect(result[1][:surname]).to eq 'Stark'
      expect(result[1][:middleName]).to eq 'The Blind Girl'
      expect(result[1][:dateOfBirth]).to eq '1954-01-12'
    end

    it 'should create an array of hash representations from ttl statements with apostrophes in the ttl' do
      result = extended_class.create_hash_from_ttl(DOGS_TTL)
      expect(result[0][:id]).to eq '1863'
      expect(result[0][:name]).to eq "B'uddy"
      expect(result[1][:id]).to eq '1866'
      expect(result[1][:name]).to eq "F'ido"
    end
  end

  describe '#statement_mapper' do
    it 'should build a hash representation from a given statement in rdf format with the subject as key' do
      result = {}
      extended_class.statement_mapper(ONE_STATEMENT_STUB, result)
      expect(result["1"][:id]).to eq '1'
      expect(result["1"][:forename]).to eq 'Daenerys'
    end

    it 'should build a hash representation from a given statement with an apostrophe in the name' do
      result = {}
      extended_class.statement_mapper(BUDDY_STATEMENT, result)
      expect(result["1863"][:id]).to eq '1863'
      expect(result["1863"][:name]).to eq "B'uddy"
    end
  end

  describe '#through_split_graph' do
    it 'should return the associated hash containing the first party' do
      expect(through_split_graph_result[:associated_class_hash]["23"][:partyName]).to eq 'Targaryens'
    end

    it 'should return the associated hash containing the second party' do
      expect(through_split_graph_result[:associated_class_hash]["26"][:partyName]).to eq 'Dothrakis'
    end

    it 'should return the through class hash containing the first party membership associated with the first party' do
      expect(through_split_graph_result[:through_class_hash]["_:node123"][:associated_object_id]).to eq '23'
      expect(through_split_graph_result[:through_class_hash]["_:node123"][:partyMembershipStartDate]).to eq '1953-01-12'
      expect(through_split_graph_result[:through_class_hash]["_:node123"][:partyMembershipEndDate]).to eq '1954-01-12'
    end

    it 'should return the through class hash containing the second party membership associated with the second party' do
      expect(through_split_graph_result[:through_class_hash]["_:node124"][:associated_object_id]).to eq '26'
      expect(through_split_graph_result[:through_class_hash]["_:node124"][:partyMembershipStartDate]).to eq '1954-01-12'
      expect(through_split_graph_result[:through_class_hash]["_:node124"][:partyMembershipEndDate]).to eq '1955-03-11'
    end
  end

end