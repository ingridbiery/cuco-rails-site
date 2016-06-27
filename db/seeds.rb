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
smith.people.create!(first_name: "Jennifer", last_name: "Smith", dob: "1970/01/01".to_date, primary_adult: true)
smith.people.create!(first_name: "Isabella", last_name: "Smith", dob: "2010/01/01".to_date, primary_adult: false)
smith.people.create!(first_name: "Andrew", last_name: "Smith", dob: "2012/01/01".to_date, primary_adult: false)

johnson = Family.create!(family_name: "Johnson", street_address: "Street Addr", city: "Columbus", state: "OH", zip: 43224)
johnson.people.create!(first_name: "Lisa", last_name: "Johnson", dob: "1970/01/01".to_date, primary_adult: true)
johnson.people.create!(first_name: "Emma", last_name: "Johnson", dob: "2009/01/01".to_date, primary_adult: false)
johnson.people.create!(first_name: "Olivia", last_name: "Johnson", dob: "2011/01/01".to_date, primary_adult: false)

williams = Family.create!(family_name: "Williams", street_address: "Street Addr", city: "Columbus", state: "OH", zip: 43224)
williams.people.create!(first_name: "Kimberly", last_name: "Williams", dob: "1970/01/01".to_date, primary_adult: true)
williams.people.create!(first_name: "Christopher", last_name: "Williams", dob: "2000/01/01".to_date, primary_adult: false)
williams.people.create!(first_name: "David", last_name: "Williams", dob: "2002/01/01".to_date, primary_adult: false)
williams.people.create!(first_name: "Matthew", last_name: "Williams", dob: "2005/01/01".to_date, primary_adult: false)

CucoSession.destroy_all
fake_summer = CucoSession.create!(name: 'Fake Summer Session')

summer_public_cal = fake_summer.calendars.create!(googleid: '5a5mn9c90f5eu786ocd3rvjkbs', members_only: false)
summer_member_cal = fake_summer.calendars.create!(googleid: 'eu3jj82rsctenv5c4abvnlktb0', members_only: true)

summer_public_cal.events.create!(title: 'Public Event', start: 1.week.from_now.at_noon, end: 1.week.from_now.at_noon+1.hour)

summer_member_cal.events.create!(title: 'Member Event', start: 1.week.from_now.at_noon+1.day, end: 1.week.from_now.at_noon+1.day+1.hour)

# Populate database with states (probably will need to do in production)
# in order to make the "edit" forms show the state correctly.
State.destroy_all
states = State.create!([
  { state_name: 'Alaska', state_code: 'AK' },
  { state_name: 'Alabama', state_code: 'AL' },
  { state_name: 'Arkansas', state_code: 'AR' },
  { state_name: 'Arizona', state_code: 'AZ' },
  { state_name: 'California', state_code: 'CA' },
  { state_name: 'Colorado', state_code: 'CO' },
  { state_name: 'Connecticut', state_code: 'CT' },
  { state_name: 'District of Columbia', state_code: 'DC' },
  { state_name: 'Delaware', state_code: 'DE' },
  { state_name: 'Florida', state_code: 'FL' },
  { state_name: 'Georgia', state_code: 'GA' },
  { state_name: 'Hawaii', state_code: 'HI' },
  { state_name: 'Iowa', state_code: 'IA' },
  { state_name: 'Idaho', state_code: 'ID' },
  { state_name: 'Illinois', state_code: 'IL' },
  { state_name: 'Indiana', state_code: 'IN' },
  { state_name: 'Kansas', state_code: 'KS' },
  { state_name: 'Kentucky', state_code: 'KY' },
  { state_name: 'Louisiana', state_code: 'LA' },
  { state_name: 'Massachusetts', state_code: 'MA' },
  { state_name: 'Maryland', state_code: 'MD' },
  { state_name: 'Maine', state_code: 'ME' },
  { state_name: 'Michigan', state_code: 'MI' },
  { state_name: 'Minnesota', state_code: 'MN' },
  { state_name: 'Missouri', state_code: 'MO' },
  { state_name: 'Mississippi', state_code: 'MS' },
  { state_name: 'Montana', state_code: 'MT' },
  { state_name: 'North Carolina', state_code: 'NC' },
  { state_name: 'North Dakota', state_code: 'ND' },
  { state_name: 'Nebraska', state_code: 'NE' },
  { state_name: 'New Hampshire', state_code: 'NH' },
  { state_name: 'New Jersey', state_code: 'NJ' },
  { state_name: 'New Mexico', state_code: 'NM' },
  { state_name: 'Nevada', state_code: 'NV' },
  { state_name: 'New York', state_code: 'NY' },
  { state_name: 'Ohio', state_code: 'OH' },
  { state_name: 'Oklahoma', state_code: 'OK' },
  { state_name: 'Oregon', state_code: 'OR' },
  { state_name: 'Pennsylvania', state_code: 'PA' },
  { state_name: 'Puerto Rico', state_code: 'PR' },
  { state_name: 'Rhode Island', state_code: 'RI' },
  { state_name: 'South Carolina', state_code: 'SC' },
  { state_name: 'South Dakota', state_code: 'SD' },
  { state_name: 'Tennessee', state_code: 'TN' },
  { state_name: 'Texas', state_code: 'TX' },
  { state_name: 'Utah', state_code: 'UT' },
  { state_name: 'Virginia', state_code: 'VA' },
  { state_name: 'Vermont', state_code: 'VT' },
  { state_name: 'Washington', state_code: 'WA' },
  { state_name: 'Wisconsin', state_code: 'WI' },
  { state_name: 'West Virginia', state_code: 'WV' },
  { state_name: 'Wyoming', state_code: 'WY' }
])