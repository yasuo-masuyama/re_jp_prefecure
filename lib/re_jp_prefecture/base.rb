# frozen_string_literal: true

require_relative "searchable"
require_relative "prefecture"

module JpPrefecture
  module Base
    def jp_prefecture(column)
      define_method(:prefecture) do
        code = send(column)
        return nil if code.nil?

        Prefecture.build_by_code(code)
      end
    end
  end
end
