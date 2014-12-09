module Spree
  class Payment
    include Virtus.model(finalize: false)

    attribute :final, Boolean
    attribute :canceled, Boolean, :default => false

    def cancel!
      self.canceled = true
      # TODO - potentially do something with the payment method, etc. (like void the payment on gateway)
    end

    def canceled?
      self.canceled
    end
  end
end
