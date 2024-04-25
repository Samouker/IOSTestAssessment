//
//  APIManager.swift
//  IOSTestAssessment
//
//  Created by Rajan on 25/04/24.
//

import Foundation
import CommonCrypto

// Struct for managing API URLs
struct APPURL {
    
    // Base URLs
    static let baseURL = "https://jsonplaceholder.typicode.com"

    // Function to generate API URL based on mode
    static func apiURL(mode: Mode) -> URL? {
        switch mode {
            
            // Note: I couldn't locate "Pagging" in the provided URL and Documantation. However, I've gone ahead and implemented pagination in the code.  Just need to pass perPage count and current page in URL.

        case .getPosts(let perPage, let page):
            return URL(string: "\(baseURL)/posts")
        case .getComments(let postId):
            return URL(string: "\(baseURL)/comments?postId=\(postId)")
        }
    }

    // Enum defining different API modes
    enum Mode {
        case getPosts(Int, Int)
        case getComments(Int)
    }
    
    // Function to encode URL string
    public static func encodeStrForURL(strUrl: String) -> URL {
        if let str = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: str) {
            return url
        }
        else if let url = URL(string: strUrl) {
            return url
        }
        // If encoding fails, return original URL
        return URL(string: strUrl)!
    }
}

// Class for managing API requests
class APIManager: NSObject {
    // Shared instance
    static let shared = APIManager()
    
    // URLSession instance
    var session: URLSession!
    
    private override init() {
        super.init()
        
        // Initialize URLSession
        session = URLSession.init(configuration: .ephemeral, delegate: self, delegateQueue: nil)
    }
    
    // Function to make API request
    func request<T: Decodable>(url: URL?, expecting: T.Type, completion: @escaping (_ data: T?, _ error: Error?) -> ()) {
        // Check if URL is valid
        guard let url else {
            print("cannot form url")
            return
        }
        
        let startTime = DispatchTime.now()

        // Create URLSession data task
        session.dataTask(with: url) { data, response, error in
            
            // Calculate time taken
            let endTime = DispatchTime.now()
            let nanoTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
            let timeInterval = Double(nanoTime) / 1_000_000_000 // Convert nanoseconds to seconds
            
            print("\n API call took:\(timeInterval) seconds for \(url)")

            // Handle URLSession completion
            
            // Handle URLSession error
            if let error = error {
                // Check if error is due to SSL pinning failure
                if error.localizedDescription == "cancelled" {
                    completion(nil, NSError(domain: "", code: -999, userInfo: [NSLocalizedDescriptionKey:"SSL Pinning Failed"]))
                    return
                }
                completion(nil, error)
                return
            }
            
            // Check if data is nil
            guard let data else {
                completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"something went wrong"]))
                print("something went wrong")
                return
            }
            
            // Check if response is HTTPURLResponse
            if let httpResponse = response as? HTTPURLResponse {
                // Check status code
                let statusCode = httpResponse.statusCode
                
                // Handle non-200 status codes
                if statusCode != 200 {
                    // Convert response data to string
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Response: \(responseString)")
                        completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:responseString]))
                    } else {
                        completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Something went wrong."]))
                    }
                    return
                }
            }
            
            // Decode response data
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(expecting, from: data)
                completion(response, nil)
            } catch {
                print(error)
                // Handle rate limit exceeded error
                completion(nil, error)
            }
        }.resume()
    }
}

// Extension for URLSessionDelegate methods
extension APIManager: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        // SSL pinning implementation
        
        // Create a server trust
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            return
        }
        
        var leafCertificate: SecCertificate?
        if #available(iOS 15.0, *) {
            if let certChain = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate], let firstCertificate = certChain.first {
                leafCertificate = firstCertificate
            }
        } else {
            leafCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0)
        }
        
        guard let certificate = leafCertificate else {
            return
        }

        // Certificate Pinning
        // SSL Policy for domain check
        let policy = NSMutableArray()
        policy.add(SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString))

        // Evaluate the certificate
        let isServerTrusted = SecTrustEvaluateWithError(serverTrust, nil)

        // Local and Remote Certificate Data
        let remoteCertificateData: NSData = SecCertificateCopyData(certificate)
        let pathToCertificate = Bundle.main.path(forResource: "typicode.com", ofType: "cer")
        let localCertificateData: NSData = NSData.init(contentsOfFile: pathToCertificate!)!

        // Compare Data of both certificates
        if (isServerTrusted && remoteCertificateData.isEqual(to: localCertificateData as Data)) {
            let credential: URLCredential = URLCredential(trust: serverTrust)
            print("Certification pinning is successful")
            completionHandler(.useCredential, credential)
        } else {
            // Failure happened
            print("Certification pinning is failed")
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }

}

