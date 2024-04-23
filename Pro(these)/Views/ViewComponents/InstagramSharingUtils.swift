//
//  InstagramSharingUtils.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 16.08.23.
//
import Foundation
import SwiftUI

struct InstagramShareView: View {

    var imageToShare: UIImage

    var type: InstagramShareView.type?
    
    init(imageToShare: UIImage, type: InstagramShareView.type? = nil) {
        self.imageToShare = imageToShare
        self.type = type ?? nil
    }
    
    var body: some View {
        VStack {
            if InstagramSharingUtils.canOpenInstagramStories {
                Button(action: {
                    
                    if let t = self.type {
                        if t == .storie {
                            InstagramSharingUtils.shareToInstagramStories(imageToShare)
                        }
                        
                        /*
                        if t == .feed {
                            InstagramSharingUtils.shareToInstagramFeed(image: imageToShare)
                        }
                         */
                    }
                    
                   
                    
                    
                }) {
                    Image("instagram")
                        .scaleEffect(1.2)
                    
                    Text("Instagram")
                }
            }
        }
    }
    
    enum type {
        case storie
        case feed
    }
}


struct InstagramSharingUtils {

  // Returns a URL if Instagram Stories can be opened, otherwise returns nil.
  private static var instagramStoriesUrl: URL? {
      if let url = URL(string: "instagram-stories://share?source_application=" + Bundle.main.bundleIdentifier!) {
      if UIApplication.shared.canOpenURL(url) {
        return url
      }
    }
    return nil
  }
    
  private static var instagramFeedUrl: URL? {
        if let url = URL(string: "instagram-stories://share?source_application=" + Bundle.main.bundleIdentifier!) {
        if UIApplication.shared.canOpenURL(url) {
          return url
        }
      }
      return nil
    }
    
    /*
  static  func shareToInstagramFeed(image: UIImage) {
        // build the custom URL scheme
        guard let instagramUrl = URL(string: "instagram://app") else {
            return
        }

        // check that Instagram can be opened
        if UIApplication.shared.canOpenURL(instagramUrl) {
            // build the image data from the UIImage
            guard let imageData = image.jpegData(compressionQuality: 100) else {
                return
            }

            // build the file URL
            let path = (NSTemporaryDirectory() as NSString).appendingPathComponent("instagram.ig")
            let fileUrl = URL(fileURLWithPath: path)

            // write the image data to the file URL
            do {
                try imageData.write(to: fileUrl, options: .atomic)
            } catch {
                // could not write image data
                return
            }

            // instantiate a new document interaction controller
            // you need to instantiate one document interaction controller per file
            let documentController = UIDocumentInteractionController(url: fileUrl)
            documentController.delegate = self
            // the UTI is given by Instagram
            documentController.uti = "com.instagram.photo"

            // open the document interaction view to share to Instagram feed
            documentController.presentOpenInMenu(from: self.view.frame, in: self.view, animated: true)
        } else {
            // Instagram app is not installed or can't be opened, pop up an alert
        }
    }
     */
  // Convenience wrapper to return a boolean for `instagramStoriesUrl`
  static var canOpenInstagramStories: Bool {
    return instagramStoriesUrl != nil
  }

  // If Instagram Stories is available, writes the image to the pasteboard and
  // then opens Instagram.
  static func shareToInstagramStories(_ image: UIImage) {

    // Check that Instagram Stories is available.
    guard let instagramStoriesUrl = instagramStoriesUrl else {
      return
    }

    // Convert the image to data that can be written to the pasteboard.
    let imageDataOrNil = UIImage.pngData(image)
    guard let imageData = imageDataOrNil() else {
      print("🙈 Image data not available.")
      return
    }
    let pasteboardItem = ["com.instagram.sharedSticker.backgroundImage": imageData]
    let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60 * 5)]

    // Add the image to the pasteboard. Instagram will read the image from the pasteboard when it's opened.
    UIPasteboard.general.setItems([pasteboardItem], options: pasteboardOptions)

    // Open Instagram.
    UIApplication.shared.open(instagramStoriesUrl, options: [:], completionHandler: nil)
  }
}
