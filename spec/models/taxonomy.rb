require 'spec_helper'

RSpec.describe TaxonomyClient::Taxonomy do
  let(:valid_item) { 
    {"tax_id"=>"123", "scientific_name"=>"Bubidu Bubidus"} 
  }
  let(:valid_item2) { 
    {"tax_id"=>"124", "scientific_name"=>"Bubidu Vubidus"} 
  }  
  let(:valid_array_response) {
    instance_double("Faraday::Response", body: [ valid_item, valid_item2])
  }
  let(:valid_single_response) {
    instance_double("Faraday::Response", body: valid_item )
  }


  context '#new' do
    it 'can be instantiated with dynamic attributes' do
      taxonomy = described_class.new(bubidu: 'bubidus', common_name: 'Bubidu Bubidus')

      expect(taxonomy.bubidu).to eql('bubidus')
      expect(taxonomy.common_name).to eql('Bubidu Bubidus')
    end
  end

  context '#find' do
    it 'can retrieve a model with a given tax id' do
      allow(described_class.connection).to receive(:run).and_return(valid_single_response)

      m = described_class.find(123)
      expect(m).to be_instance_of(described_class)
      expect(m.tax_id).to eq(valid_single_response.body["tax_id"])
      expect(m.scientific_name).to eq(valid_single_response.body["scientific_name"])
    end
  end

  context '#find_by_scientific_name' do
    it 'finds by scientific name' do
      expect(described_class).to receive(:find_by_field).with('scientific-name', "Bubidu")
      described_class.find_by_scientific_name("Bubidu")
    end
  end

  context '#suggest_for_search' do
    it 'finds by suggest' do
      expect(described_class).to receive(:find_by_field).with('suggest-for-search', "Bubidu")
      described_class.suggest_for_search("Bubidu")
    end
  end  

  context '#find_by_tax_id' do
    it 'finds by tax id' do
      expect(described_class).to receive(:find_by_field).with('tax-id', 1)
      described_class.find_by_tax_id(1)
    end
  end

  context '#find_by_field' do
    let(:field) { 'tax-id'}
    let(:value) { '123' }

    context 'when only one element is returned in the request' do
      it 'can get the model' do
        allow(described_class.connection).to receive(:run).and_return(valid_single_response)

        m = described_class.find_by_field(field, value)
        expect(m).to be_instance_of(described_class)
        expect(m.tax_id).to eq '123'
      end
    end
    context 'when more than one element is returned in the request' do
      it 'can get the array of models' do
        allow(described_class.connection).to receive(:run).and_return(valid_array_response)

        m = described_class.find_by_field(field, value)
        expect(m).to be_instance_of(Array)
        
        expect(m.length>0).to eq(true)
        m.each {|o| expect(o).to be_instance_of(described_class)}
      end
    end
  end

  context '#uri_for' do
    context 'when receving good arguments' do
      it 'generates a url for the request' do
        expect(described_class.uri_for('tax-id', 1)).to eq('/ena/data/taxonomy/v1/taxon/tax-id/1')
      end
      context 'when providing a limit value' do
        it 'generates a url for the request' do
          expect(described_class.uri_for('common-name', "Bubidu Bubidus", 33)).to eq(
            '/ena/data/taxonomy/v1/taxon/common-name/Bubidu%20Bubidus?limit=33'
            )
        end
      end
    end
    context 'when receiving wrong arguments' do
      it 'raises an exception when no values are provided' do
        expect{described_class.uri_for(nil, nil, nil)}.to raise_exception TaxonomyClient::Errors::BadRequest\
      end
      it 'raises an exception when no field is specified' do
        expect{described_class.uri_for(nil, 1, nil)}.to raise_exception TaxonomyClient::Errors::BadRequest
      end
      it 'raises an exception when no value is provided for the field' do
        expect{described_class.uri_for('tax-id', nil, nil)}.to raise_exception TaxonomyClient::Errors::BadRequest
      end
      it 'raises an exception when an unsupported field is requested' do
        expect{described_class.uri_for('unsupported-field', nil, nil)}.to raise_exception TaxonomyClient::Errors::BadRequest
      end
      it 'ignores the limit if is not a number' do
        expect(described_class.uri_for('tax-id', 1, 'some text')).to eq('/ena/data/taxonomy/v1/taxon/tax-id/1')
      end
    end
  end


end