desc 'Pretty print out all defined routes in match order, with names. Target specific controller with CONTROLLER=x.'

task :pretty_routes => :environment do
  all_routes = ENV['CONTROLLER'] ? ActionController::Routing::Routes.routes.select { |route| route.defaults[:controller] == ENV['CONTROLLER'] } : ActionController::Routing::Routes.routes
  routes = all_routes.collect do |route|
    reqs = route.requirements.empty? ? "" : route.requirements.inspect
    {:name => route.name ? "#{route.name}_path" : nil , :verb => route.verb, :path => route.path, :reqs => reqs}
  end
  styles = <<-styles
    html * { margin: 0; padding: 0 }
    body { font-family: Sans-serif, Tahoma, Arial; color: #555; background-color: #F5F5F5; padding: 10px }
    h1 { color: #CC0000; margin-bottom: 5px }
    hr { border: 0; border-bottom: 1px solid #DDD }
    table { font-size: 12px; border-collapse: collapse }
    table thead tr { color: #6f6f6f; text-shadow: 1px 1px 1px #FFF; text-align:left; background-color: #D9D9D9; height: 35px; border-top: 1px solid #333; border-bottom: 1px solid #333 }
    td, th { padding: 5px }
    tr.odd { background-color: #EAEAEA; border-top: 1px solid #CCC; border-bottom: 1px solid #CCC }
    
    td.get { color: limegreen }
    td.post { color: black }
    td.put { color: #FF9900 }
    td.delete { color: #CC0000 }
     
  styles
  File.open(File.join(RAILS_ROOT, "routes.html"), "w") do |f|
    f.puts "<html><head><title>Rails 3 Routes</title><style type='text/css'>#{styles}</style></head><body><h1>Rails 3 Routes</h1><hr /><br /><table>"
    f.puts "<thead><tr><th>Name</th><th>Verb</th><th>Path</th><th>Requirements</th></tr></thead><tbody>"
    cycle = 'even'
    routes.each do |r|
      f.puts "<tr class='#{cycle}'><td>#{wrap_long_string(r[:name])}</td><td class=' #{r[:verb].downcase if r[:verb]}'>#{r[:verb]}</td><td>#{wrap_long_string(r[:path])}</td><td>#{wrap_long_string(r[:reqs])}</td></tr>"
      if cycle == "even" 
        cycle = "odd" 
      else 
        cycle = "even" 
      end
    end
    f.puts "</tbody></table></body></html>"
  end
end

def wrap_long_string(text)
  if text.is_a? String
    text.scan(/./).join("<wbr>")
  end
end
