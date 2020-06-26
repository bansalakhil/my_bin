class MysqlBin < ApplicationRecord

  has_paper_trail :on => [:update]

  belongs_to :user

  def db_name
    "mybin_db_#{user_id}_#{id}"
  end
end
