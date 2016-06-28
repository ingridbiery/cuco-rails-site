if Rails.env.development?
  ENV['DEFAULT_PASSWORD'] ||= 'password'
else
  raise 'Need to set ENV var "DEFAULT_PASSWORD"' if ENV['DEFAULT_PASSWORD'].nil?
end

User.destroy_all

js = User.create!(password: ENV['DEFAULT_PASSWORD'], first_name: 'Jennifer', last_name: 'Smith', email: 'js@example.com')
lj = User.create!(password: ENV['DEFAULT_PASSWORD'], first_name: 'Lisa', last_name: 'Johnson', email: 'lj@example.com')

Family.destroy_all
smith = Family.create!(family_name: "Smith", street_address: "Street Addr", city: "Columbus", state: "OH", zip: 43224)
smith.people.create!(first_name: "Jennifer", last_name: "Smith", dob: "1970/01/01".to_date, primary_adult: true, pronouns: "She/Her/Hers")
smith.people.create!(first_name: "Isabella", last_name: "Smith", dob: "2010/01/01".to_date, primary_adult: false, pronouns: "She/Her/Hers")
smith.people.create!(first_name: "Andrew", last_name: "Smith", dob: "2012/01/01".to_date, primary_adult: false, pronouns: "He/Him/His")

johnson = Family.create!(family_name: "Johnson", street_address: "Street Addr", city: "Columbus", state: "OH", zip: 43224)
johnson.people.create!(first_name: "Lisa", last_name: "Johnson", dob: "1970/01/01".to_date, primary_adult: true, pronouns: "She/Her/Hers")
johnson.people.create!(first_name: "Emma", last_name: "Johnson", dob: "2009/01/01".to_date, primary_adult: false, pronouns: "She/Her/Hers")
johnson.people.create!(first_name: "Olivia", last_name: "Johnson", dob: "2011/01/01".to_date, primary_adult: false, pronouns: "She/Her/Hers")

williams = Family.create!(family_name: "Williams", street_address: "Street Addr", city: "Columbus", state: "OH", zip: 43224)
williams.people.create!(first_name: "Kimberly", last_name: "Williams", dob: "1970/01/01".to_date, primary_adult: true, pronouns: "She/Her/Hers")
williams.people.create!(first_name: "Christopher", last_name: "Williams", dob: "2000/01/01".to_date, primary_adult: false, pronouns: "They/Them/Their")
williams.people.create!(first_name: "David", last_name: "Williams", dob: "2002/01/01".to_date, primary_adult: false, pronouns: "He/Him/His")
williams.people.create!(first_name: "Matthew", last_name: "Williams", dob: "2005/01/01".to_date, primary_adult: false, pronouns: "He/Him/His")

CucoSession.destroy_all
fake_summer = CucoSession.create!(name: 'Fake Summer Session')

summer_public_cal = fake_summer.calendars.create!(googleid: '5a5mn9c90f5eu786ocd3rvjkbs', members_only: false)
summer_member_cal = fake_summer.calendars.create!(googleid: 'eu3jj82rsctenv5c4abvnlktb0', members_only: true)

summer_public_cal.events.create!(title: 'Public Event', start: 1.week.from_now.at_noon, end: 1.week.from_now.at_noon+1.hour)

summer_member_cal.events.create!(title: 'Member Event', start: 1.week.from_now.at_noon+1.day, end: 1.week.from_now.at_noon+1.day+1.hour)
