# == Schema Information
#
# Table name: tags_groups_categories
#
#  category_id   :integer
#  created_at    :datetime         not null
#  id            :integer          not null, primary key
#  tags_group_id :integer
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_tags_groups_categories_on_category_id    (category_id)
#  index_tags_groups_categories_on_tags_group_id  (tags_group_id)
#

require 'test_helper'

class TagsGroupsCategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
