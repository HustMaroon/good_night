require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:clock_ins).dependent(:destroy) }
  it { should have_many(:active_relationships).dependent(:destroy) }
  it { should have_many(:following) }
  it { should have_many(:passive_relationships).dependent(:destroy) }
  it { should have_many(:followers) }
end
