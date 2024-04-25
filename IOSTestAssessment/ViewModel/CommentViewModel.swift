//
//  CommentViewModel.swift
//  IOSTestAssessment
//
//  Created by Rajan on 26/04/24.
//

import Foundation
import UIKit

class CommentViewModel: NSObject {
    
    var comments: [Comment] = []    // Array to store fetched Comments
    
    // Function to fetch comments from the API
    // Parameters:
    //   - postId: Respective PostId to fetch comments.
    
    func fetchComments(postId: Int, completion: @escaping (String?) -> Void) {
        
        // Request photos from the API using shared instance of APIManager
        APIManager.shared.request(url: APPURL.apiURL(mode: .getComments(postId)), expecting: [Comment].self) { data, error in
            
            // Check if there's an error returned from the API request
            if let error = error {
                completion(error.localizedDescription)   // Pass error message to completion handler
            }
            
            // Check if data is returned from the API request
            else if let data = data {
                self.comments += data    // Append fetched photos to the array
                completion(nil)    // Call completion handler with no error
            }
            else {
                completion("Unable to load more comments.")    // If neither data nor error is returned, indicate failure
            }
        }
    }
}
