atom_feed(:schema_date => 2008) do |feed|
  feed.title 'YardVote.com'
  feed.updated  @last_updated_location.updated_at if @last_updated_location
  feed.icon @icon = '/favicon.ico'
  # feed.logo @logo = '/images/logo.png'

  @locations.each do |location|
    feed.entry(location) do |entry|
      entry.title(h "#{location.signs} in #{location.city}, #{location.state}")
      entry.category :term => location.signs
      entry.category :term => 'politics'
      entry.category :term => 'signs'
      entry.category :term => 'yardvote'
      entry.content(textilize(location.to_location.to_s), :type => 'html')

      entry.author do |author|
        author.name 'YardVote.com by Collective Idea'
        author.uri  root_path
      end
    end
  end
end