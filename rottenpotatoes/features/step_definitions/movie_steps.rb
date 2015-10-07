# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
end

Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |muvi, dir|
  page.body =~ /#{muvi}.+Director.+#{dir}/m
end


# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  page.body =~ /#{e1}.+#{e2}/m
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
    if uncheck == "un"
      rating_list.split(',').each { |val|
                                    step %{I uncheck "ratings_#{val}"}
                                  }
    else
      rating_list.split(',').each { |val| 
                                    step %{I check "ratings_#{val}"}
                                  }
    end
# HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end

Then /I should see all the movies/ do
  count = page.all('#movies tr').size
  count = count - 1
  count.should == Movie.count()
  # Make sure that all the movies in the app are visible in the table
end
