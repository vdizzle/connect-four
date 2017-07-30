module ConnectFour
  class InvalidBoardSize < StandardError; end
  class InvalidPlayerCount < StandardError; end
  class InvalidPlayerType < StandardError; end
  class DuplicatePlayer < StandardError; end
  class InvalidMove < StandardError; end
  class PositionNotOpen < StandardError; end
  class MissingPlayerAttribute < StandardError; end
end
