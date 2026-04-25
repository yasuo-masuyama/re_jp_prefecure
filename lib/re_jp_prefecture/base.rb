# frozen_string_literal: true

require_relative "prefecture"

module JpPrefecture
  module Base
    def jp_prefecture(column_name, method_name: :prefecture)
      column_name = column_name.to_sym

      define_method(method_name) do
        Prefecture.find(public_send(column_name))
      end
    end
  end
end
