//
//  MB_Tag.swift
//  FigaroEmploi
//
//  Created by BLIN Michael on 30/04/2021.
//

import UIKit

public class MB_Tag: NSObject {
	
	public var text: String?
	public var font: UIFont?
	public var textColor: UIColor?
	public var selectedTextColor: UIColor?
	public var image: UIImage?
	public var imageColor: UIColor?
	public var selectedImage: UIImage?
	public var selectedImageColor: UIColor?
	public var backgroundColor: UIColor?
	public var selectedBackgroundColor: UIColor?
	public var borderColor: UIColor?
	public var selectedBorderColor: UIColor?
	public var actionHandler:((MB_Tag?)->Void)?
	public var isChecked:Bool?
	public var customView:UIView?
	public var edgeInsets:UIEdgeInsets?
	public var customData:Any?
}
