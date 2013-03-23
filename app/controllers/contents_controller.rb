# coding: utf-8
class ContentsController < ApplicationController
  require 'open-uri'
  require 'json'
  require 'net/https'
  
  def index
    @point = Point.new()
  end
  
  def search

    baseurl = "/maps/api/place/search/json?"

    session[:current_lat] = params[:lat].to_f
    session[:current_lng] = params[:lng].to_f
    session[:current_radius] = params[:radius].to_i
    session[:current_types] = params[:check]

    logger.debug(params[:check])
    types = ""
    params[:check].each do |ch|
      if types.blank?
        types += ch
      else
        types += "|" + ch
      end
      
    end

    lat_f = params[:lat].to_f  #緯度
    lng_f = params[:lng].to_f  #経度
    radius_i = params[:radius].to_i  #探索半径（m）

    type = types  #対象
    sensor = "false"  #場所センサー取得フラグ
    language = "ja"  #言語
    key = ENV['GOOGLE_API_KEY']  #APIキー

    rnd_lat_s = Array.new(5, "")
    rnd_lng_s = Array.new(5, "")
    radius_s = (radius_i/2).to_s
    
    @results = []
    result_sum = []
    
    (0..4).each do |num|
      rnd_lat_s[num],rnd_lng_s[num] = randomLatlng(lat_f,lng_f,radius_i/2) 

      combine = baseurl + 'location=' + rnd_lat_s[num] + ',' + rnd_lng_s[num]  + '&' + 'radius=' + radius_s + '&' + "language=" + language + '&' + "types=" + type + '&' + "sensor=" + sensor +  '&' + "key=" + key
      url = combine
      logger.debug(url)
      
      response = ""
      Net::HTTP.version_1_2
      https = Net::HTTP.new("maps.googleapis.com",443)
 https.use_ssl = true
https.verify_mode = OpenSSL::SSL::VERIFY_PEER
https.verify_depth = 5
https.start {
        response = https.get(url)
        logger.debug(response.body)
}
      result = JSON.parse(response.body)
       
     unless result['results'].blank?
      @result_rnd = result['results'][rand(result['results'].size)]

      logger.debug(@result_rnd)
      
      unless result_sum.blank?
         chk = 0
        while result_sum.include?(@result_rnd['id']) && chk < 5
          @result_rnd = result['results'][rand(result['results'].size)]
          logger.debug(@result_rnd)
          chk += 1
        end
      end
      
      result_sum.push(@result_rnd['id'])
      
      logger.debug(result_sum)
      
      @results.push(@result_rnd)
      
      end
    end
    
    @lat_center = lat_f
    @lng_center = lng_f
    

    #combine = baseurl + 'location=' + lat + ',' + lng  + '&' + 'radius=' + radius + '&' + "types=" + type + '&' + "sensor=" + sensor +  '&' + "key=" + key
    #combine = baseurl + 'location=' + lat_s + ',' + lng_s  + '&' + 'radius=' + radius_s + '&' + "language=" + language + '&' + "sensor=" + sensor +  '&' + "key=" + key

    #url = combine

    #result = open(url) do |file|
    #  JSON.parse(file.read)
    #end

    #@results = result['results']

    #logger.debug(result)


    logger.debug("************************index-end")    
  end
  
  def randomLatlng(lat,lng,distance)
    
    #定数
    lat_d = 0.111
    lng_d = 0.091
    
    x0 = lat - distance/lat_d*0.000001
    y0 = lng - distance/lng_d*0.000001
    x1 = lat + distance/lat_d*0.000001
    y1 = lng + distance/lng_d*0.000001

    logger.debug("*****lat-lng*****")
    logger.debug(lat)
    logger.debug(lng)

    logger.debug("*****x0-y0-x1-y1*****")
    logger.debug(x0)
    logger.debug(y0)
    logger.debug(x1)
    logger.debug(y1)

    lat_dist = (x1 * 100000) - (x0 * 100000)
    lng_dist = (y1 * 100000) - (y0 * 100000)
    
    logger.debug("*****lat_dist-lng_dist*****")
    logger.debug(lat_dist.to_i)
    logger.debug(lng_dist.to_i)
    
    lat_rnd = rand(lat_dist.to_i)
    lng_rnd = rand(lng_dist.to_i)

    logger.debug("*****lat_rnd-lng_rnd*****")
    logger.debug(lat_rnd.to_i)
    logger.debug(lng_rnd.to_i)
    
    lat = x0 + (lat_rnd * 0.00001)
    lng = y0 + (lng_rnd * 0.00001)

    logger.debug("*****lat-lng*****")
    logger.debug(lat)
    logger.debug(lng)
    
    return lat.to_s,lng.to_s

=begin
    if distance.is_a?(Numeric)
      lat = lat + distance/lat_d*0.000001
    else
      nil
    end

    if distance.is_a?(Numeric)
      distance/LNG_D*0.000001
    else
      nil
    end
=end
  end

   
end
