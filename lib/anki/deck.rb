# coding: utf-8
module Anki
  class Deck
    attr_accessor :card_data

    def initialize(options = {})
      @card_data = options.delete(:card_data)
    end

    def generate_deck(options = {})
      raise ArgumentError, "card_data should be an array of hashes" if !self.card_data.is_a?(Array)
      raise ArgumentError, "You need card data." if self.card_data.empty?

      anki_string = self.card_data.map { |card| card_data_to_string(card) }.compact.join("\n")
      create_file(anki_string, options[:file]) if options[:file]
      anki_string
    end

    private

    def card_data_to_string(card)
      front_card = card.keys.first
      back_card = card.values.first

      if back_card.is_a?(String)
        "#{front_card};#{back_card}"
      elsif back_card.is_a?(Hash)
        back_card_value = back_card["value"]
        tags = back_card["tags"].join(" ")
        "#{front_card};#{back_card_value};#{tags}"
      end
    end

    def create_file(str, file)
      File.open(file, 'w') { |f| f.write(str) }
    end
  end
end
