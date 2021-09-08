class Merchant < ApplicationRecord
  has_many :items

  def self.find_one(name_query)
    where("name ~* ?", name_query).order(:name).take
    # where("name iLIKE ?", "%#{name_query}%").order(:name).take
  end
end
