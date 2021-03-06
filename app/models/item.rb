class Item < ActiveRecord::Base
  before_save :check_image_path
  belongs_to :vendor
  belongs_to :category
  has_attached_file :file_upload,
                    styles: { large: "550x550>", medium: "300x300>", thumb: "100x100>" },
                    default_url: "https://www.weefmgrenada.com/images/na4.jpg"
  validates_attachment_content_type :file_upload,
                                    content_type: %r{\Aimage\/.*\Z}
  has_many :order_items
  has_many :orders, through: :order_items

  validates :title, presence: true,
                    uniqueness: true
  validates :category_id, presence: true
  validates :vendor_id, presence: true
  validates :price, presence: true,
                    numericality: { greater_than: 0 }
  validates :description, presence: true

  scope :active, -> { where(status: 1) }

  enum status: %w(inactive active)

  def default_image?
    image_path == default_image
  end

  def self.open_vendors_only
    joins(:vendor).where("vendors.status = ?", 1)
  end

  private

  def default_image
    "https://www.weefmgrenada.com/images/na4.jpg"
  end

  def check_image_path
    self.image_path = default_image if image_path_is_empty_or_nil

    if default_image? && file_upload_file_name
      self.image_path = ""
      self.status = "active" unless status == "inactive"
    elsif default_image?
      self.status = "inactive"
    end
  end

  def image_path_is_empty_or_nil
    image_path.nil? || image_path.empty?
  end
end
