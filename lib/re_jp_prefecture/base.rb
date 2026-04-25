# frozen_string_literal: true

require_relative "prefecture"

module JpPrefecture
  module Base
    def jp_prefecture(column_name, options = {})
      column_name = column_name.to_sym
      method_name = options[:method_name] || :prefecture

      define_method(method_name) do
        Prefecture.find(public_send(column_name))
      end
    end
  end
end
