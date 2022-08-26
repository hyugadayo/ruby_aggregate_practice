class PopularMessageAggregator
  attr_accessor :channel_names

  def initialize(channel_names)
    @channel_names = channel_names
  end

  # 実装してください
  def exec
    datas =[]
    @channel_names.map{ |channel|
      messages = load(channel)["messages"]
      messages.map{ |message|
        if message.has_key?("reactions")
          data = {}
          data[:text] = message["text"]
          reactions = message["reactions"]
          data[:reaction_count] = reactions.map{|x| x["count"]}.sum
          datas << data
        end
      }
    }
    
    datas.sort_by{ |x| -x[:reaction_count] }.first
  end

  def load(channel_name)
    dir = File.expand_path("../data/#{channel_name}", File.dirname(__FILE__))
    file = File.open(dir)
    JSON.load(file)
  end
end