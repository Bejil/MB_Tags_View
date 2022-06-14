//
//  MB_TagCollectionViewFlowLayout.swift
//  Explorimmo
//
//  Created by VASILIJEVIC Sebastien on 11/12/2019.
//  Copyright © 2019 FIGARO CLASSIFIEDS. All rights reserved.
//

import UIKit

fileprivate class MB_CollectionViewRow {
	
	var attributes = [UICollectionViewLayoutAttributes]()
	var spacing: CGFloat = 0
	var rowWidth: CGFloat {
		
		return attributes.reduce(0, { result, attribute -> CGFloat in
			
			return result + attribute.frame.width
		}) + CGFloat(attributes.count - 1) * spacing
	}
	
	init(spacing: CGFloat) {
		
		self.spacing = spacing
	}

	func add(attribute: UICollectionViewLayoutAttributes) {
		
		attributes.append(attribute)
	}

	func centerLayout(collectionViewWidth: CGFloat) {
		
		let padding = (collectionViewWidth - rowWidth) / 2
		var offset = padding
		
		for attribute in attributes {
			
			attribute.frame.origin.x = offset
			offset += attribute.frame.width + spacing
		}
	}
}

class MB_TagCollectionViewFlowLayout: UICollectionViewFlowLayout {
	
	public var isCentered:Bool = false
	
	override init() {
		
		super.init()
		
		sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		minimumLineSpacing = UI.Margins/2
        minimumInteritemSpacing = UI.Margins/2
        scrollDirection = .vertical
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
	}
	
	required init?(coder: NSCoder) {
		
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		
		if isCentered {
			
			guard let attributes = super.layoutAttributesForElements(in: rect) else {
				
				return nil
			}

			var rows = [MB_CollectionViewRow]()
			var currentRowY: CGFloat = -1

			for attribute in attributes {
				
				if currentRowY != attribute.frame.midY {
					
					currentRowY = attribute.frame.midY
					rows.append(MB_CollectionViewRow(spacing: 10))
				}
				
				rows.last?.add(attribute: attribute)
			}

			rows.forEach { $0.centerLayout(collectionViewWidth: collectionView?.frame.width ?? 0) }
			
			return rows.flatMap { $0.attributes }
		}
		else{
			
			var newAttributesArray = [UICollectionViewLayoutAttributes]()
			let superAttributesArray = super.layoutAttributesForElements(in: rect)!
			
			for (index, attributes) in superAttributesArray.enumerated() {
				
				if index == 0 || superAttributesArray[index - 1].frame.origin.y != attributes.frame.origin.y {
					
					attributes.frame.origin.x = sectionInset.left
				}
				else {
					
					let previousAttributes = superAttributesArray[index - 1]
					let previousFrameRight = previousAttributes.frame.origin.x + previousAttributes.frame.width
					attributes.frame.origin.x = previousFrameRight + minimumInteritemSpacing
				}
				
				newAttributesArray.append(attributes)
			}
			
			return newAttributesArray
		}
	}
}
