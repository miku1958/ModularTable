//
//  BlurCell.swift
//  ModularTable
//
//  Created by mikun on 2018/8/15.
//  Copyright © 2018 mdk. All rights reserved.
//

import UIKit

class BlurCell: UITableViewCell{

	@IBOutlet weak var titleLabel: UILabel!
	
	@IBOutlet weak var iconImageView: UIImageView!
	
	@IBOutlet weak var backgroundImageVIew: UIImageView!

}
struct BlurCellConfigurator {
	static func config(cell:BlurCell ,TableNode node:TableNode ) -> () {
		cell.titleLabel.text = node.title
		cell.iconImageView.image = node.icon
		cell.backgroundImageVIew.image = node.backgroundImage
	}
}
