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
