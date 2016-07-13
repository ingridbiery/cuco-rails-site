if Rails.env.development?
  ENV['DEFAULT_PASSWORD'] ||= 'password'
else
  raise 'Need to set ENV var "DEFAULT_PASSWORD"' if ENV['DEFAULT_PASSWORD'].nil?
end

User.destroy_all
js = User.create!(password: ENV['DEFAULT_PASSWORD'], first_name: 'Jennifer', last_name: 'Smith', email: 'js@example.com')
lj = User.create!(password: ENV['DEFAULT_PASSWORD'], first_name: 'Lisa', last_name: 'Johnson', email: 'lj@example.com')

Pronoun.destroy_all
he = Pronoun.create!(preferred_pronouns: "He/Him/His")
she = Pronoun.create!(preferred_pronouns: "She/Her/Hers")
they = Pronoun.create!(preferred_pronouns: "They/Them/Their")

Family.destroy_all
smith = Family.create!(name: "Smith", street_address: "Street Addr", city: "Columbus", state: "OH", zip: 43224)
smith.people.create!(first_name: "Jennifer", last_name: "Smith", dob: "1970/01/01".to_date, primary_adult: true, pronoun_id: she.id)
smith.people.create!(first_name: "Isabella", last_name: "Smith", dob: "2010/01/01".to_date, primary_adult: false, pronoun_id: they.id)
smith.people.create!(first_name: "Andrew", last_name: "Smith", dob: "2012/01/01".to_date, primary_adult: false, pronoun_id: he.id)

johnson = Family.create!(name: "Johnson", street_address: "Street Addr", city: "Columbus", state: "OH", zip: 43224)
johnson.people.create!(first_name: "Lisa", last_name: "Johnson", dob: "1970/01/01".to_date, primary_adult: true, pronoun_id: she.id)
johnson.people.create!(first_name: "Emma", last_name: "Johnson", dob: "2009/01/01".to_date, primary_adult: false, pronoun_id: she.id)
johnson.people.create!(first_name: "Olivia", last_name: "Johnson", dob: "2011/01/01".to_date, primary_adult: false, pronoun_id: they.id)

williams = Family.create!(name: "Williams", street_address: "Street Addr", city: "Columbus", state: "OH", zip: 43224)
williams.people.create!(first_name: "Kimberly", last_name: "Williams", dob: "1970/01/01".to_date, primary_adult: true, pronoun_id: she.id)
williams.people.create!(first_name: "Christopher", last_name: "Williams", dob: "2000/01/01".to_date, primary_adult: false, pronoun_id: he.id)
williams.people.create!(first_name: "David", last_name: "Williams", dob: "2002/01/01".to_date, primary_adult: false, pronoun_id: he.id)
williams.people.create!(first_name: "Matthew", last_name: "Williams", dob: "2005/01/01".to_date, primary_adult: false, pronoun_id: he.id)

cuco_calendar = User.create!(password: ENV['DEFAULT_PASSWORD'], first_name: 'CUCO', last_name: 'Calendar', email: 'cucocalendar@gmail.com')
CucoSession.destroy_all
