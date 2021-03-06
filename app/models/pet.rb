class Pet < ActiveRecord::Base
  belongs_to :shelter
  belongs_to :image

  scope :active, -> { where(active: true) }
  scope :maybe, ->(prop, value) { where(prop => value) unless value.nil? }

  def self.from_hash(hash)
  	unless hash[:shelter_name].blank?
	  	shelter = Shelter.find_or_create_by(name: hash.delete(:shelter_name))  
	  	hash.merge! shelter: shelter
	  end

  	image = Image.from_pet_id(hash[:pet_id])
  	hash.merge! image: image unless image.blank?

  	Pet.new(hash)
  end

  def mark_inactive!
    self.active = false
  end

  def active?
    active
  end

  def found_days_ago
    (Date.today - found_on).to_i unless found_on.nil?
  end
end
