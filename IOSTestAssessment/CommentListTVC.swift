//
//  CommentListTVC.swift
//  IOSTestAssessment
//
//  Created by Rajan on 26/04/24.
//

import UIKit

class CommentListCell: UITableViewCell {
    // Outlets for UI elements
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblBody: UILabel!

    // Configuring cell with User data
    func configureWith(comment: Comment) {
            
        self.lblName.text = comment.name?.capitalizeFirstLetter()
        self.lblEmail.text = comment.email?.lowercased()
        self.lblBody.text = comment.body
    }
}

class CommentListTVC: UITableViewController {
    
    // ViewModel instance
    let commentViewModel = CommentViewModel()
    
    var post:Post?
    
    // Pagination variables
    var currentPage = 1
    let perPage = 30

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set title
        self.title = "Comments"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Fetch initial Posts
        fetchComments()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Network monitoring
        NetworkMonitor.shared.addObserver(forController: CommentListTVC.self) { status in
            self.showMessage(message: status ? Messages.connactionBack : Messages.noConnection, isError: !status)
            
            // Reload Posts
            if status {self.fetchComments()}
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop network monitoring
        NetworkMonitor.shared.removeObserver(forController: CommentListTVC.self)
    }


    // Fetch Posts from ViewModel
    func fetchComments() {
        // Check network connectivity
        if NetworkMonitor.shared.isConnected {
            // Fetch Posts from ViewModel
            commentViewModel.fetchComments(postId: self.post?.id ?? 0) { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    // Show error message
                    self?.showMessage(message: errorMessage, isError: true)
                } else {
                    // Reload collectionView data on successful fetch
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }
        } else {
            // Show no internet connection message
            self.showMessage(message: Messages.noConnection, isError: true)
        }
    }
    
    // Refresh button action
    @IBAction func btnRefreshTapped(_ sender: UIBarButtonItem) {
        // Check network connectivity
        if NetworkMonitor.shared.isConnected {
            // Fetch Posts
            fetchComments()
        } else {
            // Show no internet connection message
            self.showMessage(message: Messages.noConnection, isError: true)
        }
    }
    
    @IBAction func btnBackTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.commentViewModel.comments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentListCell", for: indexPath) as! CommentListCell

        // Configure the cell...
        cell.configureWith(comment: self.commentViewModel.comments[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        // print(self.commentViewModel.comments[indexPath.row].email ?? "--")
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
