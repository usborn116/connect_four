require_relative 'classes.rb'

game1 = Game.new

usborn = Player.new('Usborn', 0, game1, "\u{1F525}")
ash = Player.new('Ashley', 1, game1, "\u{1F327}")

game1.add_player(usborn)
game1.add_player(ash)

game1.play