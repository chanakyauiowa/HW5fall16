# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
 
  movies_table.hashes.each do |movie|
    
    this_movie = Movie.find_by(title: movie["title"])
    
    if(this_movie == nil)
        movie_params = {"title" => movie["title"], "rating" => movie["rating"], "release_date" => movie["release_date"]}
        Movie.create!(movie_params)
    end
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  
  uncheck("ratings_G")
  uncheck("ratings_PG")
  uncheck("ratings_PG-13")
  uncheck("ratings_NC-17")
  uncheck("ratings_R")
  
  ratings = arg1.remove(" ").split(",")
  ratings.each { |this_rating|
      check("ratings_#{this_rating}")
  }
  click_button('Refresh')
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
  ratings = arg1.remove(" ").split(",")
  result=true
   all("tr").each do |tr|
       acceptable=false
       ratings.each { |rating|
       if tr.has_content?(rating)
           acceptable = true
       break
       end
       }
       if (acceptable == false)
          result = false
      end
   end 
  expect(result).to be_truthy
end

Then /^I should see all of the movies$/ do
  result=true
  
  movies = Movie.all.count
  rows = (all("tr").count) - 1
  
  if(movies != rows)
      result = false
  end
  
#   Movie.all.each { |movie|
#       title =  movie["title"]
#       exist = false
#       all("tr").each do |tr|
#           if tr.has_content?(title)
#               exist = true
#               break
#           end
#       end
#       if(exist == false)
#           result = false
#           break
#       end
#   }

  expect(result).to be_truthy
  
end

When /^I have opted to see movies sorted by title$/ do 
    click_link('Movie Title')
end

Then /^I should see "(.*?)" before "(.*?)"$/ do |arg1, arg2|
    result = false
    
    if (page.body.remove("\n") =~ /.*#{arg1}.*#{arg2}.*/)
        result = true
    end
    expect(result).to be_truthy
end

When /^I have opted to see movies sorted by release date$/ do 
    click_link('Release Date')
end

