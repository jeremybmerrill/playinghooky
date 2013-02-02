namespace :import do
  task :parties => :environment do
    require 'csv'
    parties = CSV.read("#{Rails.root}/lib/assets/partytime_dump_all.csv", :headers => :first_row)
    parties.each do |csv_party|
      next if csv_party["canceled"] || csv_party["postponed"]

      if p = Party.find_by_sunlight_key(csv_party["key"].to_i)
        #add data
        p.beneficiary = csv_party["Beneficiary"]
        p.host = csv_party["Host"]
        p.entertainment = csv_party["Entertainment"]
        p.venue_name = csv_party["Venue_Name"]
        p.contrib = csv_party["Contributions_Info"]
        p.payable_to = csv_party["Make_Checks_Payable_To"]
        p.canceled = csv_party["Canceled"]
        p.postponed = csv_party["Postponed"]
        puts (p.host || p.venue_name || p.entertainment || p.beneficiary || "") + " added."
        p.save
      else
        p = Party.new
        puts ("Party" + csv_party["key"]) if csv_party["key"].to_i % 100 == 0
        if csv_party["Start_Date"]
          p.start = Time.parse(csv_party["Start_Date"] + (csv_party["Start_Time"].nil? ? "" : " " + csv_party["Start_Time"]))
        end
        if csv_party["End_Time"] && (csv_party["End_Date"] || csv_party["Start_Date"])
          p.end = Time.parse( (csv_party["End_Date"] || csv_party["Start_Date"]).to_s + (csv_party["End_Time"].nil? ? "" : " " + csv_party["End_Time"]))
        else
          p.end = nil
        end
        p.venue_zip = csv_party["Venue_Zipcode"]
        p.venue_city = csv_party["Venue_City"]
        p.venue_state = csv_party["Venue_State"]
        p.sunlight_key = csv_party["key"].to_i

        primary_congresscritter = Congressperson.find_by_crp_id(csv_party["CRP_ID"])
        p.congresspeople << primary_congresscritter unless primary_congresscritter.nil?
        csv_party["Other Member CRP_IDs"].split(" || ").each do |id| 
          secondary_congresscritter = Congressperson.find_by_crp_id(id)
          p.congresspeople << secondary_congresscritter unless secondary_congresscritter.nil?
        end if csv_party["Other Member CRP_IDs"]
        p.save
      end
    end
  end

  task :congresspeople_current_only => :environment do
    require 'yaml'
    congresspeople_yaml = YAML.load(open("#{Rails.root}/lib/assets/legislators-current.yaml"))
    congresspeople_yaml.each do |congressperson|
      c = Congressperson.new
      c.name = congressperson["name"]["first"] + " " + congressperson["name"]["last"]
      c.party = congressperson["terms"][-1]["party"]
      c.state = State.find_by_abbrev(congressperson["terms"][-1]["state"])
      c.govtrack_id = congressperson["id"]["govtrack"]
      c.crp_id = congressperson["id"]["opensecrets"]
      c.save
    end
  end

  task :congresspeople => :environment do
    require 'yaml'
    congresspeople_yaml = YAML.load(open("#{Rails.root}/lib/assets/legislators-historical.yaml"))
    congresspeople_yaml.each do |congressperson|
      next if Time.parse(congressperson["terms"][-1]["start"]) < Time.utc("2008-1-1") || Congressperson.find_by_govtrack_id(congressperson["id"]["govtrack"])
      c = Congressperson.new
      c.name = congressperson["name"]["first"] + " " + congressperson["name"]["last"]
      c.party = congressperson["terms"][-1]["party"]
      c.state = State.find_by_abbrev(congressperson["terms"][-1]["state"])
      c.govtrack_id = congressperson["id"]["govtrack"]
      c.crp_id = congressperson["id"]["opensecrets"]
      c.save
      puts "added " + c.name
    end
  end


  task :states => :environment do
    require 'yaml'
    states_yaml = YAML.load(open("#{Rails.root}/lib/assets/states.yml"))
    states_yaml.each do |trash, s|
      s = State.new
      s.abbrev = s["abbreviation"]
      s.name = s["name"]
      s.save
    end
  end

  task :missed_votes => :environment do
    require 'json'
    require 'restclient'
    query_string = "http://www.govtrack.us/api/v1/vote_voter/?person=GOVTRACKID&option=0&limit=1000&order_by=vote_time&format=json"
    Congressperson.all.each_with_index do |congressperson, index|
      json_resp = RestClient.get(query_string.gsub("GOVTRACKID", congressperson.govtrack_id.to_s ), :accept => :json)
      missed_votes = JSON.load(json_resp)
      puts index + ". " + congressperson.name + ": " + missed_votes["meta"]["total_count"].to_s
      missed_votes["objects"].each do |m|
        next if Time.parse(m["vote_time"]) < Time.utc("2008-1-1") #skip votes older than the party db
        missed_vote = MissedVote.new
        missed_vote.congressperson = congressperson
        missed_vote.vote_time = Time.parse(m["vote_time"])
        missed_vote.govtrack_resource_id = m["id"]
        missed_vote.govtrack_vote_id = m["vote"].split("/")[-1]
        missed_vote.save
      end
    end
  end

  task :absences => :environment do
    Congressperson.all.each_with_index do |congressperson, index|
      puts index.to_s + ". " + congressperson.name
      cached_congressperson_parties = congressperson.parties
      ratchet = 0
      #wtf is ratchet
      congressperson.missed_votes.order(:vote_time).each do |missed_vote|
        cached_congressperson_parties.order(:start)[ratchet..-1].each do |party|
          if party.start.nil?
            puts "party #{party.id.to_s} lacks a start date...?"
            next
          end

          if missed_vote.vote_time < party.start.beginning_of_day
            #skip if the vote happened on a day before the party.
            #ratchet += 1
            next
          elsif missed_vote.vote_time > (party.end.nil? ? party.start.end_of_day : party.end)
            #skip if the vote happened on a day after the party ended
            next
          elsif missed_vote.vote_time >= party.start && (party.start.nil? || missed_vote.vote_time <= party.start)
            a = Absence.new
            a.party = party
            a.missed_vote = missed_vote
            a.strict = true
            a.save
            puts congressperson.name + " played hooky!"
          elsif missed_vote.vote_time.beginning_of_day >= party.start && (party.start.nil? || missed_vote.vote_time.end_of_day <= party.start)
            a = Absence.new
            a.party = party
            a.missed_vote = missed_vote
            a.strict = false
            a.save
            puts congressperson.name + " played hooky!"
          end
        end
      end
    end
  end

  task :full_votes => :environment do
    require 'restclient'
    query_string = "http://www.govtrack.us/api/v1/vote/VOTEID/"
    Absence.all.each do |absence|
      puts query_string.gsub("VOTEID", absence.missed_vote.govtrack_vote_id.to_s)
      json_resp = RestClient.get(query_string.gsub("VOTEID", absence.missed_vote.govtrack_vote_id.to_s), :accept => :json)
      vote_info = JSON.load(json_resp)
      v = FullVote.new
      v.missed_vote = absence.missed_vote
      v.category_label = vote_info["category_label"]
      v.result = vote_info["result"]
      v.link = vote_info["link"]
      v.congress = vote_info["congress"].to_i
      v.status = vote_info["related_bill"]["current_status"]
      v.number = vote_info["related_bill"]["display_number"]
      v.title = vote_info["related_bill"]["title_without_number"]
      v.thomas_link = vote_info["related_bill"]["thomas_link"]
      v.save
      puts v.title
      # rails g model FullVote missed_vote_id:integer category_label:string result:string link;string congress:integer status:string number:string title:string thomas_link:string
    end
  end

end


task :bootstrap do
  #dl data.
  puts "states"
  Rake::Task["import:states"].invoke
  puts "congresscritterz"
  Rake::Task["import:congresspeople"].invoke
  puts "parties"
  Rake::Task["import:parties"].invoke
  puts "missed votes"
  Rake::Task["import:missed_votes"].invoke
  Rake::Task["import:absences"].invoke
  Rake::Task["import:full_votes"].invoke
end