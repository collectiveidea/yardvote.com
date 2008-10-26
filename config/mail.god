RAILS_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

God.watch do |w|
  script          = "ruby #{RAILS_ROOT}/bin/mail_receiver_ctl.rb"
  rails_env       = "RAILS_ENV=production"
  
  w.name          = "mail-receiver"
  w.group         = "mail"
  w.interval      = 60.seconds
  w.start         = "#{script} start #{rails_env}"
  w.restart       = "#{script} restart #{rails_env}"
  w.stop          = "#{script} stop #{rails_env}"
  w.start_grace   = 20.seconds
  w.restart_grace = 20.seconds
  w.pid_file      = "#{RAILS_ROOT}/log/mail_receiver.pid"
  
  w.behavior(:clean_pid_file)
  
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 10.seconds
      c.running = false
    end
  end
  
  w.restart_if do |restart|
    restart.condition(:memory_usage) do |c|
      c.above = 100.megabytes
      c.times = [3, 5]
    end
  
    restart.condition(:cpu_usage) do |c|
      c.above = 80.percent
      c.times = 5
    end
  end
  
  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end