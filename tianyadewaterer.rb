require 'open-uri'
require 'nokogiri'
  
url = 'http://www.tianya.cn/publicforum/content/funinfo/1/2725149.shtml'

def crawl(url, author, file)
  html = open(url).read
  html.force_encoding("GBK")
  html.encode!("utf-8", :undef => :replace, :replace => "?", :invalid => :replace)
  doc = Nokogiri::HTML.parse html
  doc.xpath("//div[@id='pContentDiv']//table[descendant::a='#{author}']/following-sibling::div[1]").each do |a|
    file.write a.to_s
  end

  doc.xpath("//div[@id='pageDivBottom']/a").each do | a |
    if a.text == '下一页'
      puts a['href']
      return a['href']
    end
  end
  'end'
end

def getAuthor(url)
  html = open(url).read
  html.force_encoding("GBK")
  html.encode!("utf-8", :undef => :replace, :replace => "?", :invalid => :replace)
  doc = Nokogiri::HTML.parse html
  author = doc.xpath("//table[@id='firstAuthor']//a/text()").to_s
end

author = getAuthor url
File.open("result.html", "a") do |file|
  result = crawl url, author, file
  until result == 'end' do
    result = crawl result, author, file
  end
end
