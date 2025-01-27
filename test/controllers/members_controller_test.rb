# frozen_string_literal: true

require 'test_helper'

class MembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @member = members(:one)
  end

  test 'should get index' do
    get members_url, as: :json
    assert_response :success
  end

  test 'should create member' do
    assert_difference('Member.count') do
      post members_url, params: { member: { name: @member.name, url: @member.url, url_short: @member.url_short } }, as: :json
    end

    assert_response 201
  end

  test 'should show member' do
    get member_url(@member), as: :json
    assert_response :success
  end

  test 'should update member' do
    patch member_url(@member), params: { member: { name: @member.name, url: @member.url, url_short: @member.url_short } }, as: :json
    assert_response 200
  end

  test 'should destroy member' do
    assert_difference('Member.count', -1) do
      delete member_url(@member), as: :json
    end

    assert_response 204
  end
end
