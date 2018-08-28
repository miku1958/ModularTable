//
//  DescriptionCell.swift
//  ModularTable
//
//  Created by mikun on 2018/8/15.
//  Copyright © 2018 mdk. All rights reserved.
//

import UIKit

class DescriptionCell: UITableViewCell{

	@IBOutlet weak var descriptionLabel: UILabel!
}
struct DescriptionCellConfigurator {
	static func config(cell:DescriptionCell ,TableNode node:TableNode ) -> () {
		cell.descriptionLabel.text = node.desc
	}
}
