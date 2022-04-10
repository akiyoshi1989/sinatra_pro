require 'net/https'
require 'rexml/document'
# require 'riak'
# require 'mechanize'
# require 'selenium-webdriver'
require 'capybara'
# require 'capybara/poltergeist'

Bundler.require

$LOAD_PATH.push(__dir__)

begin
  target_url='http://localhost:4567/input'
  Capybara.register_driver :polterge do |app|
    Capybara::Poltergeist::Driver.new(app, {:js_errors => true, :timeout => 5000})
  end

  session = Capybara::Session.new(:poltergeist)
  session.driver.headers = {
    'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2564.97 Safari/537.36"
  }
  session.visit(target_url)
  # input_name = session.find('input#name')
  # input_password = session.find('input#password')
  # input_name.native.send_key(name)
  # input_password.native.send_key(password)

  # submit = session.find('input.form_change', match: :first)
  # submit.trigger('click')
  ########## check ##########

  session.save_screenshot('capture/input.png')
  ###########################
  session
rescue => e
  puts e
end
