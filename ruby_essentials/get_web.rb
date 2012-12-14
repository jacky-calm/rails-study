require "open-uri"
class GetWeb
  HOME = "http://www.techotopia.com/INDEX.php"
  INDEX = "Ruby_Essentials"
  URL_PATTERN = /a href="\/INDEX\.php\/(.*Ruby.*)" title=/

  def make_index
    open("#{INDEX}.html").each do |line|


  end
  def self.getAll
    GetWeb.get(INDEX)
    open("#{INDEX}.html") do |f|
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

GetWeb.getAll
