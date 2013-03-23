# coding: utf-8
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  # ログインユーザhelper
  helper_method :current_lat, :current_lng,:current_radius,:current_types

  # ログインユーザ設定
  private
  def current_lat
    @current_lat = session[:current_lat]
  end
  def current_lng
    @current_lng = session[:current_lng]
  end
  def current_radius
    @current_radius = session[:current_radius]
  end
  def current_types
    @current_types = session[:current_types]
  end

end
