module ConnectFour
  Dir['lib/connect_four/*.rb'].each do |file|
    autoload(File.basename(file, '.rb').camelize, file)
  end
end
