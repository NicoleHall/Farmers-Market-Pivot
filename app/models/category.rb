class Category < ActiveRecord::Base
  has_many :items
  validates :name, presence: true,
                   uniqueness: true
  before_create :generate_url

  def generate_url
    self.url = self.name.parameterize
  end
end
