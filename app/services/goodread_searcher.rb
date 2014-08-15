require "nokogiri"
require "open-uri"

class GoodreadSearcher
  def initialize(book: nil, isbn: nil)
    @book = book
    @isbn = isbn
  end

  def search_at!
    return false unless book.available?

    xml = Nokogiri::XML(open('http://www.goodreads.com/book/isbn?isbn=' + 
                              isbn +
                              '&key=2YmtRP9SjvDKNqvgQMagyQ'))

    @book.title = xml.xpath("//book/title").map(&:text).first.to_s
    @book.pages = xml.xpath("//book/num_pages").map(&:text).first.to_s
    @book.authors = xml.xpath("//book/authors/author/name").map(&:text).first.to_s
    @book.owner = xml.xpath("//book/publisher").map(&:text).first.to_s
    @book.summary = xml.xpath("//book/description").map(&:text).first.to_s
    @book.url = xml.xpath("//book/url").map(&:text).first.to_s
    @book.cover = File.basename(xml.xpath("//book/image_url").map(&:text).first.to_s)
    @book.published_on = xml.xpath("//book/publication_day").map(&:text).first.to_s + "/" + 
                         xml.xpath("//book/publication_month").map(&:text).first.to_s + "/" + 
                         xml.xpath("//book/publication_year").map(&:text).first.to_s

    if @book.save
      cover_url = xml.xpath("//book/image_url").map(&:text).first.to_s

      CoverUploader.enable_processing = true
      @uploader = CoverUploader.new(@book, :cover)
      @uploader.download! (cover_url)
      @uploader.store!

      @book.update_column(:cover, File.basename(xml.xpath("//book/image_url").map(&:text).first.to_s))

      return true
    else
      return false
    end
  end

  private
  attr_reader :book, :isbn
end