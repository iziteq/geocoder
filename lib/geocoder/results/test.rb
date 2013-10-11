require 'geocoder/results/base'

module Geocoder
  module Result
    class Test < Base
      %w[latitude longitude city state state_code province
      province_code postal_code country country_code address
      street_address street_number route types address_components].each do |attr|
        define_method(attr) do
          @data[attr.to_s] || @data[attr.to_sym]
        end
      end

      # Geocoder doesn't provide some methods for test results
      # So we should define methods for matching Google results
      # NOTE: copy-paste from `lib/geocoder/results/google.rb`
      def city
        [:locality, :sublocality,
          :administrative_area_level_3,
          :administrative_area_level_2].each do |f|
          if entity = address_components_of_type(f)
            return entity['long_name']
          end
        end
        nil # no appropriate components found
      end

      def address_components_of_type(type)
        address_components.detect { |c| c['types'].include?(type.to_s) }
      end
    end
  end
end
