class RubyBin < ApplicationRecord

  has_paper_trail :on => [:update]

  belongs_to :user
end
