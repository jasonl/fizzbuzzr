require 'serfx'
require 'curses'
require 'socket'

include Curses

@me = ARGV[0]
@role = ARGV[1]
@event = nil
@result = nil
@display_time = nil

class DistributedCounter
  def initialize(divisble_by, my_hostname)
    @divisble_by = divisble_by
    @my_hostname = my_hostname
    @counter_hostnames = []
    @position = -1
  end

  def update_members(counter_hostnames)
    @counter_hostnames = counter_hostnames
    @position = counter_hostnames.sort.index(@my_hostname) || -1
  end

  def shows_for?(number)
    number % @divisble_by == 0 &&
      number / @divisble_by % @counter_hostnames.length == @position
  end
end

@fizzer = DistributedCounter.new(3, ARGV[0])
@buzzer = DistributedCounter.new(5, ARGV[0])

def setup
  init_screen
  start_color
  curs_set(0)
  init_pair(COLOR_YELLOW, COLOR_BLACK, COLOR_YELLOW)
  init_pair(COLOR_RED, COLOR_RED, COLOR_BLACK)
  clear
  refresh
end

def render_frame
  clear
  setpos(lines - 1, 0)
  if @event
    attron(color_pair(COLOR_YELLOW)) do
      addstr(@event.ljust(cols))
    end
  else
    addstr(@me)
  end
  @event = nil


  setpos(2, 0)
  addstr(@display_time.center(cols))

  setpos(3, 0)
  attron(color_pair(COLOR_RED)) do
    if @result
      addstr(@result.center(cols))
    else
      addstr(' ' * cols)
    end
    @result = nil
  end
  refresh
end

def update_counters_with_live_members(conn)
  @fizzer.update_members(live_members_for(conn, 'fizz'))
  @buzzer.update_members(live_members_for(conn, 'buzz'))
end

def live_members_for(conn, role)
  conn.members_filtered({'role' => role}, 'alive').body['Members'].map { |member| member['Name'] }
end

def display_event(event)
  members = event['Members']
  host = members && members[0] && members[0]['Name']
  @event = "Event: #{event['Event']} #{host}"
end

def calculate_result(time_i)
  if @fizzer.shows_for?(time_i)
    @result = "FIZZ"
  elsif @buzzer.shows_for?(time_i)
    @result = "BUZZ"
  else
    @result = nil
  end
end

setup

begin
  Serfx.connect do |conn|
    update_counters_with_live_members(conn)

    res, thread = conn.stream('*') do |event|
      display_event(event)
      update_counters_with_live_members(conn)
    end

    while(true) do
      calculate_result(Time.now.to_i)
      @display_time = Time.now.strftime("%H:%M:%S")
      render_frame
      sleep(1)
    end
  end
ensure
  close_screen
end
