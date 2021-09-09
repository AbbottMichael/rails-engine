class Item < ApplicationRecord
  belongs_to :merchant
  has_many   :invoice_items
  has_many   :invoices, through: :invoice_items

  def self.find_all_items(name_query)
    where("name ~* ?", name_query).order(:name)
    # where("name iLIKE ?", "%#{name_query}%").order(:name).take
  end
end
