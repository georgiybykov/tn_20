class Train

  attr_reader :number_of_train, :type, :railcars, :speed

  def initialize(number_of_train, type)
    @number_of_train = number_of_train
    @type = type
    @railcars = []
    @speed = 0
  end

  def go(speed)
    @speed += speed
  end

  def stop
    @speed = 0
  end

  def add_railcar(railcar)
    return if !@speed.zero? || @type != railcar.type
    @railcars << railcar
  end

  def remove_railcar(railcar)
    @railcars.delete(railcar) if @speed.zero? && @type = railcar.type
  end

  def take_route(route)
    @route = route # route = Route.new
    @route.stations.first.get_train(self)
    @station_index = 0
  end

  def current_station
    return if @route.nil?
    @route.stations[@station_index]
  end

  def next_station
    return if @station_index == @route.stations.size - 1
    @route.stations[@station_index + 1]
  end

  def previous_station
    return if @station_index == 0
    @route.stations[@station_index - 1]
  end

  def go_one_station_forward
    return unless next_station
    @route.stations[@station_index].send_train(self)
    @route.stations[@station_index + 1].get_train(self)
  end

  def go_one_station_back
    return unless previous_station
    @route.stations[@station_index].send_train(self)
    @route.stations[@station_index - 1].get_train(self)
  end
end
