ENV['RAILS_ENV'] ||= 'development'
require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
require 'net/imap'
require 'net/http'

SLEEP_TIME = 60

config = YAML.load(File.read(File.join(RAILS_ROOT, 'config', 'mail.yml')))

loop do
  begin
    puts 'Checking for new mail'
    imap = Net::IMAP.new(config['host'], config['port'], true)
    imap.login(config['username'], config['password'])
    imap.select('Inbox')
    
    imap.uid_search(["NOT", "DELETED"]).each do |uid|
      source   = imap.uid_fetch(uid, ['RFC822']).first.attr['RFC822']
      location = Location.new_from_email(source)
      existing = Location.existing_address(location)
      
      if existing
        puts "Found location so we'll update"
        existing.signs = location.signs
        if existing.save
          puts "Location updated"
        else
          puts "Location FAIL: #{existing.errors.full_messages.inspect}"
        end
      elsif location.save
        puts "Location created: #{location.inspect}"
      else
        puts "Location FAIL: #{location.errors.full_messages.inspect}"
      end
      
      imap.uid_copy(uid, "[Gmail]/All Mail")
      imap.uid_store(uid, "+FLAGS", [:Deleted])
    end
    
    imap.expunge
    imap.logout
    imap.disconnect
  rescue Net::IMAP::NoResponseError => e
    puts "NoResponseError: #{e.message}"
  rescue Net::IMAP::ByeResponseError => e
    puts "ByeResponseError: #{e.message}"
  rescue => e
    puts "Error: #{e.message}"
  end
  
  sleep(SLEEP_TIME)
end