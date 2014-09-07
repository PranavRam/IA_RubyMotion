class IAViewController < UIViewController
  extend IB
  attr_accessor :tasks

  outlet :table_view

  def viewDidLoad
    super
    @tasks = Array.new
  end

  def tableView(tableView, numberOfRowsInSection: section)
    tasks.count
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @cell_identifier = "Cell"
    cell = tableView.dequeueReusableCellWithIdentifier(@cell_identifier)

    if cell.nil?
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: @cell_identifier)
    end

    cell.textLabel.text = tasks[indexPath.row]
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    performSegueWithIdentifier("taskSegue", sender: tasks[indexPath.row])
  end

  def prepareForSegue(segue, sender: sender)
    destination = segue.destinationViewController
    if segue.identifier == "taskSegue"
      destination.task = sender
    else
      destination = segue.destinationViewController.topViewController
    end

    destination.delegate = self
  end

  def viewWillAppear(animated)
    super
    table_view.reloadData
  end
end