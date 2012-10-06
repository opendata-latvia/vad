class DeclarationRealEstate < ActiveRecord::Base
  belongs_to :declaration, :counter_cache => true
end
