module ConnectFour
  class Player
    attr_reader :name, :piece

    def initialize(attributes = {})
      assert_valid_player_attributes!(attributes)

      @name = attributes[:name]
      @piece = attributes[:piece].to_sym
    end

    def to_s(options = { formatted: false, color_map: {} })
      formatted_piece = Piece.new(self.piece).to_s(options)
      formatted_name = if options[:formatted]
                         self.name.colorize(options[:color_map][self.piece])
                       else
                         self.name
                       end
      "#{formatted_name} playing with piece #{formatted_piece}"
    end

    def human?
      true
    end

    private

    def assert_valid_player_attributes!(attributes)
      raise ConnectFour::MissingPlayerAttribute if attributes[:name].nil?
      raise ConnectFour::MissingPlayerAttribute if attributes[:piece].nil?
    end
  end
end
