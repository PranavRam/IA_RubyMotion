class IAHTTPCommunication < NSObject

  attr_accessor :successBlock

  def retriveURL(url, successBlock: successBlock)
    @successBlock = successBlock
    request = NSURLRequest.alloc.initWithURL(url)

    conf = NSURLSessionConfiguration.defaultSessionConfiguration
    session = NSURLSession.sessionWithConfiguration(conf, delegate:self, delegateQueue: nil)
    task = session.downloadTaskWithRequest(request)
    task.resume  
  end

  def URLSession(session, downloadTask: downloadTask, didFinishDownloadingToURL: location)
    data = NSData.dataWithContentsOfURL(location)
    Dispatch::Queue.main.async do
      successBlock.call(data)
    end
  end

  def postURL(url, params: params, successBlock: successBlock)
    @successBlock = successBlock
    parametersArray = []
    params.each do |key, value|
      parametersArray.push("#{key}=#{value}")
    end

    postBodyString = parametersArray.join("&")
    postBodyData = NSData.dataWithBytes(postBodyString.UTF8String, length: postBodyString.length)
    request = NSMutableURLRequest.alloc.initWithURL(url)
    request.setHTTPMethod("POST")
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
    request.setHTTPBody(postBodyData)

    conf = NSURLSessionConfiguration.defaultSessionConfiguration
    session = NSURLSession.sessionWithConfiguration(conf, delegate:self, delegateQueue: nil)
    task = session.downloadTaskWithRequest(request)
    task.resume
  end
end