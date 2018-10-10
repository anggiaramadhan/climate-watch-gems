require 'rails_helper'

RSpec.describe GenerateAdminControllers do
  subject { GenerateAdminControllers.new.call }

  it 'Creates new active admin file' do
    expect { subject }.to change {
    }
  end
end
