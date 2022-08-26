require 'json'

class KindUserAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    reactions = []
    @channel_names.map { |channel|
      messages = load(channel)["messages"]
      messages.map { |message|
        if message.has_key?("reactions")
          reactions << message["reactions"]
        end
      }
    }
  
  users = []
  reactions.map{ |reaction|
    users << reaction.map{ |data| data["users"]}
  }
  
  users = users.flatten.group_by(&:itself)

  datas = []
  users.map{ |key, value|
    data = {}
    data[:user_id] = key
    data[:reaction_count] = value.count
    datas << data
  }

  datas.sort_by{|x| -x[:reaction_count]}.first(3)
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end