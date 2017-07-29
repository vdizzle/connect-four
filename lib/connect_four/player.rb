module ConnectFour
  class Player
    attr_reader :name, :piece

    def initialize(options = {})
      raise ConnectFour::InvalidPlayerAttribute if options[:piece].nil?

      @name = options[:name] || 'Player'
      @piece = options.fetch(:piece).upcase
    end

    def human?
      true
    end
  end
end
