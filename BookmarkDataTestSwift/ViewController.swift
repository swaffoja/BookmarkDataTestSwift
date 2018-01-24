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
        tryBookmarking(url: documentsUrl())
    }
    
    @IBAction func try2(_ sender: Any) {
        tryBookmarking(url: documentsSubdirectoryUrl())
    }
    
    func tryBookmarking(url: URL) {
        var data: Data?
        
        do {
            print("Bookmarking \(url.path)")
            data = try url.bookmarkData(options: .suitableForBookmarkFile, includingResourceValuesForKeys: nil, relativeTo: nil)
        } catch {
            handleCaughtError(error: error)
        }
        
        processData(data: data)
    }
    
    
    
    // MARK: Utility
    
    func documentsUrl() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func documentsSubdirectoryUrl() -> URL {
        let dirURL = documentsUrl().appendingPathComponent("mysubdirectory", isDirectory: true)
        
        if ensureDirectoryExists(url: dirURL) {
            return dirURL
        } else {
            print("Could not create directory \(dirURL.path).")
            return documentsUrl()
        }

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
            print("Bookmark is: \(url!.description))")
            return true
        } else {
            print("Could not read bookmark")
            return false
        }
    }
    
    func showSuccess() -> Void {
        let alert = UIAlertController(title: "Bookmark did not deadlock", message: "Read debugging console", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showFailure(_ message: String) -> Void {
        let alert = UIAlertController(title: "Bookmark failed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func handleCaughtError(error: Error) {
        print("Error converting URL to bookmark: \(error.localizedDescription)")
    }
    
    func ensureDirectoryExists(url: URL) -> Bool {
        var isDirectory = ObjCBool(false)
        let directoryExists = FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
        
        if (!directoryExists) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        } else if (!isDirectory.boolValue) {
            print("I don't want to bookmark a file. Only a directory.")
            return false
        }
        
        return true
    }
    
}

