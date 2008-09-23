atom_feed(:schema_date => 2008) do |feed|
  feed.title 'Political Signs'
  feed.updated  @locations.last.updated_at unless @locations.empty?
  feed.icon @icon = '/favicon.ico'
  feed.logo @logo = '/images/logo.png'

  @locations.each do |location|
    feed.entry(location) do |entry|
      entry.title("#{location.signs} in #{location.city}, #{location.state}")
      entry.category :term => location.signs
      entry.category :term => 'politics'
      entry.category :term => 'signs'
      entry.content(textilize(location.to_location.to_s), :type => 'html')

      entry.author do |author|
        author.name 'Political Signs by Collective Idea'
        author.uri  root_path
      end
    end
  end
end