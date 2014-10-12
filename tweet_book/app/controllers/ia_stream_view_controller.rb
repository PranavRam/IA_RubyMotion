class IAStreamViewController < UIViewController
  extend IB

  attr_accessor :account
  attr_accessor :updates

  outlet :tableView

  def viewDidLoad
    super
    @updates = []
    if @account.accountType.identifier == ACAccountTypeIdentifierTwitter
      retrieveTwitterStream
    end
  end

  def retrieveTwitterStream
      url = NSURL.URLWithString("https://api.twitter.com/1.1/statuses/user_timeline.json")
      params = {
        screen_name: @account.username
      }

      request = SLRequest.requestForServiceType(SLServiceTypeTwitter, requestMethod:SLRequestMethodGET, URL:url, parameters:params)

      request.setAccount(@account)
      request.performRequestWithHandler(lambda do |responseData, response, error|
        if response.statusCode == 200
          parsingError = Pointer.new('@')
          @updates = NSJSONSerialization.JSONObjectWithData(responseData, options:0, error:parsingError)

          Dispatch::Queue.main.sync { tableView.reloadData }
        end
      end)
  end

  def postToStream(sender)
    if @account.accountType.identifier == ACAccountTypeIdentifierTwitter
      postToTwitter
    else
      postToFacebook
    end
  end

  def postToFacebook
    if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)
      view = SLComposeViewController.composeViewControllerForServiceType(SLServiceTypeFacebook)
      presentViewController(view, animated:true, 
        completion:lambda {nil})
    end
  end

  def postToTwitter
    if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)
      view = SLComposeViewController.composeViewControllerForServiceType(SLServiceTypeTwitter)
      view.setInitialText("Boom! Tweeting this from an app I created while reading iOS in Action!")
      view.addURL(NSURL.URLWithString("http://manning.com"))
      presentViewController(view, animated:true, 
        completion:lambda{nil })
    end
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @updates.count
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @@cell_identifier = "updateCell"
    cell = tableView.dequeueReusableCellWithIdentifier(@@cell_identifier)
    update = @updates[indexPath.row]

    if @account.accountType.identifier == ACAccountTypeIdentifierTwitter
      cell.textLabel.text = update[:text]
      cell.detailTextLabel.text = update[:user][:name]
    end
    cell
  end
end