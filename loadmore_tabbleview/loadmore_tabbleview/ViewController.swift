import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var loadMoreIdicator: UIActivityIndicatorView!

    var list = [Int](0...20)
    var list1 = [Int](0...20)
    var pageNumber = 0
    var pagetotal = 5
    var pageSize = 10
    let refreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        self.tableview.addSubview(refreshControl)
        // Do any additional setup after loading the view.
    }
    @objc func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.list.removeAll()
            self.pageNumber = 0
            self.list = self.list1
            self.tableview.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell {
            cell.titleLabel.text = String(list[indexPath.row])
            return cell
        }
        return UITableViewCell()

        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(indexPath.row)

        if indexPath.row == list.count - 1 {
            if pageNumber < pagetotal  {
                loadMore()
            }
        }
    }
    func loadMore() {
        guard pageNumber < pagetotal else {
            return
        }
        let lastRequest = pageNumber == pagetotal - 1
        self.loadMoreIdicator.isHidden = false
        
        DispatchQueue.global().async {
            self.list += [Int](0..<self.pageSize)
            self.pageNumber += 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.tableview.reloadData()
                if lastRequest {
                    self.loadMoreIdicator.stopAnimating()
                    self.loadMoreIdicator.hidesWhenStopped = true
                } else {
                    self.loadMoreIdicator.startAnimating()
                }
            }
        }

        
    }
}

