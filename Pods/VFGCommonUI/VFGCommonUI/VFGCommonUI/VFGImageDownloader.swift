//
//  VFGImageDownloader.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 30/01/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

/**
 Class responsible for downloading image for given URL.
 */
public class VFGImageDownloader: NSObject {

    /**
     URL from which image is downloaded.
     */
    public let imageURL : URL?

    /**
     Callback called when image was successfully downloaded or not.
     */
    public private(set) var downloadCompletedCallback : ((_ image : UIImage?) -> Void)?

    private static let downloadedImages : NSCache<NSString,UIImage> = NSCache<NSString,UIImage>()

    /**
     Create object responsible for downloading image from given url.

     - Parameter imageURL: URL of image to download
     - Parameter completion: callback called when image is downloaded

     */
    public init(imageURL: URL?, completion: ((_ image : UIImage?) -> Void)?) {
        self.imageURL = imageURL
        self.downloadCompletedCallback = completion
    }

    deinit {
        self.cancel()
    }

    /**
     Start downloading image from given url. Call completion block when downloaded successfully or not.
     */
    public func start() {
        DispatchQueue.global().async {
            var downloadedImage : UIImage? = self.downloadedImage(forURL: self.imageURL)
            if let imageURL = self.imageURL, downloadedImage == nil {
                    VFGLogger.log("Downloading image from " + imageURL.absoluteString)
                if let data : Data = try? Data(contentsOf: imageURL) {
                    downloadedImage = UIImage(data: data)
                    self.storeDownloadedImage(downloadedImage, forURL: imageURL)
                }
            }
            DispatchQueue.main.async {
                self.downloadCompletedCallback?(downloadedImage)
            }
        }
    }

    /**
     Cancel download, do not call completion block.
     */
    public func cancel() {
        self.downloadCompletedCallback = nil
    }

    private func storeDownloadedImage(_ image: UIImage?, forURL url: URL) {
        if let image : UIImage = image {
            VFGImageDownloader.downloadedImages.setObject(image, forKey: url.absoluteString as NSString)
        } else {
            VFGImageDownloader.downloadedImages.removeObject(forKey: url.absoluteString as NSString)
        }
    }

    private func downloadedImage(forURL url: URL?) -> UIImage? {
        var image : UIImage? = nil
        if let url : URL = url {
            image = VFGImageDownloader.downloadedImages.object(forKey: url.absoluteString as NSString)
        }
        return image
    }
    
}
