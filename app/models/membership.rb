class Membership < ActiveRecord::Base
  belongs_to :family
  belongs_to :cuco_session
  validates :family_id, :uniqueness => {:scope=>:cuco_session_id,
                                        :message => "family already signed up for session"}

  def paypal_url(return_path)
    values = {
      business: ENV['PAYPAL_EMAIL'],
      cmd: "_xclick",
      upload: 1,
      return: "#{ENV['APP_HOST']}#{return_path}",
      invoice: id,
      amount: 25,
      item_name: "#{cuco_session.name} Membership",
      item_number: 1,
      quantity: '1',
      notify_url: "#{ENV['APP_HOST']}/memberships/paypal_hook"
    }
    "#{ENV['PAYPAL_HOST']}/cgi-bin/webscr?" + values.to_query
  end

end
