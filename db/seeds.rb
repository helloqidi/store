# encoding: utf-8
# Seed add you the ability to populate your db.
# We provide you a basic shell for interaction with the end user.
# So try some code like below:
#
#   name = shell.ask("What's your name?")
#   shell.say name
#
email     = shell.ask "Which email do you want use for logging into admin?"
name      = shell.ask "What is your name?"
password  = shell.ask "Tell me the password to use:"

shell.say ""

user = User.create(:email => email, :name => name, :password => password, :password_confirmation => password, :role => User::ROLE[:system])

if user.save
  shell.say "================================================================="
  shell.say "User has been successfully created, now you can login with:"
  shell.say "================================================================="
  shell.say "   email: #{email}"
  shell.say "   name: #{name}"
  shell.say "   password: #{password}"
  shell.say "================================================================="
else
  shell.say "Sorry but some thing went wrong!"
  shell.say ""
  user.errors.full_messages.each { |m| shell.say "   - #{m}" }
end

shell.say ""