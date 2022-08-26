require 'json'

class HighMotivationUserAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    datas = []
    @channel_names.map { |channel|
      data = {}
      data[:channel_name] = channel
      data[:message_count] = load(channel)["messages"].count
      datas << data
    }
    datas.sort_by{|x| -x[:message_count]}.first(3)
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end