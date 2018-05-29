class User < ActiveRecord::Base
  has_many :blogs
end

class Blog < ActiveRecord::Base
  belongs_to :user
  has_many :comments
end

class Comment < ActiveRecord::Base
  belongs_to :blog
  
end
