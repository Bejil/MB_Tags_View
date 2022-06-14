//
//  MB_Tags_CollectionReusableView.swift
//  FigaroEmploi
//
//  Created by BLIN Michael on 11/05/2021.
//

import UIKit

public class MB_Tags_CollectionReusableView: UICollectionReusableView {
  
	class var identifier: String {
		
		return "tagsCollectionReusableView"
	}
	public var title:String? {
		
		didSet {
			
			contentView.isHidden = title == nil || title?.isEmpty ?? true
			
			if let title = title, !title.isEmpty {
				
				label.text = title
			}
		}
	}
	private lazy var contentStackView:UIStackView = {
		
		let stackView:UIStackView = .init(arrangedSubviews: [contentView])
		stackView.axis = .vertical
		return stackView
	}()
	private lazy var contentView:UIView = {
		
		let view:UIView = .init()
		view.backgroundColor = Colors.Secondary.withAlphaComponent(0.1)
		view.addSubview(label)
		label.snp.makeConstraints { (make) in
			make.edges.equalToSuperview().inset(UI.Margins/2)
		}
		return view
	}()
	private lazy var label:UILabel = {
		
		let label:UILabel = .init()
		label.font = Fonts.Content.Bold
		label.textColor = Colors.Text
		label.numberOfLines = 0
		return label
	}()
	
	override init(frame: CGRect) {
		
		super.init(frame: frame)
		
		backgroundColor = .clear
		addSubview(contentStackView)
		contentStackView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
	}
	
	required init?(coder: NSCoder) {
		
		fatalError("init(coder:) has not been implemented")
	}
}
