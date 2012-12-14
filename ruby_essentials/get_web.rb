require "open-uri"
class GetWeb
  HOME = "http://www.techotopia.com/RUBY_ESSENTIALS.php"
  RUBY_ESSENTIALS = "Ruby_Essentials"
  #<a href="/index.php/Understanding_Ruby_Variables" title="Understanding Ruby Variables">Understanding Ruby Variables</a>"
  URL_PATTERN = /<a href="\/index\.php\/(.*Ruby.*)" title="(.*)">.*<\/a>/
  TARGET = "./target"

  def self.make_index
    Dir.mkdir TARGET unless Dir.exist? TARGET
    out = open("#{TARGET}/#{RUBY_ESSENTIALS}.html", "w")
    out.write("<ol>")
    chapter = ""
    open("#{RUBY_ESSENTIALS}.html").each do |line|
      m = URL_PATTERN.match(line)
      next unless m
      url = "<li>#{m[0].sub(/\/index\.php/,".").sub(/#{m[1]}/, "#{m[1]}.html")}</li>"
      if m[2] != chapter
        out.write("</ul>") if chapter != ""
        out.write(url)
        out.write("<ul>")
        chapter = m[2]
      else
        out.write(url)
      end
    end
    out.write("</ul>")
    out.write("</ol>")
  end

  def self.make_content
    open("#{RUBY_ESSENTIALS}.html") do |f|
      f.read.scan(URL_PATTERN).uniq.each do |item|
        out = open("#{TARGET}/#{URI::decode(item[0])}.html","w")
        keep = false
        open("#{item[0]}.html").each do |line|
          keep = true if line =~ /<p>|<span|<pre>|<title>|<h1|<hr/
          out.write(line.sub(/<span class="editsection">.*\]<\/span>/,'')) if keep unless line =~ /img/
          out.write('<a href="./Ruby_Essentials.html" title="Ruby Essentials">Table of Contents</a>') if line =~ /<hr/
          keep = false if line =~ /<\/p>|<\/span>|<\/pre>|<\/title>|<\/h1>|<hr \/>/
        end
      end
    end
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
GetWeb.make_content
#GetWeb.getAll
