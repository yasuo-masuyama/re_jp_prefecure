# frozen_string_literal: true

module JpPrefecture
  module Searchable
    NAME_FIELDS = %i[name name_e name_r name_h name_k].freeze

    def find_by_code(value)
      return nil if value.nil?

      all.find { |record| record.code == value }
    end

    NAME_FIELDS.each do |field|
      define_method(:"find_by_#{field}") do |value|
        return nil if value.nil? || value.to_s.empty?

        query = value.to_s.downcase
        all.find { |record| record.public_send(field).to_s.downcase.start_with?(query) }
      end
    end

    def find_by_zip(value)
      return nil if value.nil?

      all.find { |record| record.zips.any? { |range| range.cover?(value) } }
    end
  end
end
