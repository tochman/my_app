feature 'application setup' do
  feature 'root path' do
    background do  
     create_and_login_user('thomas@makersacademy.se', 'password')     
    end
    
    scenario 'is sucessfull' do
      visit '/'
      expect(page.status_code).to be 200
    end
    
    scenario 'displays no links message' do 
      visit '/'
      expect(page).to have_content 'There are no links in the system'
    end
    
    scenario 'displays Add Link link' do 
      visit '/'
      expect(page).to have_selector "a[href='/links/new']"
    end
    
    scenario 'displays link information' do
      populate_links('thomas@makersacademy.se')
      visit '/'
      expect(page).to have_content 'Makers Academy'
    end
    
      
    scenario 'displays link & info ' do
      populate_links('thomas@makersacademy.se')
      visit '/'
      expect(page).to have_link 'Makers Academy', href: 'http://makersacademy.se'
      expect(page).to have_css :small, text: 'Tags: start-up sweden incubator'
      expect(page).to have_selector 'small', text: 'by: thomas@makersacademy.se'
    end
  end
end 