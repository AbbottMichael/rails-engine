class Item < ApplicationRecord
  belongs_to :merchant

  def self.find_all_items(name_query)
    where("name ~* ?", name_query).order(:name)
    # where("name iLIKE ?", "%#{name_query}%").order(:name).take
  end
end
