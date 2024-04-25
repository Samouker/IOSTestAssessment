//
//  PostsListTVC.swift
//  IOSTestAssessment
//
//  Created by Rajan on 25/04/24.
//

import UIKit

// MARK: - UserListCell

class PostListCell: UITableViewCell {
    // Outlets for UI elements
    @IBOutlet weak var ivThumb: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!

    // Configuring cell with User data
    func configureWith(post: Post) {
            
        self.lblDesc.text = post.body?.capitalizeFirstLetter()
        self.lblTitle.text = "\(post.id ?? 0)) \(post.title?.capitalizeFirstLetter() ?? "")"
    
    }
}

class PostListTVC: UITableViewController {

    // ViewModel instance
    let postViewModel = PostViewModel()
    
    // Pagination variables
    var currentPage = 1
    let perPage = 30

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set title
        self.title = "Posts"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Fetch initial Posts
        fetchPosts()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Network monitoring
        NetworkMonitor.shared.addObserver(forController: PostListTVC.self) { status in
            self.showMessage(message: status ? Messages.connactionBack : Messages.noConnection, isError: !status)
            
            // Reload Posts
            if status {self.fetchPosts()}
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop network monitoring
        NetworkMonitor.shared.removeObserver(forController: PostListTVC.self)
    }


    // Fetch Posts from ViewModel
    func fetchPosts() {
        // Check network connectivity
        if NetworkMonitor.shared.isConnected {
            // Fetch Posts from ViewModel
            postViewModel.fetchPosts(page: currentPage, perPage: perPage) { [weak self] errorMessage in
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
    
    // Load more Posts if needed
    func loadMorePostsIfNeeded(for indexPath: IndexPath) {
        if indexPath.item == postViewModel.posts.count - 1 {
            // Reached the end of current data, load more
            currentPage += 1
            fetchPosts()
        }
    }
    
    // Refresh button action
    @IBAction func btnRefreshTapped(_ sender: UIBarButtonItem) {
        // Check network connectivity
        if NetworkMonitor.shared.isConnected {
            // Fetch Posts
            fetchPosts()
        } else {
            // Show no internet connection message
            self.showMessage(message: Messages.noConnection, isError: true)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.postViewModel.posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostListCell", for: indexPath) as! PostListCell

        // Configure the cell...
        cell.configureWith(post: self.postViewModel.posts[indexPath.row])
        
        // Load more Posts if needed
        loadMorePostsIfNeeded(for: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if let commentListTVC = self.storyboard?.instantiateViewController(identifier: "CommentListTVC") as? CommentListTVC {
            commentListTVC.post = self.postViewModel.posts[indexPath.row]
            self.navigationController?.pushViewController(commentListTVC, animated: true)
        }
        
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
