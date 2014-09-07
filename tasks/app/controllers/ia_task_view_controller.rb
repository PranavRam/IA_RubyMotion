class IATaskViewController < UIViewController
  extend IB
  attr_accessor :delegate
  attr_accessor :task

  outlet :task_label

  def complete_task(sender)
    tasksListView = delegate
    tasksListView.tasks.removeObject(task)
    navigationController.popViewControllerAnimated(true)
  end

  def viewDidLoad
    super
    task_label.text = task
  end
end