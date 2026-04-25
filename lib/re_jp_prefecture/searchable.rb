# frozen_string_literal: true

module JpPrefecture
  module Searchable
    def find_by_code(value)
      return nil if value.nil?

      all.find { |record| record.code == value }
    end

    def find_by_name(value)
      find_by_string_prefix(value, &:name)
    end

    def find_by_name_e(value)
      find_by_string_prefix(value, &:name_e)
    end

    def find_by_name_r(value)
      find_by_string_prefix(value, &:name_r)
    end

    def find_by_name_h(value)
      find_by_string_prefix(value, &:name_h)
    end

    def find_by_name_k(value)
      find_by_string_prefix(value, &:name_k)
    end

    def find_by_zip(value)
      return nil if value.nil?

      all.find { |record| record.zips.any? { |range| range.cover?(value) } }
    end

    private

    def find_by_string_prefix(value)
      query = value.to_s.downcase
      return nil if query.empty?

      all.find { |record| yield(record).to_s.downcase.start_with?(query) }
    end
  end
end
