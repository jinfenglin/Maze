require 'minitest/autorun'
require './Maze.rb'

describe Maze do 
	it "test init" do
		@mz=Maze.new(5,4)
	end

	it "test load and display" do
		arg="11111101011000111100"
		@mz=Maze.new(5,4)
		@mz.load(arg)
		@mz.display	
		puts @mz.solve(1,1,3,4)
		(@mz.trace(1,1,3,4)).each do |point|
			puts point.to_str
		end
	end
end