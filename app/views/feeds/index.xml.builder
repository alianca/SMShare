xml.instruct!

xml.rss :version => 2.0 do
  xml.channel do
    xml.title "SMShare"
    xml.link news_index_url
    xml.description ""

    @news.each do |n|
      xml.item do
        xml.title n.title
        xml.link news_url(n)
        xml.guid news_url(n)
        xml.description n.short
        xml.pubDate pub_date(n.created_at)
      end
    end
  end
end
