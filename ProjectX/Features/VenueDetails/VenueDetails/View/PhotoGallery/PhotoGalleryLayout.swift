//
//  PhotoGalleryLayout.swift
//  VenueDetails
//
//  Created by Sameh Mabrouk on 11/02/2021.
//

import UIKit

private let kSideItemWidthCoef: CGFloat = 0.3
private let kSideItemHeightAspect: CGFloat = 1
private let kNumberOfSideItems = 3

class PhotoGalleryLayout: BaseCollectionViewLayout {
    
    private var _mainItemSize: CGSize!
    private var _sideItemSize: CGSize!
    private var _columnsXoffset: [CGFloat]!
    
    //MARK: Init
    
    override init() {
        super.init()
        
        self.totalColumns = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Override getters
    override var description: String {
        return "Layout v2"
    }
    
    //MARK: Override Abstract methods
    
    override func columnIndexForItemAt(indexPath: IndexPath) -> Int {
        let totalItemsInRow = kNumberOfSideItems + 1
        let columnIndex = indexPath.item % totalItemsInRow
        let columnIndexLimit = totalColumns - 1
        
        return columnIndex > columnIndexLimit  ? columnIndexLimit : columnIndex
    }
    
    override func calculateItemFrame(indexPath: IndexPath, columnIndex: Int, columnYoffset: CGFloat) -> CGRect {
        let size = columnIndex == 0 ? _mainItemSize : _sideItemSize
        return CGRect(origin: CGPoint(x: _columnsXoffset[columnIndex], y: columnYoffset), size: size!)
    }
    
    override func calculateItemsSize() {
        let floatNumberOfSideItems = CGFloat(kNumberOfSideItems)
        let contentWidthWithoutIndents = collectionView!.bounds.width - contentInsets.left - contentInsets.right
        let resolvedContentWidth = contentWidthWithoutIndents - interItemsSpacing
        
        // We need to calculate side item size first, in order to calculate main item height
        let sideItemWidth = resolvedContentWidth * kSideItemWidthCoef
        let sideItemHeight = sideItemWidth * kSideItemHeightAspect
        
        _sideItemSize = CGSize(width: sideItemWidth, height: sideItemHeight)
        
        // Now we can calculate main item height
        let mainItemWidth = resolvedContentWidth - sideItemWidth
        let mainItemHeight = sideItemHeight * floatNumberOfSideItems + ((floatNumberOfSideItems - 1) * interItemsSpacing)
        
        _mainItemSize = CGSize(width: mainItemWidth, height: mainItemHeight)
        
        // Calculating offsets by X for each column
        _columnsXoffset = [0, _mainItemSize.width + interItemsSpacing]
    }
}
