require 'capybara'

session = if ARGV[0] != 'phantomjs'
  Capybara::Session.new(:selenium)
else
  require 'capybara/poltergeist'
  Capybara::Session.new(:poltergeist)
end

session.visit "http://www.amberbit.com"

if session.has_content?("Ruby on Rails web development")
  puts "All shiny, captain!"
else
  puts ":( no tagline fonud, possibly something's broken"
  exit(-1)
end

