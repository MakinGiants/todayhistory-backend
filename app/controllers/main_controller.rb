class MainController < ApplicationController
  
  def index
    time = Time.new
    @date_day = params[:d].to_s.rjust(2, '0') || time.day.to_s.rjust(2, '0')
    @date_month = params[:m].to_s.rjust(2, '0') || time.month.to_s.rjust(2, '0')
    
    doc = Nokogiri::HTML(open("#{Rails.application.config.history_api_url}/#{Time.now.year}-#{@date_month}-#{@date_day}"))

    @days = []
    doc.search(".contenido").each do |t|
        dTitle = t.search("h4 a").text
        dDate = t.search("h6").text
        dImage = Image.new(t.search(".content-image img"))

        @days << Day.new(dTitle, dDate, dImage)
    end
    
    respond_to do |format|
       format.html # index.html.erb
       format.json  { render :json => @days.to_json }
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
       "#{@title} - #{@date} - #{image}"
    end
end

class Image
  attr_accessor :src, :w, :h
    def initialize(img)
       @src = img.attr('src').to_s
       @w = img.attr('width').to_s.to_i
       @h = img.attr('height').to_s.to_i

       @src.strip!
    end

     def to_s
       "#{@w} - #{@h} - #{@src}"
    end
end

