class IAAccountsViewController < UIViewController
  extend IB
  attr_accessor :accounts

  outlet :tableView

  def viewDidLoad
    super
    @accounts = []
    retrieveAccounts(ACAccountTypeIdentifierTwitter, options: nil)
    fbOptions = {
      ACFacebookAppIdKey: "564437910322864",
      ACFacebookPermissionsKey: ["email", "user_about_me"]
    }
    # retrieveAccounts(ACAccountTypeIdentifierFacebook, options: fbOptions)
  end

  def retrieveAccounts(id, options: options)
    accountStore = ACAccountStore.new
    accountType = accountStore.accountTypeWithAccountTypeIdentifier(id)
    accountStore.requestAccessToAccountsWithType(accountType, options:options, 
      completion:lambda do |granted, error|
        if granted
          @accounts.push(*accountStore.accountsWithAccountType(accountType))
          Dispatch::Queue.main.async { tableView.reloadData }
        end
    end)
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @accounts.count
  end

  def tableView(tableVIew, cellForRowAtIndexPath: indexPath)
    @@cell_identifier = "accountCell"
    cell = tableView.dequeueReusableCellWithIdentifier(@@cell_identifier)
    account = @accounts[indexPath.row]
    if account.accountType.identifier == ACAccountTypeIdentifierTwitter
      cell.textLabel.text = account.accountDescription
    else
      cell.textLabel.text = account.username
    end
    cell
  end

  def prepareForSegue(segue, sender: sender)
    selectedIndex = tableView.indexPathForSelectedRow
    account = @accounts[selectedIndex.row]
    view = segue.destinationViewController
    view.title = tableView.cellForRowAtIndexPath(selectedIndex).textLabel.text
    view.account = account
  end
end