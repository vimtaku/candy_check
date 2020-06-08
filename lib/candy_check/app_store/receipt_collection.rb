module CandyCheck
  module AppStore
    # Store multiple {Receipt}s in order to perform collective operation on them
    class ReceiptCollection
      # Multiple receipts as in verfication response
      # @return [Array<Receipt>]
      attr_reader :receipts

      # Initializes a new instance which bases on a JSON result
      # from Apple's verification server
      # @param attributes [Array<Hash>]
      def initialize(attributes)
        @receipts = attributes.map { |r| Receipt.new(r) }
      end

      # Check if the latest expiration date is passed
      # @return [bool]
      def expired?
        expires_at.to_time <= Time.now.utc
      end

      # Check if in trial
      # @return [bool]
      def trial?
        latest_receipt.is_trial_period
      end

      # Get latest expiration date
      # @return [DateTime]
      def expires_at
        latest_receipt.expires_date
      end

      # Get number of overdue days. If this is negative, it is not overdue.
      # @return [Integer]
      def overdue_days
        (Date.today - expires_at.to_date).to_i
      end

      def latest_receipt
        @receipts.sort_by{|x| x.expires_date }.reverse.first
      end
    end
  end
end
