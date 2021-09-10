class Item < ApplicationRecord
  belongs_to :merchant
  has_many   :invoice_items
  has_many   :invoices, through: :invoice_items

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: true


  def self.find_all_items(name_query)
    where("name ~* ?", name_query).order(:name)
    # where("name iLIKE ?", "%#{name_query}%").order(:name).take
  end

  def self.total_revenue_desc(item_count)
    # joins(invoices: [:transactions, :invoice_items])
    Item.joins(invoice_items: { invoice: :transactions })
    .where('invoices.status = ?', 'shipped')
    .where('transactions.result = ?', 'success')
    .select('sum(invoice_items.quantity * invoice_items.unit_price) AS revenue')
    .select('items.id', 'items.name', 'items.description', 'items.unit_price', 'merchant_id')
    .group('items.id')
    .order(revenue: :desc)
    .limit(item_count)
  end
end
