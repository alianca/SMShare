xml.instruct!

xml.rss :version => 2.0 do
  xml.channel do
    xml.title "SMShare - Arquivos de #{@user.name}"
    xml.link user_url(@user)
    xml.description @user.profile.description

    @files.each do |f|
      xml.item do
        xml.title f.name
        xml.link user_file_url(f)
        xml.guid user_file_url(f)
        xml.description f.description
        xml.pubDate pub_date(f.created_at)
      end
    end
  end
end
