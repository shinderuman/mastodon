# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'finding software updates through the admin interface' do
  before { sign_in Fabricate(:owner_user) }

  let!(:latest_release) { Fabricate(:software_update, version: '99.99.99', type: 'major', urgent: true, release_notes: 'https://github.com/mastodon/mastodon/releases/v99') }
  let!(:other_release) { Fabricate(:software_update, version: '98.0.0', type: 'major', release_notes: '') }
  let!(:outdated_release) { Fabricate(:software_update, version: '3.5.0', type: 'major', urgent: true, release_notes: 'https://github.com/mastodon/mastodon/releases/v3.5.0') }

  it 'shows release notes on the software updates page without update notices' do
    visit settings_profile_path
    expect(page).to have_no_link(href: admin_software_updates_path)

    visit admin_software_updates_path

    expect(page)
      .to have_title(I18n.t('admin.software_updates.title'))
      .and have_text(latest_release.version)
      .and have_text(other_release.version)
      .and have_no_text(outdated_release.version)
      .and have_no_text(I18n.t('admin.software_updates.critical_update'))

    within("#software_update_#{latest_release.id}") do
      click_on I18n.t('admin.software_updates.release_notes')
    end
    expect(page)
      .to have_current_path('https://github.com/mastodon/mastodon/releases/v99', url: true)
  end
end
