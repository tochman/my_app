feature 'display links by tag' do
    background do
      create_and_login_user('thomas@makersacademy.se', 'password')
      user = User.first
      populate_links(user[:email])
    end

    scenario 'by clicking on tag as link' do
      visit '/'
      click_link('sweden', match: :first)
      expect(page).to have_link 'Makers Academy', href: 'http://makersacademy.se'
    end


end