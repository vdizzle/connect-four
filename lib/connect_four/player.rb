module ConnectFour
  class Player
    attr_reader :name, :piece

    def initialize(options = {})
      raise ConnectFour::MissingPlayerAttribute if options[:name].nil?
      raise ConnectFour::MissingPlayerAttribute if options[:piece].nil?

      @name = options[:name]
      @piece = options[:piece].to_sym
    end

    def to_s(options = { formatted: false, color_map: {} })
      "#{self.name} playing with piece #{Piece.new(self.piece).to_s(options)}"
    end

    def human?
      true
    end
  end
end
