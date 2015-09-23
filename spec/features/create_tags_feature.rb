feature 'create tags' do
  background do  
   create_and_login_user('thomas@makersacademy.se', 'password')     
  end
  
  scenario 'tags are added to new link form' do
    visit '/links/new'
    fill_in 'link[title]', with: 'My Website'
    fill_in 'link[url]', with: 'http://website.org'
    fill_in 'link[description]', with: 'Lorem ipsum...'
    fill_in 'link[tags]', with: 'sweden, cooking, fun'
    click_button 'Add'
    arr = []
    Link.last.tags.each {|tag| arr << tag[:title]}
    expect(arr).to match ['sweden', 'cooking', 'fun']
  end
  
end