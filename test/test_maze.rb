require 'minitest/autorun'
require './Maze.rb'

describe Maze do 
	it "test init" do
		@mz=Maze.new(5,4)
	end

	it "test load and display" do
		arg="11111001011000111100"
		@mz=Maze.new(5,4)
		@mz.load(arg)
		@mz.display	
		puts @mz.solve(1,1,1,0)
		(@mz.trace(1,1,1,0)).each do |point|
			puts point.to_str
		end
		@mz=Maze.new(5,5)
		@mz.redesign
		puts ""
		@mz.display
		#MazeGenerator.generate(Point.new(0,0))
	end
end
