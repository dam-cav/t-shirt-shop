# frozen_string_literal: true

# == Schema Information
#
# Table name: t_shirts
#
#  id         :bigint           not null, primary key
#  brand      :string(255)
#  color      :string(255)
#  name       :string(255)      not null
#  price      :integer          not null
#  quantity   :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class TShirtTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
