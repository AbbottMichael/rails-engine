class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :invoices

  def self.find_one(name_query)
    where("name ~* ?", name_query).order(:name).take
    # where("name iLIKE ?", "%#{name_query}%").order(:name).take
  end

  def self.total_revenue_desc(merchant_count)
    joins(invoices: [:transactions, :invoice_items])
    .where('invoices.status = ?', 'shipped')
    .where('transactions.result = ?', 'success')
    .select('sum(invoice_items.quantity * invoice_items.unit_price) AS revenue')
    .select('merchants.id', 'merchants.name')
    .group('merchants.id')
    .order(revenue: :desc)
    .limit(merchant_count)
  end
end
