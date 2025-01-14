require 'rails_helper'

RSpec.describe Applicant do
  describe 'applicant show page' do
    it 'shows applicants information' do
      shelter1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      app1 = Applicant.create!(name: "Billy Wahl", street_address: "123 S Street Way",
                              city: "Denver", state: "CO", zip_code: "80123", description: "I Like Dogs")
      # app2 = Applicant.create!(name: "Cydney Whitemon", street_address: "124 S Way Avenue",
      #                         city: "Denver", state: "CO", zip_code: "80019", description: "Dogs Like Me")
      pet1 = Pet.create!(adoptable: true, age: 6, breed: "Catahoula Leopard Dog", name: "Rosy", shelter_id: shelter1.id)
      pet2 = Pet.create!(adoptable: true, age: 4, breed: "Dobermann", name: "Lundy", shelter_id: shelter1.id)

      pet_app1 = PetApplicant.create!(pet_id: pet1.id, applicant_id: app1.id)
      pet_app2 = PetApplicant.create!(pet_id: pet2.id, applicant_id: app1.id)

      visit "/applicants/#{app1.id}"

      within "#applicant-#{app1.id}" do
        expect(page).to have_content("Name:\nBilly Wahl")
        expect(page).to have_content("Address:\n123 S Street Way, Denver, CO 80123")
        expect(page).to have_content("Why I would make a good home:\nI Like Dogs")
        expect(page).to have_content("Pets Applied For:\nRosy Lundy")
        expect(page).to have_content("Application Status: In Progress")
      end
    end

    describe 'apply for pet: searching for a pets for application'do 
      it 'On application showpage & app has not been submitted, i see section for "Add a Pet to this application"' do

        shelter1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
        app1 = Applicant.create!(name: "Billy Wahl", street_address: "123 S Street Way",
                                city: "Denver", state: "CO", zip_code: "80123", description: "I Like Dogs")
        
        pet1 = Pet.create!(adoptable: true, age: 6, breed: "Catahoula Leopard Dog", name: "Rosy", shelter_id: shelter1.id)
        pet2 = Pet.create!(adoptable: true, age: 4, breed: "Dobermann", name: "Lundy", shelter_id: shelter1.id)

        # pet_app1 = PetApplicant.create!(pet_id: pet1.id, applicant_id: app1.id)
        # pet_app2 = PetApplicant.create!(pet_id: pet2.id, applicant_id: app1.id)

        visit "/applicants/#{app1.id}" 
        expect(current_path).to eq("/applicants/#{app1.id}")
        within "#add_pets" do 
          fill_in :search_name, with: "Rosy"
            click_on "Search"
        end
        expect(page).to have_content("Rosy")
        expect(page).to_not have_content("Lundy")
        expect(page).to have_content("Add a Pet to this Application")
        expect(current_path).to eq("/applicants/#{app1.id}")
      end 

      it 'add pet to an application' do 
        shelter1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
        app1 = Applicant.create!(name: "Billy Wahl", street_address: "123 S Street Way",
                                city: "Denver", state: "CO", zip_code: "80123", description: "I Like Dogs")
        
        pet1 = Pet.create!(adoptable: true, age: 6, breed: "Catahoula Leopard Dog", name: "Rosy", shelter_id: shelter1.id)
        pet2 = Pet.create!(adoptable: true, age: 4, breed: "Dobermann", name: "Lundy", shelter_id: shelter1.id)

        visit "/applicants/#{app1.id}" 
        within "#add_pets" do 
          fill_in :search_name, with: "Rosy"
            click_on "Search"
        end
        within "#add_pets" do 
          within "#pet-#{pet1.id}" do 
            expect(page).to have_content("Rosy")
            expect(page).to_not have_content("Lundy")
            expect(page).to have_button("Adopt this Pet")
            click_button "Adopt this Pet"
            expect(current_path).to eq "/applicants/#{app1.id}" 
          end
        end

        within "#applicant-#{app1.id}" do 
          expect(page).to have_content("Rosy")
          expect(page).to_not have_content("Lundy")
        end
      end

    end

    it 'can submit an application' do
      shelter1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

      app1 = Applicant.create!(name: "Billy Wahl", street_address: "123 S Street Way",
        city: "Denver", state: "CO", zip_code: "80123", description: "I Like Dogs")

      pet1 = Pet.create!(adoptable: true, age: 6, breed: "Catahoula Leopard Dog", name: "Rosy", shelter_id: shelter1.id)
      pet2 = Pet.create!(adoptable: true, age: 4, breed: "Dobermann", name: "Lundy", shelter_id: shelter1.id)

      visit "/applicants/#{app1.id}"
      expect(page).to_not have_css("#submit")
      expect(page).to have_css("#add_pets")

      pet_app1 = PetApplicant.create!(pet_id: pet1.id, applicant_id: app1.id)
      pet_app2 = PetApplicant.create!(pet_id: pet2.id, applicant_id: app1.id)

      visit "/applicants/#{app1.id}"

      expect(page).to have_css("#submit")
      expect(page).to have_css("#add_pets")

      within "#submit" do
        expect(page).to have_content("Why would I make a good owner for these pet(s)?")

        fill_in :description, with: "I love having to pretty bestfriends"

        click_button "Submit"
        expect(current_path).to eq("/applicants/#{app1.id}")

        app1_update = Applicant.find(app1.id)

        expect(app1_update.description).to eq("I love having to pretty bestfriends")
        expect(app1_update.status).to eq("Pending")
      end
      expect(page).to_not have_css("#add_pets")
      expect(page).to_not have_css("#submit")

    end
  end
  describe 'when searching for a pet by its name' do 
    it 'visitor can see any pet whose name PARTIALLY matches the search' do 
      shelter1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      app1 = Applicant.create!(name: "Billy Wahl", street_address: "123 S Street Way",
                                city: "Denver", state: "CO", zip_code: "80123", description: "I Like Dogs")
        
      pet1 = Pet.create!(adoptable: true, age: 6, breed: "Catahoula Leopard Dog", name: "Rosy", shelter_id: shelter1.id)
      pet2 = Pet.create!(adoptable: true, age: 4, breed: "Dobermann", name: "Lundy", shelter_id: shelter1.id)
      
      visit "/applicants/#{app1.id}"
      
      expect(current_path).to eq("/applicants/#{app1.id}")
        within "#add_pets" do 
          fill_in :search_name, with: "Ro"
            click_on "Search"
        end
      expect(page).to have_content("Rosy")
      expect(page).to_not have_content("Lundy")
    end

    it 'visitor are able to search with case insensitve characters for a pet and return results' do 
      shelter1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      app1 = Applicant.create!(name: "Billy Wahl", street_address: "123 S Street Way",
                                city: "Denver", state: "CO", zip_code: "80123", description: "I Like Dogs")
        
      pet1 = Pet.create!(adoptable: true, age: 6, breed: "Catahoula Leopard Dog", name: "Rosy", shelter_id: shelter1.id)
      pet2 = Pet.create!(adoptable: true, age: 4, breed: "Dobermann", name: "Lundy", shelter_id: shelter1.id)
      
      visit "/applicants/#{app1.id}"
      
      expect(current_path).to eq("/applicants/#{app1.id}")
        within "#add_pets" do 
          fill_in :search_name, with: "roS"
            click_on "Search"
        end
      expect(page).to have_content("Rosy")
      expect(page).to_not have_content("Lundy")
    end
  end
end