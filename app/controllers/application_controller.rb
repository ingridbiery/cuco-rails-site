class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def home
    render text: "We are a family-centered group whose members seek to " +
                 "support each other and augment our children’s educational " +
                 "and social enrichment opportunities in a supportive, " +
                 "nurturing, hands-on classroom environment. All parents " +
                 "whose children take classes serve in volunteer roles to " +
                 "make the program a success. Our co-op is composed of a " +
                 "diverse range of families, and we request that members " +
                 "respect the diversity of the group. The one thing we have " +
                 "in common is an interest in trying to do what is best for " +
                 "our children and our families. We are committed to " +
                 "maintaining unschooling principles while participating in " +
                 "co-op. We are open to all families willing to follow our " +
                 "behavior code and participation requirements."
  end
end
