require 'rails_helper'

RSpec.describe 'Admin archives a framework', type: :request do
  include SingleSignOnHelpers

  before do
    stub_govuk_bank_holidays_request
    mock_sso_with(email: 'admin@example.com')
    get '/auth/google_oauth2/callback'
  end

  let(:definition_source) do
    <<~FDL
      Framework RM999 {
        Name 'Framework to be published'
        ManagementCharge 0.5% of 'Supplier Price'
        Lots {
          '1' -> 'Lot 1'
          '2' -> 'Second Lot'
        }
         InvoiceFields {
          InvoiceValue from 'Supplier Price'
        }
      }
    FDL
  end

  let!(:framework) do
    create(:framework, aasm_state: 'published', short_name: 'RM999',
      name: 'Framework to be published', definition_source: definition_source)
  end

  context 'when the framework has an active agreement' do
    before do
      supplier = create(:supplier, name: 'Test Supplier')
      create(:agreement, framework: framework, supplier: supplier, active: true)
    end

    it 'cannot be archived and shows an error message' do
      post archive_admin_framework_path(framework)

      expect(response).to redirect_to admin_framework_path(framework)
      follow_redirect!

      expect(response.body).to include('Framework cannot be archived while it has active agreements')
      expect(framework.reload.aasm_state).to eq('published')
    end
  end 
end