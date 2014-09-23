class IAViewController < UIViewController
  extend IB

  outlet :joke_label

  attr_accessor :joke_id

  def viewDidLoad
    super
    joke_label.setText("")
    retrieveRandomJokes(self)
  end

  def retrieveRandomJokes(sender)
    http = IAHTTPCommunication.alloc.init
    url = NSURL.URLWithString("http://api.icndb.com/jokes/random")
    http.retriveURL(url, 
      successBlock: lambda do |response|
        error = Pointer.new('@')
        data = NSJSONSerialization.JSONObjectWithData(response, options: 0, error: error)
        if(!error[0])
          value = data["value"]
          if(value && value["joke"])
            @joke_id = value["id"]
            joke_label.setText(value["joke"])
          end
        end
      end)
  end

  def thumbUp(sender)
    url = NSURL.URLWithString("http://example.com/rater/vote")
    http = IAHTTPCommunication.alloc.init
    params = {
      joke_id: joke_id,
      vote: 1
    }

    http.postURL(url, params: params, 
      successBlock: lambda do |response|
        p "Voted Up!"
      end)
  end

  def thumbDown(sender)
    url = NSURL.URLWithString("http://example.com/rater/vote")
    http = IAHTTPCommunication.alloc.init
    params = {
      joke_id: joke_id,
      vote: -1
    }

    http.postURL(url, params: params, 
      successBlock: lambda do |response|
        p "Voted Down!"
      end)
  end
end