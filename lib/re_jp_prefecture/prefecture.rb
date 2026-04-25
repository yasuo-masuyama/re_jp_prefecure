# frozen_string_literal: true

require "yaml"

module JpPrefecture
  class Prefecture
    DEFAULT_MAPPING_PATH = File.expand_path("../../data/prefecture.yml", __dir__)
    DEFAULT_ZIP_MAPPING_PATH = File.expand_path("../../data/zip_code.yml", __dir__)

    ATTRIBUTES = %i[code name name_e name_r name_h name_k area type zips].freeze

    attr_reader(*ATTRIBUTES)

    def initialize(attrs)
      ATTRIBUTES.each do |key|
        instance_variable_set("@#{key}", attrs[key])
      end
    end

    class << self
      def all
        zip_mapping = current_zip_mapping_data
        current_mapping_data.map do |code, attrs|
          new(attrs.merge(code: code, zips: build_zips(zip_mapping[code])))
        end
      end

      def build_by_code(code)
        all.find { |pref| pref.code == code }
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
        @base_mapping_data ||= YAML.load_file(DEFAULT_MAPPING_PATH, permitted_classes: [Symbol])
      end

      def base_zip_mapping_data
        @base_zip_mapping_data ||= YAML.load_file(DEFAULT_ZIP_MAPPING_PATH)
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
