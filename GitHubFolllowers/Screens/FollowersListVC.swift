//
//  FollowersListVC.swift
//  GitHubFolllowers
//
//  Created by Андрей Фокин on 21.06.22.
//

import UIKit

class FollowersListVC: GFDataLoadingVC {
    
    enum Section {
        case main
    }
    // MARK: - Varibles
    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var pageFollowers = 1
    var hasMoreFollowers = true
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    var isSearching = false
    var loadingMoreFollowers = false
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        setupPlusButton()
        configureCollectionView()
        getFollowers(username: username, page: pageFollowers)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - configure View
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnsFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemGreen
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a user"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
    }
    
    private func setupPlusButton() {
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFollower))
        navigationItem.rightBarButtonItem = plusButton
    }
    
    @objc func addFollower() {
        showLoadingView()
        
        Task {
            
            do {
                let user = try await NetworkManager.shared.getUsers(for: username)
                addUser(user: user)
                dismissLoadingView()
            } catch {
                if let gFerror = error as? GFError {
                    presentGFAlert(title: "Bad stuff happend", message: gFerror.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
                dismissLoadingView()
            }
        }
        
    }
    
    func addUser(user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        
        PersistanceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.presentGFAlert(title: "Success", message: "You have successfully favorited this user", buttonTitle: "Hooray!")
                return
            }
            self.presentGFAlert(title: "Wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
    // MARK: - network request
    
    func getFollowers(username: String, page: Int) {
        
        showLoadingView()
        loadingMoreFollowers = true
        
        Task {
            do {
                let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
                updateUI(with: followers)
                dismissLoadingView()
            } catch {
                if let gFerror = error as? GFError {
                    presentGFAlert(title: "Bad stuff happend", message: gFerror.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
                dismissLoadingView()
            }
            
        }
        
        //        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
        //            guard let self = self else { return }
        //            self.dismissLoadingView()
        //
        //            switch result {
        //            case .success(let followers):
        //                self.updateUI(with: followers)
        //            case .failure(let error): self.presentGFAlertOnMainThread(title: "Bad stuff happend", message: error.rawValue, buttonTitle: "Ok")
        //            }
        //            self.loadingMoreFollowers = false
        //        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as? FollowerCell
            cell?.set(follower: follower)
            return cell
        })
    }
    
    func updateUI(with followers: [Follower]) {
        if followers.count < 100 {
            self.hasMoreFollowers = false
        }
        self.followers.append(contentsOf: followers)
        
        if self.followers.isEmpty {
            let message = "This user does not have any follodwers. Go follow them :)"
            DispatchQueue.main.sync {
                self.showEmptyStateView(message: message, in: self.view)
            }
        }
        self.updateData(on: self.followers)
    }
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

// MARK: - extensions -

extension FollowersListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHright  = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHright - height {
            guard hasMoreFollowers, !loadingMoreFollowers else {return}
            pageFollowers += 1
            getFollowers(username: username, page: pageFollowers)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        let dectVC = UserInfoVC()
        dectVC.username = follower.login
        dectVC.delegate = self
        let navigationController = UINavigationController(rootViewController: dectVC)
        present(navigationController, animated: true)
    }
}

extension FollowersListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
}

extension FollowersListVC: UserInfoVCDelegate {
    func didRequestFollowers(for username: String) {
        self.username = username
        title = username
        pageFollowers = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: pageFollowers)
    }
}
