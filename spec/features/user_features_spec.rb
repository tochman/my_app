feature 'user sign up' do 
  before do
    visit 'sign-up'
  end
  
  scenario 'renders sign-up form' do
    expect(page).to have_selector "form[action='/register']"
    expect(page).to have_selector "form[method='POST']"
    expect(page).to have_selector "input[name='user[email]']"
    expect(page).to have_selector "input[name='user[password]']"
    expect(page).to have_selector "input[name='user[password_confirmation]']"
  end
  
  scenario 'creates new user' do 
    expect(User.count).to eq 0
    fill_in 'user[email]', with: 'thomas@makersacademy.se'
    fill_in 'user[password]', with: 'password'
    fill_in 'user[password_confirmation]', with: 'password'    
    click_button 'Sign up'
    expect(User.count).to eq 1
  end
  
end

feature 'login' do 
  scenario 'renders sign-up form' do
    visit '/login'
    expect(page).to have_selector "form[action='/login']"
    expect(page).to have_selector "form[method='POST']"
    expect(page).to have_selector "input[name='user[email]']"
    expect(page).to have_selector "input[name='user[password]']"
  end
  
  scenario 'reroute to login page if user is not logged in' do 
    visit '/'
    expect(page.current_path).to eq '/login'
  end
  
  scenario 'logges in user with valid credentials' do 
    User.create(email: 'thomas@makersacademy.se', password: 'password', password_confirmation: 'password')
    visit '/login'
    fill_in 'user[email]', with: 'thomas@makersacademy.se'
    fill_in 'user[password]', with: 'password'
    click_button 'Login'
    expect(page.current_path).to eq '/'
  end
end