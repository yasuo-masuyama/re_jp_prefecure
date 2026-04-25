# frozen_string_literal: true

require "yaml"

module JpPrefecture
  class Prefecture
    extend Searchable

    ATTRIBUTES = %i[code name name_e name_r name_h name_k area type zips].freeze
    SEARCH_KEYS = %i[name name_e name_r name_h name_k zip].freeze

    attr_reader(*ATTRIBUTES)

    def initialize(code:, name:, name_e:, name_r:, name_h:, name_k:, area:, type:, zips:)
      @code = code
      @name = name
      @name_e = name_e
      @name_r = name_r
      @name_h = name_h
      @name_k = name_k
      @area = area
      @type = type
      @zips = zips
    end

    class << self
      def all
        zip_mapping = current_zip_mapping_data
        current_mapping_data.map do |code, attrs|
          new(code: code, zips: build_zips(zip_mapping[code]), **attrs)
        end
      end

      def build_by_code(code)
        all.find { |pref| pref.code == code }
      end

      def find(query)
        case query
        when Integer
          find_by_code(query)
        when Hash
          key, value = query.first
          return nil unless SEARCH_KEYS.include?(key)

          public_send(:"find_by_#{key}", value)
        end
      end

      private

      def current_mapping_data
        custom = JpPrefecture.config.mapping_data
        return base_mapping_data if custom.nil?

        load_mapping_source(custom)
      end

      def current_zip_mapping_data
        custom = JpPrefecture.config.zip_mapping_data
        return base_zip_mapping_data if custom.nil?

        load_mapping_source(custom)
      end

      def base_mapping_data
        @base_mapping_data ||= YAML.load_file(
          File.expand_path("../../data/prefecture.yml", __dir__),
          permitted_classes: [Symbol]
        )
      end

      def base_zip_mapping_data
        @base_zip_mapping_data ||= YAML.load_file(File.expand_path("../../data/zip_code.yml", __dir__))
      end

      def load_mapping_source(source)
        case source
        when String
          YAML.load_file(source, permitted_classes: [Symbol])
        else
          source
        end
      end

      def build_zips(ranges)
        return [] if ranges.nil?

        ranges.map { |from, to| from..to }
      end
    end
  end
end
