class IAAnalogClockView < UIView
  extend IB

  outlet :hoursHand
  outlet :minutesHand
  outlet :secondsHand
  outlet :pendulum

  def didMoveToWindow
    NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector: :moveHandsToLocalTime, userInfo:nil, repeats:true)  
  end

  def moveHandsToLocalTime
    comp = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit
    components = NSCalendar.currentCalendar.components(comp, fromDate:NSDate.date)

    moveHand(hoursHand, toAngle:(components.hour % 12)*360.0/12.0)
    moveHand(minutesHand, toAngle:(components.minute)*360.0/60.0)
    moveHand(secondsHand, toAngle:(components.second)*360.0/60.0)
  end

  def moveHand(hand, toAngle: angle)
    hand.layer.setAnchorPoint(CGPointMake(0.4, 0.75))
    hand.layer.setPosition(CGPointMake(160.0, 175.0))
    UIView.animateWithDuration(0.5, animations:lambda do
      matrix = CGAffineTransformMakeRotation(angle * Math::PI/180)
      hand.layer.setAffineTransform(matrix)
    end)
  end
end