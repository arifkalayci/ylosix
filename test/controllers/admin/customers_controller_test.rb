require 'test_helper'

module Admin
  class CustomersControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    def setup
      login_admin
    end

    test 'should get index/edit/show' do
      get :index
      assert_response :success

      object = customers(:customer_example)
      get :edit, id: object.id
      assert_response :success

      get :show, id: object.id
      assert_response :success
    end
  end
end
