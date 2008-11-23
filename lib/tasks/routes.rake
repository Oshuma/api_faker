desc 'List all routes'
task :routes => [ :merb_env ] do
  puts "\n-- Routes --"
  Merb::Router.routes.each do |route|
    puts route
  end
end

namespace :routes do
  # TODO: These could use some sorting.
  desc 'List all named routes'
  task :named => [ :merb_env ] do
    routes = Merb::Router.named_routes
    puts "\n-- Named Routes --"
    routes.each do |name, route|
      puts "#{name.to_s.ljust(20)} \t #{route}"
    end
  end
end
