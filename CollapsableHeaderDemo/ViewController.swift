import UIKit

class ViewController: UIViewController {
    
    let data: [Int] = {
        return Array(0...50)
    }()
    
    lazy var statusBarHeight: CGFloat = {
        return view.safeAreaInsets.top
    }()
    
    var allowHeaderHeightUpdates: Bool = false
    
    private lazy var headerTopAnchor: NSLayoutConstraint = {
        header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
    }()
    
    private var header: TableViewHeader = {
        let header = TableViewHeader()
        // swipe on header will scroll table
        header.isUserInteractionEnabled = false
        return header
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        // to get scroll view events ...
        tableView.delegate = self
        // header initially expanded
        tableView.contentInset = UIEdgeInsets(top: TableViewHeader.maxHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset.y = -TableViewHeader.maxHeight
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
    }
    
    private func setupSubviews() {
        [tableView, header].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        header.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerTopAnchor.isActive = true
        header.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(data[indexPath.row])"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = -scrollView.contentOffset.y
        let minOffset = max(TableViewHeader.minHeight, offsetY)
        
        if minOffset < TableViewHeader.maxHeight {
            // header collapsed
            let newConstant = minOffset - TableViewHeader.maxHeight
            headerTopAnchor.constant = newConstant
        } else {
            // header fully expanded
            headerTopAnchor.constant = 0
        }
    }
}

// assuming self sizing height
class TableViewHeader: UIView {
    
    static var maxHeight: CGFloat = 250
    static var minHeight: CGFloat = 60
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .cyan
        translatesAutoresizingMaskIntoConstraints = false
        
        heightAnchor.constraint(equalToConstant: TableViewHeader.maxHeight).isActive = true
        
        layer.borderColor = UIColor.blue.cgColor
        layer.borderWidth = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
