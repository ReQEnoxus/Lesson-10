//
//  AspectPreservingImageView.swift
//  RequestsLesson
//
//  Created by Enoxus on 25/12/2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import UIKit

/// Subclass of image view that preserves an aspect ratio of the image
class AspectPreservingImageView: UIImageView {

    override var intrinsicContentSize: CGSize {

        if let myImage = self.image {
            
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width

            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio

            return CGSize(width: myViewWidth, height: scaledHeight)
        }

        return CGSize(width: -1.0, height: -1.0)
    }

}
