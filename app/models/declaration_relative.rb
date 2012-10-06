class DeclarationRelative < ActiveRecord::Base
  belongs_to :declaration, :counter_cache => true
  belongs_to :declaration, :counter_cache => :declaration_childrens_count
end
