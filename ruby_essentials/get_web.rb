require "open-uri"
class GetWeb
  HOME = "http://www.techotopia.com/RUBY_ESSENTIALS.php"
  RUBY_ESSENTIALS = "Ruby_Essentials"
  #<a href="/index.php/Understanding_Ruby_Variables" title="Understanding Ruby Variables">Understanding Ruby Variables</a>"
  URL_PATTERN = /<a href="\/index\.php\/(.*Ruby.*)" title="(.*)">.*<\/a>/
  INDEX = "index.html"

  def self.make_index
    out = open(INDEX, "w")
    out.write("<ol>")

    chapter = ""
    open("#{RUBY_ESSENTIALS}.html").each do |line|
      m = URL_PATTERN.match(line)
      next unless m
      if m[2] != chapter
        out.write("</ul>") if chapter != ""
        out.write("<li>#{m[0].sub(/\/index\.php/,".").sub(/#{m[1]}/, "#{m[1]}.html")}</li>")
        out.write("<ul>")
        chapter = m[2]
      else
        out.write("<li>#{m[0].sub(/\/index\.php/,".").sub(/#{m[1]}/, "#{m[1]}.html")}</li>")
      end

    end
    out.write("</ul>")
    out.write("</ol>")

  end
  def self.getAll
    GetWeb.get(RUBY_ESSENTIALS)
    open("#{RUBY_ESSENTIALS}.html") do |f|
      f.read.scan(URL_PATTERN).uniq.each do |item|
        self.get(item[0])
      end
    end
  end

  private
  def self.get(name)
    open("#{HOME}/#{name}") {|f| open("#{name}.html", "w").write(f.read)}
  end

end

GetWeb.make_index
#GetWeb.getAll
