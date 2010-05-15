class Location < ActiveRecord::Base
  belongs_to :company
  acts_as_mappable  :default_units => :kms
end