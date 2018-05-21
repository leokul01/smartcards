//
//  SetsTableViewCell.swift
//  SmartCards
//
//  Created by LEONID KULIKOV on 16/04/2018.
//  Copyright © 2018 LEONID KULIKOV. All rights reserved.
//

import UIKit

class SetsTableViewCell: UITableViewCell {
    @IBOutlet weak var setsNameLabel: UILabel!
    @IBOutlet weak var setsDescriptionLabel: UILabel!
    @IBOutlet weak var setsImageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateProgress(dtime: Double, currentKnowledge: Double) {
        self.progressView.setProgress(dataManager.progress(dtime: dtime, currentKnowledge: currentKnowledge), animated: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
