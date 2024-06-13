# spec/models/user_spec.rb

require 'spec_helper'
require_relative '../../models/user'

RSpec.describe User do
  it "is invalid with blank name or password" do
    user_with_blank_name = User.new(name: '', password: 'password123')
    user_with_blank_password = User.new(name: 'testuser', password: '')

    expect(user_with_blank_name).to_not be_valid
    expect(user_with_blank_password).to_not be_valid
  end
end
