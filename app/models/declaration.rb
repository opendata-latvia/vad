class Declaration < ActiveRecord::Base
  has_many :other_workplaces, :class_name => "DeclarationOtherWorkplace"
  has_many :real_estates, :class_name => "DeclarationRealEstate"
  has_many :companies, :class_name => "DeclarationCompany"
  has_many :securities, :class_name => "DeclarationSecurity"
  has_many :vehicles, :class_name => "DeclarationVehicle"
end
