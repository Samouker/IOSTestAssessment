//
//  PostViewModel.swift
//  IOSTestAssessment
//
//  Created by Rajan on 25/04/24.
//

import Foundation
import UIKit

class PostViewModel: NSObject {
    
    var posts: [Post] = []    // Array to store fetched photos
    
    // Function to fetch photos from the API
    // Parameters:
    //   - page: Page number of photos to fetch
    //   - perPage: Number of photos per page
    //   - completion: Closure to be called after fetching photos, returns an optional error message
    
    func fetchPosts(page: Int, perPage: Int, completion: @escaping (String?) -> Void) {
        
        // Note:
        /*
         I couldn't locate "Pagging" in the provided URL. However, I've gone ahead and implemented pagination in the code.  Just need to pass perPage count and current page in URL.
         */

        // Request photos from the API using shared instance of APIManager
        APIManager.shared.request(url: APPURL.apiURL(mode: .getPosts(perPage, page)), expecting: [Post].self) { data, error in
            
            // Check if there's an error returned from the API request
            if let error = error {
                completion(error.localizedDescription)   // Pass error message to completion handler
            }
            
            // Check if data is returned from the API request
            else if let data = data {
                self.posts += data    // Append fetched photos to the array
                
                completion(nil)    // Call completion handler with no error
            }
            else {
                completion("Unable to load more posts.")    // If neither data nor error is returned, indicate failure
            }
        }
    }
}
