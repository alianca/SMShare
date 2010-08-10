module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /raiz do site/
      '/'
      
    when /download do arquivo/
      download_user_file_path(:id => @file.id)
      
    when /pagina de login/
      new_user_session_path
      
    when /pagina de logout/
      destroy_user_session_path
      
    when /pagina de upload/
      new_user_file_path

    when /pagina inicial/
      url_for(:controller => :home, :action => :index, :only_path => true)
      
    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
