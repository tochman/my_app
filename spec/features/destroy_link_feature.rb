feature 'destroy links' do
  background do
    create_and_login_user('thomas@makersacademy.se', 'password')
    user = User.first
    populate_links(user[:email])
    populate_links('another@user.com')
  end

  background do
    @user = User.first(email: 'thomas@makersacademy.se')
    @link = Link.first(user_id: @user.id)
    visit '/'
  end

  scenario 'displays a destroy link' do
    expect(page).to have_link 'Destroy', href: "/destroy/#{@link.id}"
  end

  scenario 'destroys a link clicked' do
    expect(page).to have_link 'Makers Academy', count: 2
    click_link 'Destroy'
    expect(page).to have_link 'Makers Academy', count: 1
    expect(page).to_not have_link 'Destroy', href: "/destroy/#{@link.id}"
  end

end