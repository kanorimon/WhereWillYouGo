# coding: utf-8
class ContentsController < ApplicationController
  require 'open-uri'
  require 'json'
  
  def index
    @point = Point.new()
  end
  
  def search

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

    logger.debug("************************index-end")

    
  end

   
end
