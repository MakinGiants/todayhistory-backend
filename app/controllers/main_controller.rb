class MainController < ApplicationController
  @@last_date = ""
  @@days = []

  def index
    @date_day = params[:d] || Time.now.day
    @date_month = params[:m]|| Time.now.month
    
    @date_day = @date_day.to_s.rjust(2, '0')
    @date_month = @date_month.to_s.rjust(2, '0')

    query_date = "#{Time.now.year}-#{@date_month}-#{@date_day}"

    if @@last_date != query_date or @@days.length == 0
      url = "#{Rails.application.config.history_api_url}/#{query_date}"
      puts url
      
      doc = Nokogiri::HTML(open(url))
      @@days = []
      
      doc.search(".contenido").each do |t|
          title = t.search("h4").text
          date = t.search("h6").text
          image = Image.new(t.search(".content-image img"))

          @@days << Day.new(title, date, image)
      end
    end
    
    @@last_date = query_date
    
    respond_to do |format|
       format.json  { render :json => @@days.to_json }
    end
    
  end
end

class Day
  attr_accessor :title, :date, :thumb
    def initialize(title, date, thumb)
       @title = title
       @date = date
       @thumb = thumb
    end
    
    def to_s
       "#{@title} - #{@date} - #{thumb}"
    end
end

class Image
  attr_accessor :src
    def initialize(img)
       @src = img.attr('src').to_s

       @src.strip!
    end

     def to_s
       "#{@src}"
    end
end

