module ConnectFour
  class Player
    attr_reader :name, :symbol

    def initialize(options = {})
      raise ConnectFour::InvalidPlayerAttribute if options[:symbol].nil?

      @name = options[:name] || 'Player'
      @symbol = options.fetch(:symbol).downcase
    end

    def human?
      true
    end
  end
end
