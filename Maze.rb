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

	def redesign()
	end
end

#Provide solution for maze
class Advanturer
	def initialize(x_length,y_length)
		@y_length=y_length
		@x_length=x_length
		@trace=[]
	end
	def check_south(point)
		y,x=point.position
		if y+1<@y_length and @map[y+1][x].undected?
			return true
		else 
			return false
		end
	end
	
	def check_north(point)
		y,x=point.position
		if y-1>=0 and @map[y-1][x].undected?
			return true
		else 
			return false
		end
	end
	def check_east(point)
		y,x=point.position
		if x+1<@x_length and @map[y][x+1].undected?
			return true
		else
			return false
		end
	end
	def check_west(point)
		y,x=point.position
		if x-1>=0 and @map[y][x-1].undected?
			return true
		else
			return false
		end

	end
	#refract here !!!
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

	def DFS(current_point,target_point,path)
		if current_point.eq(target_point)
			path.push current_point
			@trace=path			
			return 'found'
		end
		
		current_y,current_x=current_point.position
		target_y,target_x=target_point.position
		current_point.detect_it		

		
		#if current_y+1<@y_length and @map[current_y+1][current_x].undected?
		if check_south(current_point)
			puts "##"			
			path.push current_point
			next_point=  @map[current_y+1][current_x]		
			flag=DFS(next_point,target_point,path)
			if flag=='found'
				return flag
			end
		end
		if check_north(current_point)
			path.push current_point
			next_point= @map[current_y-1][current_x]
			flag=DFS(next_point,target_point,path)
			if flag=='found'
				return flag
			end
		end
		if check_east(current_point)
			path.push current_point
			next_point=@map[current_y][current_x+1]
			flag=DFS(next_point,target_point,path)
			if flag=='found'
				return flag
			end
		end
		if check_west(current_point)
			path.push current_point
			next_point=@map[current_y][current_x-1]
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


	def detect_it
		if @state=='undetected'
			@state='detected'
		end
	end
end



