feature 'add links' do
  
  background do  
   create_and_login_user('thomas@makersacademy.se', 'password')     
  end
  
  scenario '/links/new returns status 200' do
    visit '/links/new'
    expect(page.status_code).to eq 200
  end
  
  scenario 'renders form' do
    visit '/links/new'
    expect(page).to have_selector "form[action='/links/create']"
    expect(page).to have_selector "form[method='POST']"
    expect(page).to have_selector "input[name='link[title]']"
    expect(page).to have_selector "input[name='link[url]']"
    expect(page).to have_selector "input[name='link[description]']"
  end
  
  scenario 'adds a link and reroutes to root' do 
    expect(Link.count).to eq 0
    visit '/links/new'
    fill_in 'link[title]', with: 'My Website'
    fill_in 'link[url]', with: 'http://website.org'
    fill_in 'link[description]', with: 'Lorem ipsum...'
    click_button 'Add'
    expect(Link.count).to eq 1
    expect(page.current_path).to eq '/'
  end
end