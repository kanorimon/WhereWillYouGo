# coding: utf-8
class ContentsController < ApplicationController
  require 'open-uri'
  require 'json'
  
  def index
    @point = Point.new()
  end
  
  def search

    baseurl = "https://maps.googleapis.com/maps/api/place/search/json?"
    lat = params[:point][:lat].to_s  #緯度
    lng = params[:point][:lng].to_s  #経度
    radius = params[:point][:radius].to_s  #探索半径（m）
    #type = "bar"  #対象
    sensor = "false"  #場所センサー取得フラグ
    key = ENV['GOOGLE_API_KEY']  #APIキー
    
    logger.debug(params[:point][:lat].to_s)
    logger.debug(params[:point][:lng].to_s)
    logger.debug(params[:point][:radius].to_s)

    #combine = baseurl + 'location=' + lat + ',' + lng  + '&' + 'radius=' + radius + '&' + "types=" + type + '&' + "sensor=" + sensor +  '&' + "key=" + key
    combine = baseurl + 'location=' + lat + ',' + lng  + '&' + 'radius=' + radius + '&' + "sensor=" + sensor +  '&' + "key=" + key

    url = combine

    logger.debug(url)

    result = open(url) do |file|
      JSON.parse(file.read)
    end

    @results = result['results']
    logger.debug(result['results'])

    logger.debug("************************index-end")

    
  end

   
end
