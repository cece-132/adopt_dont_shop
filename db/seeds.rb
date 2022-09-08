# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
PetApplicant.destroy_all
Pet.destroy_all
Applicant.destroy_all
Shelter.destroy_all

shelter1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
shelter2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
shelter3 = Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

app1 = Applicant.create!(name: "Billy Wahl", street_address: "123 S Street Way",
                        city: "Denver", state: "CO", zip_code: "80123", description: "I Like Dogs")
app2 = Applicant.create!(name: "Cydney Whitemon", street_address: "124 S Way Avenue",
                        city: "Denver", state: "CO", zip_code: "80019", description: "Dogs Like Me")
app3 = Applicant.create!(name: "Mageneto", street_address: "Evil Mansion Way",
                        city: "Denver", state: "CO", zip_code: "80123", description: "I need a heavy metal dog")

pet1 = Pet.create!(adoptable: true, age: 6, breed: "Catahoula Leopard Dog", name: "Rosy", shelter_id: shelter1.id)
pet2 = Pet.create!(adoptable: true, age: 4, breed: "Dobermann", name: "Lundy", shelter_id: shelter1.id)
pet3 = Pet.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true, shelter_id: shelter1.id)
pet4 = Pet.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true, shelter_id: shelter1.id)

pet_app1 = PetApplicant.create!(pet_id: pet1.id, applicant_id: app1.id)
pet_app2 = PetApplicant.create!(pet_id: pet2.id, applicant_id: app1.id)
pet_app3 = PetApplicant.create!(pet_id: pet1.id, applicant_id: app2.id)
pet_app4 = PetApplicant.create!(pet_id: pet2.id, applicant_id: app2.id)
pet_app5 = PetApplicant.create!(pet_id: pet3.id, applicant_id: app3.id)
pet_app6 = PetApplicant.create!(pet_id: pet4.id, applicant_id: app3.id)
pet_app7 = PetApplicant.create!(pet_id: pet4.id, applicant_id: app2.id)
