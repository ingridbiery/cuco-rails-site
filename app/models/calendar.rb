class Calendar < ActiveRecord::Base
  belongs_to :cuco_session
  has_many :events, dependent: :destroy
 
  # the colors that google allows calendars to be
  COLORS = ['%23B1365F', '%235C1158', '%23711616', '%23691426', '%23BE6D00',
            '%23B1440E', '%23853104', '%238C500B', '%23754916', '%2388880E',
            '%23AB8B00', '%23856508', '%2328754E', '%231B887A', '%2328754E',
            '%230D7813', '%23528800', '%23125A12', '%232F6309', '%232F6213',
            '%230F4B38', '%235F6B02', '%234A716C', '%236E6E41', '%2329527A',
            '%232952A3', '%234E5D6C', '%235A6986', '%23182C57', '%23060D5E',
            '%23113F47', '%237A367A', '%235229A3', '%23865A5A', '%23705770',
            '%2323164E', '%235B123B', '%2342104A', '%23875509', '%238D6F47',
            '%236B3304', '%23333333']

  # create new calendars for a session
  def self.create_calendars(token, cuco_session, params)
    id = GoogleAPI.create_calendar(token, "Public #{cuco_session.name}")
    public_cal = cuco_session.calendars.create!(googleid: id, members_only: false)
    id = GoogleAPI.create_calendar(token, "Member #{cuco_session.name}")
    private_cal = cuco_session.calendars.create!(googleid: id, members_only: true)
  end

  # return the code that google needs included in the iframe for each google calendar,
  # given a calendar id (a string of characters provided by google) and a color
  def self.cal id, color
    "src=#{id}&color=#{color}&"
  end

  # return the URL provided by google for the iframe needed to embed a google
  # calendar on our site. Show all calendars
  def self.url (signed_in)
    cals_src = ""
    color = 0
    Calendar.find_each do |calendar|
      # include all calendars if the user is signed in, otherwise only if the
      # calendar is public
      if (signed_in || !calendar.members_only) then
        cals_src += cal(calendar.googleid, COLORS[color])
      end
      # increment color by more than 1 each time since adjacent colors are similar
      color += 10
      if color >= COLORS.length then color -= COLORS.length end
    end
    "https://calendar.google.com/calendar/embed?title=CUCO%20Calendar&height=600&wkst=1&bgcolor=%23FFFFFF&#{cals_src}ctz=America%2FNew_York"
  end
  
end