class Project < ActiveRecord::Base
  validates_presence_of :name, :account
  
  before_validation :set_account
  
  private
  
  def set_account
    self.account = "Example Account"
  end
end
