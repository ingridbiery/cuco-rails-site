module PeopleHelper

  def primary_adult_name
    people = @family.people.all

    people.each do |person|
      if person.primary_adult == true
        primary_name = "#{person.first_name} #{person.last_name}"
        return primary_name
      end
    end
    
    return ""
    
  end
end
