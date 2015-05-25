# == Schema Information
#
# Table name: product_translations
#
#  id                :integer          not null, primary key
#  product_id        :integer          not null
#  locale            :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  name              :string
#  short_description :text
#  description       :text
#
# Indexes
#
#  index_product_translations_on_locale      (locale)
#  index_product_translations_on_product_id  (product_id)
#

class ProductTranslation < ActiveRecord::Base
  belongs_to :product
  belongs_to :language, primary_key: :locale, foreign_key: :locale
  # validates_uniqueness_of locale: { scope: :category_id }
end