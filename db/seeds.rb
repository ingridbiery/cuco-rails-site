if Rails.env.development?
  ENV['DEFAULT_PASSWORD'] ||= 'password'
else
  raise 'Need to set ENV var "DEFAULT_PASSWORD"' if ENV['DEFAULT_PASSWORD'].nil?
end

User.destroy_all

ingrid_biery = User.create!(password: ENV['DEFAULT_PASSWORD'], first_name: 'Ingrid', last_name: 'Biery', email: 'ingridbiery@gmail.com')
christine_davidson = User.create!(password: ENV['DEFAULT_PASSWORD'], first_name: 'Christine', last_name: 'Davidson', email: 'christine.davidson@outlook.com')

CucoSession.destroy_all
fake_summer = CucoSession.create!(name:'Fake Summer Session')

summer_public_cal = fake_summer.calendars.create!(googleid: '5a5mn9c90f5eu786ocd3rvjkbs')
summer_member_cal = fake_summer.calendars.create!(googleid: 'eu3jj82rsctenv5c4abvnlktb0')

summer_public_cal.events.create!(title: 'Public Event', start: 1.week.from_now.at_noon, end: 1.week.from_now.at_noon+1.hour)

summer_member_cal.events.create!(title: 'Member Event', start: 1.week.from_now.at_noon+1.day, end: 1.week.from_now.at_noon+1.day+1.hour)
