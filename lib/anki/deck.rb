# coding: utf-8
require 'fileutils'

module Anki
  class Deck
    attr_accessor :card_headers,:card_data, :user_media_dir

    def initialize(options = {})
      @card_headers   = options.delete(:card_headers)
      @card_data      = options.delete(:card_data)
      @user_media_dir = options.delete(:user_media_dir){ Dir.pwd }
    end

    def generate_deck(options = {})
      raise ArgumentError, "card_headers must be an array"  unless self.card_headers.is_a?(Array)
      raise ArgumentError, "card_headers must not be empty" if     self.card_headers.empty?
      raise ArgumentError, "card_data must be an array"     unless self.card_data.is_a?(Array)
      raise ArgumentError, "card_data must not be empty"    if     self.card_data.empty?
      
      copy_media_to_anki_media_dir

      anki_string = ""
      anki_string << card_header_to_string()
      anki_string << self.card_data.map { |card| card_data_to_string(card) }.compact.join("\n")
      create_file(anki_string, options[:file]) if options[:file]
      anki_string
    end

    private

    def copy_media_to_anki_media_dir
      copy_images
      copy_audio
      copy_video
    end

    def copy_images
      card_data.collect do |st|
        images = st.scan(/src=['"](.+?)['"]/).flatten
        copy_to_anki_media_dir(images) if images.any? 
      end
    end

    def copy_audio
    end

    def copy_video
    end

    def copy_to_anki_media_dir(media)
      if media.is_a?(Array)
        media.each {|f| copy_to_anki_media_dir(f)}
      end
      FileUtils.cp(user_media_dir, '/opt/new/location/your_file')
    end

    def card_header_to_string()
      "#" + self.card_headers.join(";") + "\n"
    end

    def card_data_to_string(card)
      raise ArgumentError, "card must be a hash" if !card.is_a?(Hash)

      card.default = ""

      self.card_headers.map{ |header| card[header] }.join(";")
    end

    def create_file(str, file)
      File.open(file, 'w') { |f| f.write(str) }
    end

    def anki_media_dir
      if OS.windows? 
        "%UserProfile%\Anki\User 1\collection.media"
      elsif OS.mac?
        "~/Documents/Anki/User 1/collection.media"
      else
      end
    end
  end
end
