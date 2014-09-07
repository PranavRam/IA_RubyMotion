class IAViewController < UIViewController
  extend IB

  outlet :time_label
  outlet :mode_button

  def check_time(sender)
    formatter = NSDateFormatter.alloc.init
    formatter.setDateFormat("h:mm:ss a")
    self.time_label.setText(formatter.stringFromDate(NSDate.date))
    self.performSelector('check_time:', withObject: self, afterDelay: 1.0)
  end

  def viewDidLoad
    super
    check_time(self)
  end

  def toggle_mode(sender)
    if mode_button.titleLabel.text == "Night"
      view.backgroundColor = UIColor.blackColor
      time_label.textColor = UIColor.whiteColor
      mode_button.setTitle("Day", forState:UIControlStateNormal)
    else
      view.backgroundColor = UIColor.whiteColor
      time_label.textColor = UIColor.blackColor
      mode_button.setTitle("Night", forState:UIControlStateNormal)
    end
  end

  def willAnimateRotationToInterfaceOrientation(interfaceOrientation, duration:duration)
    timeFrame = time_label.frame
    viewHeight = view.frame.size.height
    viewWidth = view.frame.size.width
    fontSize = 30.0
    hideButton = true

    if isLandscape?(interfaceOrientation)
      fontSize = 40.0
      timeFrame.origin.y = (viewWidth/2) - timeFrame.size.height
      timeFrame.size.width = viewHeight
    else
      hideButton = false
      timeFrame.origin.y = (viewHeight/2) - timeFrame.size.height
      timeFrame.size.width = viewWidth
    end

    mode_button.setHidden(hideButton)
    time_label.setFont(UIFont.boldSystemFontOfSize(fontSize))
    time_label.setFrame(timeFrame)
  end

  def supportedInterfaceOrientations
    UIInterfaceOrientationMaskPortrait |UIInterfaceOrientationMaskLandscape
  end

  def isLandscape?(orientation)
    orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft
  end
end