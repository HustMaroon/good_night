require 'rails_helper'

RSpec.describe ClockIn, type: :model do
  # Association tests
  it { should belong_to(:user) }
  #validation tests
  it { should validate_presence_of(:user_id) }
end
