
import UIKit

class MainViewController: UIViewController {
    
    var herosList = HeroesAPI.getHeroesData() 
    let contactsTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(contactsTableView)
        setupLayout()
    }
    
    func setupLayout() {
        contactsTableView.translatesAutoresizingMaskIntoConstraints = false
        contactsTableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        contactsTableView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
        contactsTableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        contactsTableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        contactsTableView.dataSource = self
        contactsTableView.delegate = self
        contactsTableView.register(MainTableViewCell.self, forCellReuseIdentifier: "heroCell")
        navigationItem.title = "Avengers"
    }
}
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return herosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "heroCell", for: indexPath) as?  MainTableViewCell {
            cell.contact = herosList[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
        selectedDetailVC.selectedhero = herosList[indexPath.row]
        selectedDetailVC.delegate = self
        self.navigationController?.pushViewController(selectedDetailVC, animated: true)
        }
    }
}


extension MainViewController: SelecteStartDelegate {
    func updateStarStatus(startStatus: Heroes?) {
        print(startStatus?.status ?? .Normal)
        if let indexOfItem = herosList.firstIndex(where: { $0.name == startStatus?.name }) {
            if let selectdHero = startStatus {
                herosList[indexOfItem] = selectdHero
                contactsTableView.reloadData()
            }
        }
    }
}
