class MainController < ApplicationController
  
  def index
    time = Time.new
    @date_day = params[:day] || time.day.to_s.rjust(2, '0')
    @date_month = params[:month] || time.month.to_s.rjust(2, '0')
    
    uri = "http://mx.tuhistory.com/hoy-en-la-historia"
    date = "2015-#{@date_month}-#{@date_day}"
    doc = Nokogiri::HTML(open("#{uri}/#{date}"))
    
    @days = []
    doc.search(".contenido").each do |t|
        dTitle = t.search("h4 a").text
        dDate = t.search("h6").text
        dUrl = t.search(".content-image img").attr('src').to_s
        day = Day.new(dTitle, dDate, dUrl)
        @days << day
        
        puts day.url
    
    end
    
    respond_to do |format|
       format.html # index.html.erb
       format.json  { render :json => @days.to_json }
    end
    
  end
end

class Day
  attr_accessor :title, :date, :url
    def initialize(title, date, url)
       @title = title
       @date = date
       @url = url
       
    end
    
    def to_s
       "#{@title} - #{@date} - #{@url}"
    end

end

