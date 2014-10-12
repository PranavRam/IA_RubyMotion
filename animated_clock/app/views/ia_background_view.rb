class IABackgroundView < UIView

  def drawRect(rect)
    context = UIGraphicsGetCurrentContext()
    tile = UIImage.imageNamed("woodpattern")
    UIColor.colorWithPatternImage(tile).set
    CGContextFillRect(context, self.bounds)
  end
end