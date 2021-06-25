//
//  HeroesCell.swift
//  MarvelsApp2
//
//  Created by admin on 25/6/21.
//

import UIKit

class HeroesCell: UITableViewCell {

    @IBOutlet weak var heroeImage: UIImageView!
    @IBOutlet weak var heroeName: UILabel!
    @IBOutlet weak var heroeDescription: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setHeroes(data: CharacterResult){
        heroeImage.image = UIImage(named: "logo")
        heroeName.text = data.name
        
        if data.description != nil {
            heroeDescription.text = data.description
        } else {
            heroeDescription.text = "No hay descripción"
        }
    
        
    }
}

