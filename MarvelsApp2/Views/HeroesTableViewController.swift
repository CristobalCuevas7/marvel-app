

import UIKit

class HeroesTableViewController: UITableViewController {

    var misCell: MCell = MCell(xibName: "HeroesCell", idReuse: "HeroesCell")
    var heroes: [CharacterResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView!.register(UINib(nibName: misCell.xibName, bundle: nil), forCellReuseIdentifier: misCell.idReuse)
       
        NetworkClient().getCharacters { result in
              switch result {
              case .success(let characters):
                  
                  guard let securedResult = characters.data?.results else {
                      return
                  }
                self.heroes = securedResult
                self.tableView!.reloadData()
              case .failure(let error):
                  print(error.errorDescripcion ?? "")
              }
          }
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return heroes.count
       }
       
      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: misCell.idReuse, for: indexPath) as! HeroesCell
        
           cell.setHeroes(data: heroes[indexPath.row])
           return cell
       }
   }

struct MCell {
    var xibName: String
    var idReuse: String
}
