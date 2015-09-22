feature 'application setup' do
  feature 'root path' do
    background do 
      link = Link.create(title: 'Makers Academy', 
      url: 'http://makersacademy.se', 
      description: 'Whatever')
      ['start-up', 'sweden', 'incubator'].each do |tag|
        new_tag = Tag.first_or_create(title: tag)
        link.tags << new_tag
        link.save
      end
      
    end
    
    scenario 'is sucessfull' do
      visit '/'
      expect(page.status_code).to be 200
    end
    
    scenario 'displays link information' do
      visit '/'
      expect(page).to have_content 'Makers Academy'
    end
    
      
    scenario 'displays link & info ' do
      visit '/'
      #binding.pry
      expect(page).to have_link 'Makers Academy', href: 'http://makersacademy.se'
      expect(page).to have_css :small, text: 'Tags: start-up sweden incubator'
      #expect(page).to have_selector 'small', text: 'by: thomas@makersacademy.se'
    end
  end
end 