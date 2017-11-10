module TaxonomyClient

  class Taxonomy < Model
    ENDPOINT = '/ena/data/taxonomy/v1/taxon'

    FIELDS = ['tax-id','scientific-name', 'common-name', 'synonym', 'anamorph' 'telomorph', 
      'any-name', 'suggest-for-search', 'suggest-for-submission']

    class << self

      def find(id)
        find_by_tax_id(id)
      end

      def find_by_tax_id(value)
        find_by_field('tax-id', value)
      end

      def find_by_scientific_name(value)
        find_by_field('scientific-name', value)
      end

      def suggest_for_search(value, limit=nil)
        find_by_field('suggest-for-search', value)
      end      

      def find_by_field(field_name, value, limit=nil)
        requestor.get(uri_for(field_name, value, limit))
      end

      def uri_for(field_name, value, limit=nil)
        validate_params_for_uri!(field_name, value, limit)

        uri_str = "#{ENDPOINT}/#{field_name}/#{value}"

        limit = Integer(limit) rescue nil
        uri_str += "?limit=#{limit}" if limit

        URI.escape(uri_str)
      end

      private

      def validate_params_for_uri!(field_name, value, limit)
        if (field_name.nil? || value.nil? || !FIELDS.include?(field_name))
          raise TaxonomyClient::Errors::BadRequest
        end
        true
      end

    end
  end

end
