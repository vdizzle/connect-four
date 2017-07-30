module ConnectFour
  class Piece
    attr_reader :value

    def initialize(value)
      @value = (value || '').to_sym
    end

    def to_s(options = { formatted: false, color_map: {} })
      return ' ' if value.blank?
      return value.to_s.upcase unless options[:formatted]
      color = options[:color_map][value]
      color.nil? ? value.to_s.upcase: '•'.colorize(color)
    end
  end
end
