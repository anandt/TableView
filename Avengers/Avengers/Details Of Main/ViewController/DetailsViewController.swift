
import UIKit

protocol SelecteStartDelegate: class {
  func updateStarStatus(startStatus: Heroes?)
}

class DetailsViewController: UIViewController {
    
    var selectedhero: Heroes? = nil
    weak var delegate: SelecteStartDelegate?
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var starView: StarRatingView?
    var viewModel: DetailsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = selectedhero?.name
        setData()
        viewModel = DetailsViewModel()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(DetailsViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }

    func setData() {
        if let selected = selectedhero?.name {
         profileImage.image = UIImage(named: selected)
        }
    }
    
    @objc func back(sender: UIBarButtonItem) {
        if let viewM = viewModel {
            selectedhero?.status = viewM.fetchStatus(star: starView?.rating ?? 0.0)
        }
        delegate?.updateStarStatus(startStatus: selectedhero)
        // Go back to the previous ViewController
        _ = navigationController?.popViewController(animated: true)
    }
    
}
