class IANewTaskViewController < UIViewController
  extend IB
  attr_accessor :delegate
  outlet :text_field

  def save_task(sender)
    if text_field.text.length == 0
      return
    end

    tasksListView = delegate
    tasksListView.tasks.addObject(text_field.text)
    close(sender)
  end

  def close(sender)
    dismissViewControllerAnimated(true, completion: nil)
  end
end