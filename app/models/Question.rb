class Question < ActiveRecord::Base

    def self.get_clubs
        url = 'https://opentdb.com/api.php?amount=50&category=9&difficulty=medium&type=multiple'
        data = JSON.parse(response)

        data["teams"].each do |t|
          Club.find_or_create_by(name: t["name"], logo: t["crestUrl"],
            address: t["address"], phone: t["phone"],
            website: t["website"], email: t["email"],
            founded: t["founded"], venue: t["venue"],
            id: t["id"])
        end
      end
end
    
