class DeclarationDebt < ActiveRecord::Base
  belongs_to :declaration, :counter_cache => true
end
