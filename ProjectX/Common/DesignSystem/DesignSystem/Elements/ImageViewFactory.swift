//
//  ImageViewFactory.swift
//  TemperComponents-framework
//
//  Created by Sameh Mabrouk on 1/10/20.
//

import SkeletonView
import UIKit

/** Create UIImageView components with Temper styling
 
    - rounded image
   ````
   ImageViewFactory(with: UIImage(named: "sample_image")).rounded().build()
   ````
 
*/

public class ImageViewFactory<T>: Factory {
    public typealias ComponentType = T

    private let imageView: UIImageView
    
    public init(with image: UIImage? = nil, frame: CGRect? = nil) {
        if let aFrame = frame {
            imageView = UIImageView(frame: aFrame)
            imageView.image = image
            imageView.translatesAutoresizingMaskIntoConstraints = false
        } else {
            imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @discardableResult
    public func cornerRadius(of radius: CGFloat) -> Self {
        imageView.layer.cornerRadius = radius
        imageView.clipsToBounds = true
        return self
    }
    
    @discardableResult
    public func rounded() -> Self {
        return cornerRadius(of: imageView.frame.size.width / 2)
    }
    
    @discardableResult
    public func contentMode(contentMode: UIView.ContentMode) -> Self {
        imageView.contentMode = contentMode
        return self
    }
    
    @discardableResult
    public func clipsToBounds(_ shouldClip: Bool = true) -> Self {
        imageView.clipsToBounds = shouldClip
        return self
    }
    
    @discardableResult
    public func sizeToFit() -> Self {
        imageView.sizeToFit()
        return self
    }
    
    @discardableResult
    public func isSkeletonable(_ isSkeletonable: Bool) -> Self {
        imageView.isSkeletonable = isSkeletonable
        return self
    }
    
    @discardableResult
    public func imageColor(color: UIColor) -> Self {
        imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = color
        return self
    }
    
    public func translatesAutoresizingMaskIntoConstraints(_ translatesAutoresizingMaskIntoConstraints: Bool) -> Self {
        imageView.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
        return self
    }
    
    public lazy var playbookPresentationSize = {
        return CGRect(x: 0, y: 0, width: 100, height: 100)
    }()
    
    public func build() -> T {
        return imageView as! T
    }
    
}
