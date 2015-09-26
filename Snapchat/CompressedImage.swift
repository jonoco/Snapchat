//
//  CompressedImage.swift
//  Snapchat
//
//  Created by Joshua Cox on 5/27/15.
//  Copyright (c) 2015 Joshua Cox. All rights reserved.
//

import UIKit

class CompressedImage: UIImageView {
	var compressedImageData: NSData?
	func CompressedJpeg(image: UIImage?, compressionTimes: Int){
		if var imageCompressed = image {
			for (var i = 0 ; i<compressionTimes; i++) {
				compressedImageData = UIImageJPEGRepresentation(imageCompressed, 0.0)
				imageCompressed = UIImage(data: compressedImageData!)!
			}
			self.image = imageCompressed
		}else{
			compressedImageData = nil
			self.image = nil
		}
	}
}
