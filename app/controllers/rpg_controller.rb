class RpgController < ApplicationController
	def get_time
		time = DateTime.now
		right_now = "(" + time.strftime("%b %d, %Y %I:%M %P") + ")"
		return right_now
	end
	def index
		if !session[:gold]
			session[:gold] = 0
		end
		if !session[:log]
			message = 'Joined Ninja Gold ' + get_time
			session[:log] = []
			session[:log] << message
		elsif session[:arena] == 'farm' || session[:arena] == 'cave' || session[:arena] == 'house' 
			message = "Just made #{session[:new_gold]} gold in the #{session[:arena]} " + get_time
			session[:log] << message
		elsif session[:arena] == 'casino' && session[:new_gold] >= 0
			message = "Went in to a casino...came out a WINNER with #{session[:new_gold]} gold! " + get_time
			session[:log] << message
		elsif session[:arena] == 'casino' && session[:new_gold] < 0
			message = "Went in to a casino...came out a LOSER and #{-session[:new_gold]} gold broker. " + get_time
			session[:log] << message
		end
		@activities = session[:log]
		@gold = session[:gold]
		render 'home'
	end

	def farm
		session[:new_gold] = rand(10..20)
		session[:arena] = 'farm'
		session[:gold] += session[:new_gold]
		@gold = session[:gold]
		redirect_to :action => :index
	end

	def cave
		session[:new_gold] = rand(5..10)
		session[:arena] = 'cave'
		session[:gold] += session[:new_gold]
		@gold = session[:gold]
		redirect_to :action => :index
	end

	def house
		session[:new_gold] = rand(2..5)
		session[:arena] = 'house'
		session[:gold] += session[:new_gold]
		@gold = session[:gold]
		redirect_to :action => :index
	end

	def casino
		odds = rand(0..100)
		if odds < 30
			session[:new_gold] = rand(0..50)
			session[:arena] = 'casino'
			session[:gold] += session[:new_gold]
			@gold = session[:gold]
		else
			session[:new_gold] = rand(-50..0)
			session[:arena] = 'casino'
			session[:gold] += session[:new_gold]
			@gold = session[:gold]
		end
		redirect_to :action => :index
	end

	def destroy
		session.clear
		redirect_to :root
	end
end

# Earned 42 gold from the farm (2013/09/03 4:50pm)