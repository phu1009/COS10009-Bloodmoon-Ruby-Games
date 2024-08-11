
require 'rubygems'
require 'gosu'

require_relative './Games/Games_Menu.rb'

records = Array.new()

# Open the Main menu window with the intro screen appearance first
Menu.new(0, records).show