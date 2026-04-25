# frozen_string_literal: true

require_relative "prefecture"

module JpPrefecture
  module Base
    def jp_prefecture(column)
      define_method(:prefecture) do
        Prefecture.build_by_code(send(column))
      end
    end
  end
end
