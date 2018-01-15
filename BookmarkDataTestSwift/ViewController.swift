//
//  ViewController.swift
//  BookmarkDataTestSwift
//
//  Created by Swafford, Jonathan Anderson on 1/9/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func try1(_ sender: Any) {
        
        var data: Data?
        let url = documentsUrl()
        
        do {
            data = try url.bookmarkData(options: .suitableForBookmarkFile, includingResourceValuesForKeys: nil, relativeTo: nil)
        } catch {
            handleCaughtError(error: error)
        }
        
        processData(data: data)
    }
    
    
    @IBAction func try2(_ sender: Any) {

        var data: Data?
        let url = documentsUrl()
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global(qos: .background).async {
            do {
                data = try url.bookmarkData(options: .suitableForBookmarkFile, includingResourceValuesForKeys: nil, relativeTo: nil)
                group.leave()
            } catch {
                self.handleCaughtError(error: error)
            }
        }
        
        group.wait()
        
        processData(data: data)
        
    }
    
    @IBAction func try3(_ sender: Any) {
        
        var data: Data?
        let url = documentsUrl()
        
        let semaphore = DispatchSemaphore(value: 1)
        
        DispatchQueue.global(qos: .userInitiated).async {
            semaphore.wait()
            do {
                data = try url.bookmarkData(options: .suitableForBookmarkFile, includingResourceValuesForKeys: nil, relativeTo: nil)
            } catch {
                self.handleCaughtError(error: error)
            }
            semaphore.signal()
        }
        
        processData(data: data)
        
    }
    
    @IBAction func try4(_ sender: Any) {
        
        var data: Data?
        let url = documentsUrl()
        
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global(qos: .background).async {
            do {
                data = try url.bookmarkData(options: .suitableForBookmarkFile, includingResourceValuesForKeys: nil, relativeTo: nil)
                group.leave()
            } catch {
                self.handleCaughtError(error: error)
            }
        }
        
        group.notify(queue: .main) {
            self.processData(data: data)
        }
        
    }
    
    // MARK: Utility
    
    func documentsUrl() -> URL {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return URL(fileURLWithPath: documentsPath)
    }
    
    func processData(data: Data?) -> Void {
        
        if let d = data {
            if readBookmark(data: d) {
                showSuccess()
            } else {
                showFailure("Could not read bookmark")
            }
        } else {
            showFailure("Data does not exist")
        }
        
    }
    
    func readBookmark(data: Data) -> Bool {
        var isStale: Bool = false
        if let url = try? URL(resolvingBookmarkData: data, options: [], relativeTo: nil, bookmarkDataIsStale: &isStale) {
            print("Bookmark is: \(String(describing: url))")
            return true
        } else {
            print("Could not read bookmark")
            return false
        }
    }
    
    func showSuccess() -> Void {
        let alert = UIAlertController(title: "Bookmark did not deadlock", message: "Try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showFailure(_ message: String) -> Void {
        let alert = UIAlertController(title: "Bookmark failed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func handleCaughtError(error: Error) {
        print("Error converting URL to bookmark: \(String(describing: error))")
    }
    
    
    
    
}
