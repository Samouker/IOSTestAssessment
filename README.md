# Project Name: IOSTestAssessment

## Features
- Asynchronously loads content (Post & Comments) API URLs.
- Implements caching mechanism for efficient retrieval of images.
- Handles network errors and image loading failures gracefully.
- Implements SSL Pinning for enhanced security.
- Developed using Swift 5.0.
- Follows the MVVM (Model-View-ViewModel) architecture pattern.

### Requirements
- Xcode (Version 15.3)
- Swift (Version 5.0)
- Internet connection for API data retrieval

## Setup Instructions
- Clone or download the repository to your local machine.
- Open the project in Xcode.
- Build and run the project on a simulator or a physical iOS device.


## Implementation Details
### Models
The application includes two main models:
- `Post`: Contains details about Post done by respective user.
- `Comment`: Represents a comment retrieved from the API, containing an id, postId, name, email.

### ViewModel

- `PostViewModel`: Contains `PostViewModel` classes for fetching posts and comments respectively..
- `CommentViewModel`: Contains `CommentViewModel` classes for fetching posts and comments respectively..

### Controller and Views

Includes `PostListTVC` and `CommentListTVC` classes for displaying lists of posts and comments. Also, contains corresponding cell classes for configuring table view cells.

### Networking and Security

- **APIManager**: Handles API requests using URLSession and implements SSL pinning for enhanced security. It ensures that the server's certificate matches a locally stored certificate for verification.
- **SSL Pinning**: Provides an additional layer of security by validating the server's SSL certificate against a locally stored certificate. This prevents potential attacks, such as man-in-the-middle attacks, by ensuring that the app only communicates with trusted servers.

### Usage
Demonstrates usage of the provided functionalities for fetching and displaying data from the API.

## Note
- Ensure that the latest Xcode version is installed to avoid compilation issues.
- Effective error handling and informative messages are implemented throughout the application.
