//
//  MovieCell.swift
//  SampleMovieListApp
//
//  Created by Stella Lei on 12/10/21.
//  Copyright © 2021 mac. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(image: UIImage, text: String, overview:String){
        imageV.image = image
        titleLab.text = text
        overviewLabel.text = overview
    }
}
