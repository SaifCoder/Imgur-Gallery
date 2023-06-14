//
//  ImageService.swift
//  Imgur-Gallery
//
//  Created by Saifali Terdale on 15/06/23.
//

import Foundation

protocol ImageServiceDelegate:AnyObject {
    func getTopImagesOfWeek(data:[ImageData]?)
    func didFailToFetchResult()
}

class ImageService {
    weak private var delegate: ImageServiceDelegate?

    init(delegate: ImageServiceDelegate) {
        self.delegate = delegate
    }

    var imageData: [ImageData]? {
        didSet {
            guard let data = imageData, !data.isEmpty else {
                delegate?.didFailToFetchResult()
                return
            }
            delegate?.getTopImagesOfWeek(data: data)
        }
    }

    func getTopImagesOfWeek(text: String) {
        AppDelegate.instance.apimanager.getTopImagesOfWeek(text: text) { data in
            self.imageData = data
        }
    }
}
