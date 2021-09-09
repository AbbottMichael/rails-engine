class MerchantSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name

  # attribute :revenue, if: Proc.new { |record|
  #  !record.revenue.nil?
  # }

end
