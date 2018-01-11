//
//  ViewController.swift
//  BookmarkDataTestSwift
//
//  Created by Swafford, Jonathan Anderson on 1/9/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func didPressCreate(_ sender: Any) {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let url = URL(fileURLWithPath: documentsPath)
        
        print("Bookmarking: \(String(describing: url))")
        
        do {
            _ = try url.bookmarkData(options: .suitableForBookmarkFile, includingResourceValuesForKeys: nil, relativeTo: nil)
        } catch {
            print("Error converting URL to bookmark: \(String(describing: error))")
        }
        
        let alert = UIAlertController(title: "Bookmark successful", message: "Try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
        
        
    }
}
