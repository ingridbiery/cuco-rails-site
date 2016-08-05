if Rails.env.development?
  ENV['DEFAULT_PASSWORD'] ||= 'password'
else
  raise 'Need to set ENV var "DEFAULT_PASSWORD"' if ENV['DEFAULT_PASSWORD'].nil?
end

Role.destroy_all
role_a = Role.create!(name: "admin")
role_ga = Role.create!(name: "google_admin")
role_m = Role.create!(name: "member")
role_fm = Role.create!(name: "former_member")
role_b = Role.create!(name: "board_member")
role_u = Role.create!(name: "user")

User.destroy_all
js = User.create!(password: ENV['DEFAULT_PASSWORD'], email: 'js@example.com', notification_list: true)
js.roles << role_a
js.roles << role_m
lj = User.create!(password: ENV['DEFAULT_PASSWORD'], email: 'lj@example.com', notification_list: true)
cuco_calendar = User.create!(password: ENV['DEFAULT_PASSWORD'], email: 'cucocalendar@gmail.com', notification_list: false)
cuco_calendar.roles << role_ga
cuco_calendar.roles << role_a

Pronoun.destroy_all
he = Pronoun.create!(preferred_pronouns: "He/Him/His")
she = Pronoun.create!(preferred_pronouns: "She/Her/Hers")
they = Pronoun.create!(preferred_pronouns: "They/Them/Their")

Family.destroy_all
smith = Family.create!(name: "Smith", street_address: "Street Addr", city: "Columbus", state: "OH", zip: 43224)
jsp = smith.people.create!(first_name: "Jennifer", last_name: "Smith", dob: "1970/01/01".to_date, pronoun_id: she.id)
jsp.user = js
smith.primary_adult_id = jsp.id
smith.save
smith.people.create!(first_name: "Isabella", last_name: "Smith", dob: "2010/01/01".to_date, pronoun_id: they.id)
smith.people.create!(first_name: "Andrew", last_name: "Smith", dob: "2012/01/01".to_date, pronoun_id: he.id)

johnson = Family.create!(name: "Johnson", street_address: "Street Addr", city: "Columbus", state: "OH", zip: 43224)
ljp = johnson.people.create!(first_name: "Lisa", last_name: "Johnson", dob: "1970/01/01".to_date, pronoun_id: she.id)
ljp.user = lj
johnson.primary_adult_id = ljp.id
johnson.save
johnson.people.create!(first_name: "Emma", last_name: "Johnson", dob: "2009/01/01".to_date, pronoun_id: she.id)
johnson.people.create!(first_name: "Olivia", last_name: "Johnson", dob: "2011/01/01".to_date, pronoun_id: they.id)

williams = Family.create!(name: "Williams", street_address: "Street Addr", city: "Columbus", state: "OH", zip: 43224)
kwp = williams.people.create!(first_name: "Kimberly", last_name: "Williams", dob: "1970/01/01".to_date, pronoun_id: she.id)
williams.primary_adult_id = kwp.id
williams.save
williams.people.create!(first_name: "Christopher", last_name: "Williams", dob: "2000/01/01".to_date, pronoun_id: he.id)
williams.people.create!(first_name: "David", last_name: "Williams", dob: "2002/01/01".to_date, pronoun_id: he.id)
williams.people.create!(first_name: "Matthew", last_name: "Williams", dob: "2005/01/01".to_date, pronoun_id: he.id)

Room.destroy_all
meetingRoom = Room.create!(name: "Meeting Room")
gym = Room.create!(name: "Gym")
bigArtRoom = Room.create!(name: "Big Art Room")

CucoSession.destroy_all
s = CucoSession.create!(name: "2016 Spring", start_date: "2016/03/20".to_date, end_date: "2016/05/20".to_date)
s.courses.create!(title: "Washi Tape Crafts", short_title: "Washi",
                  description: "We will use washi (patterned Japanese tape) and other materials to create one craft per week. Students are also free to work on their own creations and to work on the same project for weeks at a time. All materials will be provided, but you are welcome to bring your own washi tape, if you’d like.",
                  min_age: 6, max_age: 100, age_firm: false, min_students: 2,
                  max_students: 14, fee: 5, supplies: "", room_reqs: "",
                  time_reqs: "", drop_ins: false, additional_info: "",
                  assigned_room: meetingRoom.id,  assigned_period: 1)
f = CucoSession.create!(name: "2016 Fall", start_date: "2016/09/10".to_date, end_date: "2016/12/20".to_date)
f.courses.create!(title: "Beginner Gymnastics", short_title: "Gymnastics",
                  description: "We will work on floor and beam skills, levels 1-5: mainly hops, jumps, turns, and light tumbling.

All ages welcome, but under 7 should be accompanied by an adult.

(It's been awhile, but I am a former gymnast and acrobat).",
                  min_age: -1, max_age: -1, age_firm: false, min_students: 1,
                  max_students: 12, fee: 0,
                  supplies: "Please wear clothes that don't inhibit movement and shoes that are sensible for balance.",
                  room_reqs: "We need mats. I would prefer the upstairs dance room.",
                  time_reqs: "Not first period. Second, third, or 4th is fine - cannot conflict with customization class.",
                  drop_ins: false, additional_info: "",
                  assigned_room: gym.id, assigned_period: 2)
                
EventType.destroy_all
EventType.create!(name: :course_offering)
EventType.create!(name: :schedule_posted)
EventType.create!(name: :member_reg)
EventType.create!(name: :former_reg)
EventType.create!(name: :new_reg)
EventType.create!(name: :fees_posted)
EventType.create!(name: :fees_due)
EventType.create!(name: :courses)
