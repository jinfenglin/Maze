require 'minitest/autorun'
require './Maze.rb'

describe Maze do 

	it "test load and display" do
		arg="11111101011000111111"
		@mz=Maze.new(5,4)
		@mz.load(arg)
		@mz.display
		assert_output(output="11111\n10101\n10001\n11111\n"){@mz.display}	
	end

	it "test solve" do
		arg="11111101011000111111"
		@mz=Maze.new(5,4)
		@mz.load(arg)
		assert_equal @mz.solve(1,1,1,3),'found'
		assert_equal @mz.solve(1,1,1,4), []
	end

	it "test trace" do
		arg="11111101011000111111"
		@mz=Maze.new(5,4)
		@mz.load(arg)
		assert_equal @mz.trace(1,1,1,3),["(1,1)","(2,1)","(2,2)","(2,3)","(1,3)"]
		assert_equal @mz.trace(1,1,3,4), []

	end

	it "test maze generator to regenerate" do
		@mz=Maze.new(10,10)
		map=@mz.redesign
		@mz.load(map)
		@mz.display
		#check it manually

	end
end
