module ActiveRecord
  module Immutable
    class UpdateImmutableException < Exception
      def initialize
        super("Immutable model can't be updated")
      end
    end

    extend ActiveSupport::Concern

    included do
      before_update :prevent_update
    end

    private

    def prevent_update
      raise UpdateImmutableException.new
    end
  end
end
