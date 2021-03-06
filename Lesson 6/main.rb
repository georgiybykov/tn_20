require 'pry'
require_relative 'manufacturer'
require_relative 'instance_counter'
require_relative 'validate'
require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'railcar'
require_relative 'passenger_railcar'
require_relative 'cargo_railcar'

class RailRoad

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @railcars = []
  end

  ACTIONS = {
    exit: 0,
    create_new_station: 1,
    create_new_train: 2,
    create_a_route: 3,
    set_train_route: 4,
    hook_the_railcar_to_the_train: 5,
    unhook_the_railcar_from_the_train: 6,
    send_the_train_to_the_station: 7,
    move_the_train_one_station_forward_or_back: 8,
    show_the_list_of_the_stations: 9,
    show_the_list_of_the_trains_for_the_station: 10
  }

  def start
    puts %Q(
      0. Exit
      1. Create new station
      2. Create new train
      3. Create a route
      4. Set train route
      5. Hook the railcar to the train
      6. Unhook the railcar from the train
      7. Send the train to the station
      8. Move the train one station forward or back
      9. Show the list of the stations
      10. Show the list of the trains for the station
    )

    loop do
      print 'Type here the action number: '
      action = gets.chomp.to_i

      case action
      when ACTIONS[:exit]
        puts 'See you later! Good bye.'
        break
      when ACTIONS[:create_new_station]
        create_new_station
      when ACTIONS[:create_new_train]
        create_new_train
      when ACTIONS[:create_a_route]
        create_a_route
      when ACTIONS[:set_train_route]
        set_train_route
      when ACTIONS[:hook_the_railcar_to_the_train]
        hook_the_railcar_to_the_train
      when ACTIONS[:unhook_the_railcar_from_the_train]
        unhook_the_railcar_from_the_train
      when ACTIONS[:send_the_train_to_the_station]
        send_the_train_to_the_station
      when ACTIONS[:move_the_train_one_station_forward_or_back]
        move_the_train_one_station_forward_or_back
      when ACTIONS[:show_the_list_of_the_stations]
        show_the_list_of_the_stations
      when ACTIONS[:show_the_list_of_the_trains_for_the_station]
        show_the_list_of_the_trains_for_the_station
      else
        puts 'You have to choose one of the actions above.'
      end
    end
  end

  private

  # методы ниже вызываются только в классе RailRoad

  def create_new_station
    puts 'Create new station'
    puts 'What is the name of the station?'
    name = gets.chomp
    @stations << Station.new(name)
    puts "Station #{name} has been created."
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def create_new_train
    puts 'Create new train'
    puts 'What is the number of the train?'
    number = gets.chomp
    print 'Type 1 for passenger type of train or 2 for cargo type of train: '
    choice = gets.chomp.to_i
    case choice
    when 1
      @trains << PassengerTrain.new(number)
      puts "Passenger train #{number} has been created."
    when 2
      @trains << CargoTrain.new(number)
      puts "Cargo train #{number} has been created."
    else
      puts 'The train has not been created. You had to type 1 or 2 to make a choice.'
    end
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def create_a_route
    puts 'Menu to create a route'
    puts 'Type number for: 1 - Create new route; 2 - Add station to the route; 3 - Remove station from the route'
    choice = gets.chomp.to_i
    case choice
    when 1
      create_new_route
    when 2
      add_station_to_the_route
    when 3
      remove_station_from_the_route
    end
  end

  def create_new_route
    puts 'Create new route'
    if @stations.count < 2
      puts 'You have to create 2 stations at least to create new route.'
      return
    end
    puts 'Choose station from the list to set it first station of the route: '
    @stations.each_with_index { |station, number| puts "#{number}. #{station.name}" }
    print 'Type the INDEX NUMBER of the station: '
    last_station = first_station = @stations[gets.chomp.to_i]
    loop do
      puts 'Choose station from the list to set it last station of the route: '
      @stations.each_with_index { |station, number| puts "#{number}. #{station.name}" }
      print 'Type the INDEX NUMBER of the station: '
      last_station = @stations[gets.chomp.to_i]
      if last_station == first_station
        puts 'This station already exists in the route.'
      else
        break
      end
    end
    @routes << Route.new(first_station, last_station)
    puts "The route #{@routes.last.name} has been created."
  end

  def add_station_to_the_route(route = nil)
    puts 'Add station to the route'
    if route.nil?
      puts 'Type the INDEX NUMBER of the route from available: '
      @routes.each_with_index { |route, number| puts "#{number}. #{route.name}" }
      route = @routes[gets.chomp.to_i]
    end

    puts "The route #{route.name}. The list of the stations: "
    @stations.each_with_index { |station, number| puts "#{number}. #{station.name}" }
    print 'Type the INDEX NUMBER of the station: '
    new_station = @stations[gets.chomp.to_i]
    puts new_station.name
    return if new_station.nil?

    route.add_station(new_station)
    puts route.stations.map(&:name).join(' - ')
  end

  def remove_station_from_the_route
    puts 'Remove station from the route'
    puts 'The list of the routes: '
    @routes.each_with_index { |route, number| puts "#{number}. #{route.name}" }
    print 'Type the INDEX NUMBER of the route: '
    route = @routes[gets.chomp.to_i]
    return if route.nil?

    route.name
    puts 'The list of the stations of the route: '
    route.stations.each_with_index { |station, number| puts "#{number}. #{station.name}" }
    print 'Type the INDEX NUMBER of the station to delete it from the route: '
    station = route.stations[gets.chomp.to_i]
    route.remove_station(station)
    puts "The station #{station.name} was deleted from the route."
  end

  def set_train_route
    puts 'Set train route'
    if @trains.nil?
      puts 'There are no trains available.'
      return
    end
    puts 'Type the INDEX NUMBER of the train to set train route. The list of available trains: '
    @trains.each_with_index { |train, number| puts "#{number}. #{train.number}" }
    train = @trains[gets.chomp.to_i]
    puts "You have chosen the train #{train.number}."
    if @routes.nil?
      puts 'There are no available routes.'
      return
    end
    puts 'Type the INDEX NUMBER of the route. The list of available routes: '
    @routes.each_with_index { |route, number| puts "#{number}. #{route.name}" }
    route = @routes[gets.chomp.to_i]
    train.take_route(route)
    puts 'The route for the train has been set.'
  end

  def hook_the_railcar_to_the_train
    puts 'Hook the railcar to the train'
    if @trains.empty?
      puts 'You have to create a train first.'
    else
      puts 'What is the NUMBER of the train you would like to hook the railcar?'
      @trains.each_with_index { |train, number| puts "#{number}. #{train.number}" }
      number = gets.chomp
      train = @trains.find { |train| train.number == number }
      if train.nil?
        puts 'The train with this number does not exist.'
      else
        train.add_railcar(RailCar.new(train.type))
      end
    end
  end

  def unhook_the_railcar_from_the_train
    puts 'Unhook the railcar from the train'
    if @trains.empty?
      puts 'You have to create a train first.'
    else
      puts 'What is the NUMBER of the train you would like to unhook the railcar?'
      @trains.each_with_index { |train, number| puts "#{number}. #{train.number}" }
      number = gets.chomp
      train = @trains.find { |train| train.number == number }
      if train.nil?
        puts 'The train with this number does not exist.'
      else
        train.remove_railcar(train.railcars.last)
      end
    end
  end

  def send_the_train_to_the_station
    puts 'Send the train to the station'
    if @trains.empty?
      puts 'You have to create a train first.'
    elsif @stations.empty?
      puts 'You have to create a station first.'
    else
      puts 'Type the NUMBER of the train you would like to get to the station: '
      @trains.each_with_index { |train, number| puts "#{number}. #{train.number}" }
      number = gets.chomp
      train = @trains.find { |train| train.number == number }
      if train.nil?
        puts 'The train with this number does not exist.'
      else
        puts 'What is the NAME of the station?'
        @stations.each_with_index { |station, number| puts "#{number}. #{station.name}" }
        name = gets.chomp
        station = @stations.find { |station| station.name == name }
        if station.nil?
          puts 'The station with this name does not exist.'
        else
          station.get_train(train)
          puts "The train #{train.number} has been sent to the station #{station.name}."
        end
      end
    end
  end

  def move_the_train_one_station_forward_or_back
    puts 'Move the train one station forward or back on the route'
    puts 'Choose the INDEX NUMBER of the train: '
    @trains.each_with_index { |train, number| puts "#{number}. #{train.number}" }
    train = @trains[gets.chomp.to_i]
    return if train.nil?
    puts "You have chosen the train #{train.number}."

    if train.route.nil?
      puts "The route had not been set for the train #{train.number}."
    else
      puts 'Type your choise: 1 - move the train one station forward; 2 - move the train one station back'
      choise = gets.chomp.to_i
      case choise
      when 1
        train.go_one_station_forward
        puts "The train #{train.number} has gone to the next station."
      when 2
        train.go_one_station_back
        puts "The train #{train.number} has gone to the previous station."
      end
    end
  end

  def show_the_list_of_the_stations
    puts 'The list of the stations: '
    @stations.each { |station| puts station.name }
  end

  def show_the_list_of_the_trains_for_the_station
    puts 'The list of the trains for the station'
    if @stations.empty?
      puts 'You have to create a station first.'
    else
      puts 'What is the NAME of the station?'
      @stations.each_with_index { |station, number| puts "#{number}. #{station.name}" }
      name = gets.chomp
      station = @stations.find { |station| station.name == name }
      if station.nil?
        puts 'The station with this name does not exist.'
      else
        puts "The list of the trains for the station #{station.name}: "
        station.show_trains_by_type
      end
    end
  end
end

RailRoad.new.start
