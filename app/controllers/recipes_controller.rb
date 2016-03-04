require 'open-uri'

class RecipesController < ApplicationController
  def new
  end

  def show
    raw_url = params[:url]
    address_url_safe = URI.encode(raw_url)
    doc = Nokogiri::HTML(open(address_url_safe))

    @image = doc.search('img').first.attr('src')

    raw_title = doc.at("[@itemprop = 'name']")
    @raw_title = raw_title.text.strip unless (raw_title.nil? || raw_title.blank?)

    raw_recipeYield = doc.at("[@itemprop = 'recipeYield']")
    @recipeYield = raw_recipeYield.text.strip unless (raw_recipeYield.nil? || raw_recipeYield.blank?)

    raw_prepTime = doc.at("[@itemprop = 'prepTime']")
    # @prepTime = raw_prepTime.text.strip unless (raw_prepTime.nil? || raw_prepTime.blank?)
    @prepTime = raw_prepTime.attr('content').gsub(/[^\d]/, '')

    raw_cookTime = doc.at("[@itemprop = 'cookTime']")
    # @cookTime = raw_cookTime.text.strip unless (raw_cookTime.nil? || raw_cookTime.blank?)
    @cookTime = raw_cookTime.attr('content').gsub(/[^\d]/, '')

    raw_totalTime = doc.at("[@itemprop = 'totalTime']")
    @totalTime = raw_totalTime.text.strip unless (raw_totalTime.nil? || raw_totalTime.blank?)
    puts raw_totalTime.attr('content')

    raw_description = doc.at("[@itemprop = 'description']")
    @description = raw_description.text.strip unless (raw_description.nil? || raw_description.blank?)

    recipe = doc.css("div[itemtype='http://schema.org/Recipe']")
    recipe_items = doc.css("div[itemtype='http://schema.org/Recipe']").css("li")

    @ingredients = []
    recipe_items.each do |item|
      @ingredients << item if item.attr('itemprop') == 'ingredients'
    end

    @directions = []
    recipe_items.each do |item|
      unless item.attr('itemprop') == 'ingredients'
        @directions << item
      end
    end

  end
end

