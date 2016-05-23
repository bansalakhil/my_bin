class JsBin < ApplicationRecord
  has_paper_trail :on => [:update]
end
