//
//  MB_Tags_View.swift
//  FigaroEmploi
//
//  Created by VASILIJEVIC Sebastien on 11/12/2019.
//  Copyright © 2019 FIGARO CLASSIFIEDS. All rights reserved.
//

import UIKit
import SnapKit

open class MB_Tags_View: UIView {
    
	public var isCentered:Bool = false {
		
		didSet {
			
			collectionViewLayout.isCentered = isCentered
			collectionView.reloadData()
		}
	}
	public var tagCornerRadius: CGFloat? = UI.Margins
	public var tagFont: UIFont? = UIFont(name: Fonts.Content.Bold.fontName, size: Fonts.Content.Bold.pointSize-3)
	public var tagTextColor: UIColor? = Colors.Text
	public var tagSelectedTextColor: UIColor? = Colors.Text
	public var tagImage: UIImage?
	public var tagImageColor: UIColor? = Colors.Text
	public var tagSelectedImage: UIImage?
	public var tagSelectedImageColor: UIColor? = Colors.Secondary
	public var tagBackgroundColor: UIColor? = Colors.Gray.withAlphaComponent(0.5)
	public var tagSelectedBackgroundColor: UIColor? = Colors.Gray.withAlphaComponent(0.5)
	public var tagBorderColor: UIColor? = .clear
	public var tagSelectedBorderColor: UIColor? = .clear
	public var tagCustomView:UIView?
	public var tagEdgeInsets:UIEdgeInsets? = .init(top: UI.Margins/3, left: UI.Margins/2, bottom: UI.Margins/3, right: UI.Margins/2)
	public var tags:[[MB_Tag]] = .init()
	public var isEmpty:Bool {
		
		var state:Bool = true
		tags.forEach({ if !$0.isEmpty { state = false } })
		return state
	}
	public var hasChecked:Bool {
		
		var state:Bool = false
		tags.forEach({ $0.forEach({ if $0.isChecked ?? false { state = true } }) })
		return state
	}
	private var sections:[String?] = .init()
	private lazy var collectionViewLayout:MB_TagCollectionViewFlowLayout = {
		
		let collectionViewLayout:MB_TagCollectionViewFlowLayout = .init()
		collectionViewLayout.isCentered = isCentered
		return collectionViewLayout
	}()
	private lazy var collectionView:UICollectionView = {
		
		let collectionView:UICollectionView = .init(frame: .zero, collectionViewLayout: collectionViewLayout)
		collectionView.setContentHuggingPriority(.defaultHigh, for: .vertical)
		collectionView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
		collectionView.backgroundColor = .clear
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(MB_TagCollectionViewCell.self, forCellWithReuseIdentifier: MB_TagCollectionViewCell.identifier)
		collectionView.register(MB_Tags_CollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MB_Tags_CollectionReusableView.identifier)
		return collectionView
	}()
	private var collectionViewContentSizeObserver:NSKeyValueObservation?
	
	deinit {
		
		collectionViewContentSizeObserver?.invalidate()
		collectionViewContentSizeObserver = nil
	}
    
    convenience public init() {
		
        self.init(frame: .zero)
		
		backgroundColor = .clear
        addSubview(collectionView)
		
		collectionView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
			make.height.equalTo(0)
		}
		
		collectionViewContentSizeObserver = collectionView.observe(\.contentSize) { view, _ in
			
			view.snp.updateConstraints({ make in
				
				make.height.equalTo(view.contentSize.height)
			})
		}
		
		setUp()
    }
    
    override public init(frame: CGRect) {
		
        super.init(frame: frame)
    }
	
	required public init?(coder: NSCoder) {
		
		fatalError("init(coder:) has not been implemented")
	}
	
	open func setUp() {
		
	}
	
	public func setSection(title:String?, atIndex index:Int = 0) {

		while index > sections.count - 1 {
			
			sections.append(nil)
		}
		
		sections[index] = title
		
		collectionViewLayout.sectionInset = UIEdgeInsets(top: sections.isEmpty ? 0 : UI.Margins, left: 0, bottom: sections.isEmpty ? 0 : UI.Margins, right: 0)
	}
	
	public func add(_ tag:MB_Tag, inSection section:Int = 0) {
		
		while section > tags.count - 1 {
			
			tags.append(.init())
		}
		
		tag.cornerRadius = tag.cornerRadius ?? tagCornerRadius
		tag.font = tag.font ?? tagFont
		tag.textColor = tag.textColor ?? tagTextColor
		tag.selectedTextColor = tag.selectedTextColor ?? tagSelectedTextColor
		tag.image = tag.image ?? tagImage
		tag.imageColor = tag.imageColor ?? tagImageColor
		tag.selectedImage = tag.selectedImage ?? tagSelectedImage
		tag.selectedImageColor = tag.selectedImageColor ?? tagSelectedImageColor
		tag.backgroundColor = tag.backgroundColor ?? tagBackgroundColor
		tag.selectedBackgroundColor = tag.selectedBackgroundColor ?? tagSelectedBackgroundColor
		tag.borderColor = tag.borderColor ?? tagBorderColor
		tag.selectedBorderColor = tag.selectedBorderColor ?? tagSelectedBorderColor
		tag.customView = tag.customView ?? tagCustomView
		tag.edgeInsets = tag.edgeInsets ?? tagEdgeInsets
        tags[section].append(tag)
		
		collectionView.reloadData()
    }
	
	public func add(_ text:String, inSection section:Int = 0) {
		
		let tag:MB_Tag = .init()
		tag.text = text
		add(tag, inSection: section)
	}
	
	public func delete(_ tag:MB_Tag) {
		
		var section = tags
		for i in 0..<section.count {
			
			section[i].removeAll(where: { $0.text == tag.text })
		}
		section.removeAll(where: { $0.isEmpty })
		tags = section
		
		reload()
	}
	
	public func reset() {
		
		tags.removeAll()
		collectionView.reloadData()
    }
	
	public func reload() {
		
		collectionView.reloadData()
	}
	
	public func scroll(to indexPath:IndexPath) {
		
		collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
	}
}

extension MB_Tags_View: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	public func numberOfSections(in collectionView: UICollectionView) -> Int {
		
		return tags.count
	}
	
	public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

		let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MB_Tags_CollectionReusableView.identifier, for: indexPath) as! MB_Tags_CollectionReusableView
		reusableView.title = nil
		
		if indexPath.section < sections.count {
			
			reusableView.title = sections[indexPath.section]
		}
		
		return reusableView
	}

	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

		if !tags[section].isEmpty {
			
			let headerView = MB_Tags_CollectionReusableView()
			headerView.title = nil

			if section < sections.count {

				headerView.title = sections[section]
			}

			headerView.snp.makeConstraints { (make) in
				make.width.equalTo(collectionView.frame.width)
			}
			let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
			return size
		}
		
		return .zero
	}
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
        return tags[section].count
    }
    
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:MB_TagCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: MB_TagCollectionViewCell.identifier, for: indexPath) as! MB_TagCollectionViewCell
		cell.maxWidth = collectionView.frame.size.width
		cell._tag = tags[indexPath.section][indexPath.item]
		cell.isChecked = tags[indexPath.section][indexPath.item].isChecked ?? false
		return cell
    }
	
	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		collectionView.deselectItem(at: indexPath, animated: true)
		
		if let cell = collectionView.cellForItem(at: indexPath) as? MB_TagCollectionViewCell {
			
			cell.isChecked = !cell.isChecked
			tags[indexPath.section][indexPath.item].isChecked = cell.isChecked
			tags[indexPath.section][indexPath.item].actionHandler?(tags[indexPath.section][indexPath.item])
		}
	}
}
