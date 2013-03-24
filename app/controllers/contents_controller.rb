# coding: utf-8
class ContentsController < ApplicationController
  require 'json'
  require 'net/https'
  
  def index
  end
  
  def search

   begin
    # session登録
    session[:current_lat] = params[:lat].to_f
    session[:current_lng] = params[:lng].to_f
    session[:current_radius] = params[:radius].to_i
    session[:current_types] = params[:check]

    # GooglePlaces 基本URL
    baseurl = "/maps/api/place/search/json?"

    # GooglePlaces types文字列の作成
    types = ""
    params[:check].each do |ch|
      if types.blank?
        types += ch
      else
        types += "|" + ch
      end
    end

    # GooglePlaces 緯度経度をパラメーターから取得
    lat_f = params[:lat].to_f  #緯度
    lng_f = params[:lng].to_f  #経度
    radius_i = params[:radius].to_i  #探索半径（m）

    # GooglePlaces 検索用パラメーターの設定
    type = types  #対象
    sensor = "false"  #場所センサー取得フラグ
    language = "ja"  #言語
    key = ENV['GOOGLE_API_KEY']  #APIキー

    # GooglePlaces 変数初期化
    rnd_lat_s = Array.new(5, "")
    rnd_lng_s = Array.new(5, "")
    radius_s = (radius_i/2).to_s
    
    @results = []
    result_sum = []
    
    # GooglePlaces ランダムに地点を設定
    (0..4).each do |num|
      rnd_lat_s[num],rnd_lng_s[num] = randomLatlng(lat_f,lng_f,radius_i/2) 

      # GooglePlaces URL作成
      if types.blank?
        combine = baseurl + 'location=' + rnd_lat_s[num] + ',' + rnd_lng_s[num]  + '&' + 'radius=' + radius_s + '&' + "language=" + language + '&' + "sensor=" + sensor +  '&' + "key=" + key
      else
        combine = baseurl + 'location=' + rnd_lat_s[num] + ',' + rnd_lng_s[num]  + '&' + 'radius=' + radius_s + '&' + "language=" + language + '&' + "types=" + type + '&' + "sensor=" + sensor +  '&' + "key=" + key
      end

      url = combine
      logger.debug(url)
      
      # GooglePlaces 取得
      response = ""
      Net::HTTP.version_1_2
      https = Net::HTTP.new("maps.googleapis.com",443)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_PEER
      https.verify_depth = 5
      https.start {
        response = https.get(url)
       }
      result = JSON.parse(response.body)
       
      # GooglePlaces 地点が取得できた場合
      unless result['results'].blank?
        # GooglePlaces ランダムに一ヶ所を取得
        @result_rnd = result['results'][rand(result['results'].size)]
        # GooglePlaces 初回意外
        unless result_sum.blank?
          # GooglePlaces 場所がかぶらないように再取得（max5回）
          chk = 0
          while result_sum.include?(@result_rnd['id']) && chk < 5
            @result_rnd = result['results'][rand(result['results'].size)]
            chk += 1
            logger.debug(@result_rnd)
          end
        end
        # GooglePlaces idを被り防止のチェック用変数に設定
        result_sum.push(@result_rnd['id'])
        # GooglePlaces 取得した場所を返り値に設定
        @results.push(@result_rnd)
        
        logger.info("*****search-result*****")
        logger.info(result_sum)
      end
    end
    
   rescue
     redirect_to root_url    
   end
    
  end
  
  def randomLatlng(lat,lng,distance)
    
    # 定数
    lat_d = 0.111
    lng_d = 0.091
    
    # maxの探索範囲を設定
    x0 = lat - distance/lat_d*0.000001
    y0 = lng - distance/lng_d*0.000001
    x1 = lat + distance/lat_d*0.000001
    y1 = lng + distance/lng_d*0.000001
 
    # 探索範囲の距離を取得
    lat_dist = (x1 * 100000) - (x0 * 100000)
    lng_dist = (y1 * 100000) - (y0 * 100000)
    
    # 探索地点をランダムで取得
    lat_rnd = rand(lat_dist.to_i)
    lng_rnd = rand(lng_dist.to_i)

    # 探索地点を緯度経度に変換
    lat = x0 + (lat_rnd * 0.00001)
    lng = y0 + (lng_rnd * 0.00001)

    # 返す
    return lat.to_s,lng.to_s
  end

   
end
