//
//  FollowersListVC.swift
//  GitHubFolllowers
//
//  Created by Андрей Фокин on 21.06.22.
//

import UIKit

class FollowersListVC: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
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
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a user"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
    }
    
    // MARK: - network request
    
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let followers):
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
            case .failure(let error): self.presentGFAlertOnMainThread(title: "Bad stuff happend", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as? FollowerCell
            cell?.set(follower: follower)
            return cell
        })
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
            guard hasMoreFollowers else {return}
            pageFollowers += 1
            getFollowers(username: username, page: pageFollowers)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        let dectVC = UserInfoVC()
        dectVC.username = follower.login
        let navigationController = UINavigationController(rootViewController: dectVC)
        present(navigationController, animated: true)
    }
}

extension FollowersListVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {return}
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: followers)
    }
}
