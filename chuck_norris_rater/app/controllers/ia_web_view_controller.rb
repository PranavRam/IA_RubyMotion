class IAWebViewController < UIViewController
  extend IB

  outlet :web_view

  def viewDidLoad
    super
    request = NSURLRequest.requestWithURL(NSURL.URLWithString("http://en.wikipedia.org/wiki/Chuck_Norris"))
    @web_view.loadRequest(request)
  end

  def close(sender)
    dismissViewControllerAnimated(true, completion: nil)
  end

  def back(sender)
    web_view.goBack
  end

  def next(sender)
    web_view.goForward
  end
end