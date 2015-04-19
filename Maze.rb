#regulate maze information
class Maze 
	attr_accessor :x_length,:y_length
	def initialize(x_length,y_length) 
		@x_length=x_length
		@y_length=y_length
		@map=[] #2D array store the map of maze	
		@av=Advanturer.new(x_length,y_length)

	end
	def load(arg)
		(0..@y_length-1).each do |y_counter|	
			current_line=[]
			(0..@x_length-1).each do |x_counter|
				index=@x_length*y_counter+x_counter
				if arg[index]=='1' #1 is wall
					current_line.push Point.new(y_counter,x_counter,'wall')
				else 
					current_line.push Point.new(y_counter,x_counter,'undetected')
				end
			end
			@map.push(current_line)

		end
	end

	def display
		(0..@y_length-1).each do |y_counter|
			(0..@x_length-1).each do |x_counter|
				pt=@map[y_counter][x_counter]
				if pt.wall?
					print '1'
				else
					print '0'
				end 
			end
			puts ""
		end
		STDOUT.flush
	end

	def solve(begy,begx,endy,endx)
		return @av.solve(begy,begx,endy,endx,@map)
	end

	def trace(begx,begy,endy,endx)
		return @av.trace(begy,begx,endy,endx,@map)
	end
	#recursive division algorithm
	def redesign()
		mg=MazeGenerator.new(@x_length,@y_length)
		@map=mg.generate(Point.new(0,0,'undetected'),Point.new(@y_length-1,@x_length-1,'undetected'))
		

	end
end
class MazeGenerator
	def initialize(x_length,y_length)
		@x_length=x_length
		@y_length=y_length
		@map=[]
		reset()
	end
	
	def display
		(0..@y_length-1).each do |y_counter|
			(0..@x_length-1).each do |x_counter|
				pt=@map[y_counter][x_counter]
				if pt.wall?
					print '1'
				else
					print '0'
				end 
			end
			puts ""
		end
		STDOUT.flush
	end

	def reset()
		(0..@y_length).each do |y|
			temp_array=[]
			(0..@x_length).each do |x|
				if(x==0 or y==0 or x==@x_length-1 or y==@y_length-1)
					p=Point.new(y,x,"wall")
				else
					p=Point.new(y,x,"undetected")
				end
				temp_array.push(p)
			end
			@map.push(temp_array)
		end
		return @map
	end
	def drill_at_vertical(y_north,y_south,x)	
		y=rand(y_north..y_south)
		@map[y][x].set_undetected
	end
	def drill_at_horizontal(x_west,x_east,y)
		x=rand(x_west..x_east)
		@map[y][x].set_undetected
	end
	def generate_walls(split_point,north_corner,south_corner)
		y,x=split_point.position
		y_north_bound,x_north_bound = north_corner.position
		y_south_bound,x_south_bound = south_corner.position
		hole_num=1
		
		(x_north_bound..x_south_bound).each do |iter_x|			
			@map[y][iter_x].set_wall
		end
		(y_north_bound..y_south_bound).each do |iter_y|
			@map[iter_y][x].set_wall
		end
		num=rand(1..4)
		if (num!= 1)
		
			drill_at_vertical(y_north_bound+1,y-1,x)
		end
		if (num!=2)
			drill_at_vertical(y+1,y_south_bound-1,x)
		end
		if (num!=3)
			drill_at_horizontal(x_north_bound+1,x-1,y)
		end
		if (num!=4)
			drill_at_horizontal(x+1,x_south_bound-1,y)
		end
	end
	
	#North
	#*----*----*
	#|    |    |
	#|----sp---|	   
	#|    |	   |
	#|    |	   |
	#*----*----*
	#South
	def generate(north_west_corner,south_east_corner)
		n_y,n_x=north_west_corner.position
		s_y,s_x=south_east_corner.position
		split_point=Point.new(rand(n_y+2..s_y-2),rand(n_x+2..s_x-2),'wall')
		if(split_point.x==nil or split_point.y==nil)
			puts "sp point null:(#{n_y+2},#{s_y-2}):(#{n_x+2},#{s_x-2})"
			return @map
		end
		puts "split point:#{split_point.to_str}"
		generate_walls(split_point,north_west_corner,south_east_corner)
		puts "bound:(#{n_y},#{n_x}):(#{s_y},#{s_x})"
		display

		sp_y,sp_x=split_point.position
		north_east_corner=Point.new(n_y,s_x,'wall')
		south_west_corner=Point.new(s_y,n_x,'wall')
		north_middle=Point.new(n_y,sp_x,'wall')
		south_middle=Point.new(s_y,sp_x,'wall')
		west_middle=Point.new(sp_y,n_x,'wall')
		east_middle=Point.new(sp_y,s_x,'wall')

		generate(north_west_corner,split_point)
		puts "second time"
		generate(north_middle,east_middle)
		generate(west_middle,south_middle)
		generate(split_point,south_east_corner)		
	end
end

#Provide solution for maze
class Advanturer
	def initialize(x_length,y_length)
		@y_length=y_length
		@x_length=x_length
		@trace=[]
	end
	
	def solve(begy,begx,endy,endx,map)
		start_point=map[begy][begx]
		end_point=map[endy][endx]
		@map=map
		flag= DFS(start_point,end_point,[])
		return flag
	end
	def trace(begy,begx,endy,endx,map)
		start_point=map[begy][begx]
		end_point=map[endy][endx]
		@map=map
		flag= DFS(start_point,end_point,[])
		return @trace

	end
	def check_location(y,x)		
		if (0..@y_length-1).include?(y) and (0..@x_length-1).include?(x) and @map[y][x].undected?
			return true
		else
			return false
		end
	end
	def get_point(y,x)
		if check_location(y,x)
			return @map[y][x]
		else
			return nil
		end
	end

	def DFS(current_point,target_point,path)
		if current_point.eq(target_point)
			path.push current_point
			@trace=path			
			return 'found'
		end
		

		#try 4 direction, test the point
		try_array=[]
		current_point.detect_it	
		current_point.directions.each do |direction|
			y,x=direction.call
			candidate=get_point(y,x)
			try_array.push candidate
		end
		try_array.compact!
		#reorder to make it more likely to get the destination
		
		try_array.sort!{ |p1,p2|	
			p1.distance(target_point) <=> p2.distance(target_point)
		}

		try_array.each do |next_point|	
			path.push current_point
			flag=DFS(next_point,target_point,path)
			if flag=='found'
				return flag
			end
		end
	end

end

#point stands the status of a certain point: wall,detected,undected
class Point
	attr_accessor :x
	attr_accessor :y
	attr_accessor :state
	attr_accessor :directions
	def eq(pt)
		if(pt.x==@x and pt.y==@y and pt.state=@state)
			return true
		else
			return false
		end
	end
	def initialize(y,x,state)
		@state=state
		@x=x
		@y=y
		@directions=[method(:north),method(:south),method(:east),method(:west)]
	end

	def distance(point)
		return (point.x-x)*(point.x-x)+(point.y-y)*(point.y-y)
	end
	#return the point x,y
	def position 
		return @y,@x
	end
	def wall?
		return @state == 'wall'
	end
	def detected?
		return @state == 'detected'
	end
	def undected?
		return @state == 'undetected'
	end

	def to_str()
		puts "(#{@y},#{@x})"
       	end

	def north
		return y-1,x
	end
	def south
		return y+1,x
	end
	def east
		return y,x+1
	end
	def west
		return y,x-1
	end
	def set_wall()
		@state='wall'
	end
	def set_undetected
		@state='undetected'
	end
	def detect_it
		if @state=='undetected'
			@state='detected'
		end
	end
end



