class User < ApplicationRecord
  has_secure_password
  has_many :tasks
  validates :username, presence: true
  validates :password, length: { minimum: 6 }

  def data
    {id: self.id, password: self.password}
  end
end
