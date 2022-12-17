//
//  AlbumListViewController.swift
//  Albums
//
//  Created by 박다연 on 2022/12/09.
//

import UIKit
import Photos

class AlbumListViewController: UIViewController {

    @IBOutlet weak var albumListCollectionView: UICollectionView!
    
    // 앨범에 분류된 사진 저장
    var fetchResult: [PHFetchResult<PHAsset>] = []
    var fetchCollections: [PHAssetCollection] = []
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    
    let cellIdentifier: String = "albumListCell"
    
    // MARK: - requestCollection (사진 가져오는 함수)
    func requestCollection() {
        fetchResult.removeAll()
        fetchCollections.removeAll()
        
        let recentList: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        let favoriteList: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        let albumList: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        
        guard let cameraRollCollection = recentList.firstObject else {
            return
        }
        
        let fetchOptions = PHFetchOptions()
        // 최신순 정렬
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        for i in 0 ..< recentList.count {
            let assets = PHAsset.fetchAssets(in: recentList[i], options: fetchOptions)
            
            if assets.count > 0 {
                self.fetchCollections.append(recentList[i])
                self.fetchResult.append(assets)
            }
        }
        
        for i in 0 ..< favoriteList.count {
            let assets = PHAsset.fetchAssets(in: favoriteList[i], options: fetchOptions)
            
            if assets.count > 0 {
                self.fetchCollections.append(favoriteList[i])
                self.fetchResult.append(assets)
            }
        }
        
        for i in 0 ..< albumList.count {
            let assets = PHAsset.fetchAssets(in: albumList[i], options: fetchOptions)

            if assets.count > 0 {
                self.fetchCollections.append(albumList[i])
                self.fetchResult.append(assets)
            }
        }
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "앨범"
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - collectionViewSetting
        albumListCollectionView.dataSource = self
        albumListCollectionView.delegate = self
        // MARK: - collectionViewLayout
        collectionViewLayout()
        // MARK: - photoAuthorizationStatus
        photoAuthorizationStatus()
        
        PHPhotoLibrary.shared().register(self)
    }
    
    // MARK: - collectionViewLayout
    func collectionViewLayout() {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)

        let itemWidth: CGFloat = UIScreen.main.bounds.width / 2.0
        flowLayout.itemSize = CGSize(width: itemWidth - 30, height: itemWidth + 20)
        
        self.albumListCollectionView.collectionViewLayout = flowLayout
    }

    // MARK: - photoAuthorizationStatus
    func photoAuthorizationStatus() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            print("접근 허가됨")
            self.requestCollection()
            OperationQueue.main.addOperation {
                self.albumListCollectionView.reloadData()
            }
        case .denied:
            print("접근 불허")
        case .notDetermined:
            print("아직 응답하지 않음")
            PHPhotoLibrary.requestAuthorization( { (status) in
                switch status {
                case .authorized:
                    print("접근 허가됨")
                    self.requestCollection()
                    OperationQueue.main.addOperation {
                        self.albumListCollectionView.reloadData()
                    }
                case .denied:
                    print("접근 불허")
                default: break
                }
            })
        case .restricted:
            print("접근 제한")
        default:
            break
        }
    }
    
    // MARK: - prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextViewController: AlbumDetailViewController = segue.destination as? AlbumDetailViewController else { return }
        
        guard let cell: AlbumListCollectionViewCell = sender as? AlbumListCollectionViewCell else { return }
        
        guard let index: IndexPath = self.albumListCollectionView.indexPath(for: cell) else {
            return
        }
        
        nextViewController.fetchCollections = self.fetchCollections[index.item]
        nextViewController.fetchResult = self.fetchResult[index.item]
    }
}

// MARK: - UICollectionViewDelegate
extension AlbumListViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension AlbumListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = albumListCollectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? AlbumListCollectionViewCell else {
            return  UICollectionViewCell()
        }
        
        // 앨범 첫 사진 가져오기
        let asset: PHAsset = fetchResult[indexPath.item].object(at: 0)
        let width = (albumListCollectionView.frame.size.width / 2) - 10
        imageManager.requestImage(for: asset,
                                  targetSize: CGSize(width: 100, height: 100),
                                  contentMode: .aspectFill,
                                  options: nil,
                                  resultHandler: { asset, _ in
            // 앨범 대표 사진을 첫 사진으로 설정
            cell.albumImageView.image = asset
        })

        cell.albumNameLabel.text = fetchCollections[indexPath.item].localizedTitle
        cell.photoCountLabel.text = "\(fetchResult[indexPath.item].count)"
        
        return cell
    }
    
}

// MARK: - PHPhotoLibraryChangeObserver
extension AlbumListViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        OperationQueue().addOperation {
            self.requestCollection()
            OperationQueue.main.addOperation{
                self.albumListCollectionView.reloadData()
            }
        }
    }
}
