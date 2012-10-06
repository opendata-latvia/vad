class DeclarationCompany < ActiveRecord::Base
  belongs_to :declaration, :counter_cache => true
end
