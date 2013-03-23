# coding: utf-8
class ContentsController < ApplicationController
  require 'open-uri'
  require 'json'
  
  def index
    @point = Point.new()
  end
  
  def search

=begin
    baseurl = "https://api.foursquare.com/v2/venues/search?"
    lat = params[:point][:lat].to_s  #緯度
    lng = params[:point][:lng].to_s  #経度
    radius = params[:point][:radius].to_s  #探索半径（m）
    #type = "bar"  #対象
    sensor = "false"  #場所センサー取得フラグ
    client_secret = ENV['FOURSQUARE_CLIENT_SECRET']  #APIキー
    client_id = ENV['FOURSQUARE_CLIENT_ID']  #APIキー
    
    logger.debug(params[:point][:lat].to_s)
    logger.debug(params[:point][:lng].to_s)
    logger.debug(params[:point][:radius].to_s)
    logger.debug(client_secret)
    logger.debug(client_id)
    

    #combine = baseurl + 'location=' + lat + ',' + lng  + '&' + 'radius=' + radius + '&' + "types=" + type + '&' + "sensor=" + sensor +  '&' + "key=" + key
    combine = baseurl + 'll=' + lat + ',' + lng  + '&' + 'radius=' + radius + '&' + 'client_secret=' + client_secret + '&' + 'client_id=' + client_id


    url = combine

    logger.debug(url)

    result = open(url) do |file|
      JSON.parse(file.read)
    end

    #logger.debug(result)

    logger.debug(result)    
    @results = result["response"]["groups"][0]["items"]
    logger.debug(@results)
    
    logger.debug(@results.length)
    

    logger.debug("************************index-end")
=end

    baseurl = "https://maps.googleapis.com/maps/api/place/search/json?"
    lat = params[:point][:lat].to_s  #緯度
    lng = params[:point][:lng].to_s  #経度
    radius = params[:point][:radius].to_s  #探索半径（m）
    #type = "bar"  #対象
    sensor = "false"  #場所センサー取得フラグ
    language = "ja"
    key = ENV['GOOGLE_API_KEY']  #APIキー

    randomLatlng(params[:point][:lat].to_f,params[:point][:lng].to_f,params[:point][:radius].to_i) 
    
    logger.debug(params[:point][:lat].to_s)
    logger.debug(params[:point][:lng].to_s)
    logger.debug(params[:point][:radius].to_s)

    #combine = baseurl + 'location=' + lat + ',' + lng  + '&' + 'radius=' + radius + '&' + "types=" + type + '&' + "sensor=" + sensor +  '&' + "key=" + key
    combine = baseurl + 'location=' + lat + ',' + lng  + '&' + 'radius=' + radius + '&' + "language=" + language + '&' + "sensor=" + sensor +  '&' + "key=" + key

    url = combine

    logger.debug(url)

    result = open(url) do |file|
      JSON.parse(file.read)
    end

    @results = result['results']

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

    lat_dist = (x1 * 100000) - (x0 * 100000)
    lng_dist = (y1 * 100000) - (y0 * 100000)
    
    logger.debug(lat_dist.to_i)
    logger.debug(lng_dist.to_i)
    
    lat_rnd = rand(lat_dist.to_i)
    lng_rnd = rand(lng_dist.to_i)

    logger.debug(lat_rnd.to_i)
    logger.debug(lng_rnd.to_i)
    
    lat = lat - (lat_rnd * 0.000001)
    lng = lng - (lng_rnd * 0.000001)

    logger.debug(lat)
    logger.debug(lng)

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
