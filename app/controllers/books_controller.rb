class BooksController < ApplicationController
  before_action :authorize

  respond_to :json, only: [:search]

  def index
    @books = Book.all.decorate
  end

  def show
    @book = book.decorate
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)

    if @book.save
      flash[:success] = t('flash.book.created')
      redirect_to book_path(@book)
    else
      render :new
    end
  end

  def edit
    @book = book.decorate
  end

  def update
    if book.update(book_params)
      flash[:success] = t('flash.book.updated')
      redirect_to book_path(@book)
    else
      render :edit
    end
  end

  def destroy
    book.destroy
    flash[:success] = t('flash.book.deleted')
    redirect_to books_path
  end

  def borrow
    BookKeeper.new(book: book).lend_to!(borrower: current_user)

    flash[:success] = t('flash.book.borrowed')
    redirect_to books_path
  end

  def return
    BookKeeper.new(book: book).return_by!(borrower: current_user)

    flash[:success] = t('flash.book.returned')
    redirect_to new_review_book_path
  end

  def new_review
    @book = book.decorate
  end

  def create_review
    ReviewBook.new(book: book, reviewer: current_user, content: review_params).review!

    flash[:success] = t('flash.book.reviewed')
    redirect_to book_path(book.id)
  end

  def rate
    RateBook.new(book: book, rater: current_user, rating: params.require(:rating).to_i).rate!

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def average
    local_variables = { book: book.decorate, rating_value: book.decorate.average_rating }
    partial = render_to_string('books/_rating_show', layout: false, locals: local_variables)
    render json: { attachmentPartial: partial }
  end

  def search
    books = Book.search(search_params).decorate

    respond_with books.map(&:as_json)
  end

  def add
    render
  end

  def goodreads_search
      require 'nokogiri'
      require 'open-uri'

      xml = Nokogiri::XML(open('http://www.goodreads.com/book/isbn?isbn='+params[:isbn]+'&key=2YmtRP9SjvDKNqvgQMagyQ'))

      @book = Book.create

      @book.title = xml.xpath("//book/title").collect(&:text).first.to_s
      @book.pages = xml.xpath("//book/num_pages").collect(&:text).first.to_s
      @book.authors = xml.xpath("//book/authors/author/name").collect(&:text).first.to_s
      @book.owner = xml.xpath("//book/publisher").collect(&:text).first.to_s
      @book.summary = xml.xpath("//book/description").collect(&:text).first.to_s
      @book.url = xml.xpath("//book/url").collect(&:text).first.to_s
      @book.cover = File.basename(xml.xpath("//book/image_url").collect(&:text).first.to_s)
      @book.published_on = xml.xpath("//book/publication_day").collect(&:text).first.to_s + '/' + xml.xpath("//book/publication_month").collect(&:text).first.to_s + '/' + xml.xpath("//book/publication_year").collect(&:text).first.to_s

      if @book.save
        flash[:success] = t('flash.book.created')
        redirect_to book_path(@book)
      else
        render :new
      end

      cover_url = xml.xpath("//book/image_url").collect(&:text).first.to_s

      CoverUploader.enable_processing = true
      @uploader = CoverUploader.new(@book, :cover)
      @uploader.download! (cover_url)
      @uploader.store!

      @book.update_column(:cover, File.basename(xml.xpath("//book/image_url").collect(&:text).first.to_s))

  end

  def goodreads
    render
  end

  private

  def book
    @_book ||= Book.includes({reviews: :reviewer}).find(params[:id])
  end

  def book_params
    params.require(:book).permit(:authors, :owner, :pages, :published_on, :subtitle, :summary, :title, :url, :cover, :cover_cache)
  end

  def review_params
    params.require(:review).permit(:body)
  end

  def search_params
    params.permit(:search_box)[:search_box]
  end
end
