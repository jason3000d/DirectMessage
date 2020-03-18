//
//  DMUserListViewController.swift
//  DirectMessage
//
//  Created by Seraph on 2020/3/8.
//  Copyright © 2020 Paradise. All rights reserved.
//

import UIKit

class DMUserListViewController: UIViewController {

    /// The state describe the user list has result or not.
    private enum ResultState {
        case none
        case some
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    private var users: [DMUser] = []
    private var imageDataStore = DMImageDataStore()
    
    private var resultState: ResultState = .none {
        didSet {
            switch self.resultState {
            case .none:
                self.noResultsLabel.isHidden = false
                self.tableView.isHidden = true
            case .some:
                self.noResultsLabel.isHidden = true
                self.tableView.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Github DM"
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
    }

    func setupTableView() {
        let nib = UINib(nibName: DMUserListTableViewCell.Constants.cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: DMUserListTableViewCell.Constants.cellIdentifier)

    }

    func fetchData() {
        // TODO: could be improved by impl load more.
        DMBaseService.shared.getUserList { (users, err) in
            guard err == nil,
            let users = users else {
                self.resultState = .none
                return
            }
            self.users = users
            self.tableView.reloadData()
            self.resultState = .some
        }
    }
    
}

extension DMUserListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rawCell = tableView.dequeueReusableCell(withIdentifier: DMUserListTableViewCell.Constants.cellIdentifier, for: indexPath)
        guard let cell = rawCell as? DMUserListTableViewCell else {
            return rawCell
        }
        let user = self.users[indexPath.row]
        self.imageDataStore.getImage(with: user.avatarUrl, for: cell.avatarView)
        cell.userNameLabel.text = "@\(user.username)"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
}

extension DMUserListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = self.users[indexPath.row]
        let messageVC = DMMessageViewController(with: user)
        self.navigationController?.pushViewController(messageVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DMUserListTableViewCell.Constants.rowHeight
    }
    
}
