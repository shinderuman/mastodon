# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Dashboard' do
  describe 'Viewing the dashboard page' do
    let(:user) { Fabricate(:owner_user) }

    before do
      stub_system_checks
      Fabricate :software_update
      Fabricate :tag, requested_review_at: 5.minutes.ago
      sign_in(user)
    end

    it 'shows system check messages except software update notices' do
      visit admin_dashboard_path

      expect(page)
        .to have_title(I18n.t('admin.dashboard.title'))
        .and have_text(I18n.t('admin.system_checks.rules_check.message_html'))
        .and have_no_text(I18n.t('admin.system_checks.software_version_patch_check.message_html'))
        .and have_text('0 pending hashtags')
    end

    private

    def stub_system_checks
      stub_const 'Admin::SystemCheck::ACTIVE_CHECKS', [
        Admin::SystemCheck::SoftwareVersionCheck,
        Admin::SystemCheck::RulesCheck,
      ]
    end
  end
end
