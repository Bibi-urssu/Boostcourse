//
//  AlbumDetailViewController.swift
//  Albums
//
//  Created by 박다연 on 2022/12/09.
//

import UIKit
import Photos

class AlbumDetailViewController: UIViewController {

    @IBOutlet weak var photoCollectionView: UICollectionView!
 
    @IBOutlet weak var selectBarButton: UIBarButtonItem!
    @IBOutlet weak var shareBarButton: UIBarButtonItem!
    @IBOutlet weak var sortBarButton: UIBarButtonItem!
    @IBOutlet weak var deleteBarButton: UIBarButtonItem!
    
    let segueIdentifier = "ImageZoomSegue"
    
    var selectImage: [Int: PHAsset] = [:]
    var selectImageState: Bool = false
    var selectMode: SelectMode = .basic
    var dateSortMode: DateSortMode = .latest

    @IBAction func selectBarButtonTapped(_ sender: UIBarButtonItem) {
        switch selectMode {
        case .basic:
            self.navigationItem.title = "항목 선택"
            self.selectBarButton.title = "취소"
            self.sortBarButton.isEnabled = false
            
            selectMode = .select
        case .select:
            self.photoCollectionView.reloadData()
            self.selectImage.removeAll()
            self.navigationItem.title = fetchCollections.localizedTitle
            self.selectBarButton.title = "선택"
            self.shareBarButton.isEnabled = false
            self.deleteBarButton.isEnabled = false
            self.sortBarButton.isEnabled = true
            
            selectMode = .basic
        }
    }
    
    @IBAction func shareBarButtonTapped(_ sender: UIBarButtonItem) {
        OperationQueue.main.addOperation {
            let asset: [PHAsset] = Array(self.selectImage.values)
            var imageShare: [UIImage] = []
            for i in 0..<asset.count {
                self.imageManager.requestImage(for: asset[i], targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil) { (image, _) in
                    if let image = image {
                        OperationQueue.main.addOperation {
                            imageShare.append(image)

                            let activityViewController = UIActivityViewController(activityItems: imageShare, applicationActivities: nil)
                            self.present(activityViewController, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func deleteBarButtonTapped(_ sender: UIBarButtonItem) {
        PHPhotoLibrary.shared().performChanges {
            let asset = Array(self.selectImage.values)
            PHAssetChangeRequest.deleteAssets(asset as NSArray)
        } completionHandler: { (success, error) in
            if success {
                OperationQueue.main.addOperation {
                    self.navigationItem.title = self.fetchCollections.localizedTitle
                    self.selectBarButton.title = "선택"
                    self.sortBarButton.isEnabled = true
                    self.shareBarButton.isEnabled = false
                    self.deleteBarButton.isEnabled = false
                    self.selectImage.removeAll()
                    self.selectMode = .select
                    self.photoCollectionView.reloadData()
                }
            } else {
                print("\(String(describing: error))")
            }
        }
    }
    
    @IBAction func sortBarButtonTapped(_ sender: UIBarButtonItem) {
        let fetchOptions = PHFetchOptions()
        switch dateSortMode {
        case .latest:
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            self.fetchResult = PHAsset.fetchAssets(in: fetchCollections, options: fetchOptions)
            OperationQueue.main.addOperation {
                self.photoCollectionView.reloadData()
            }
            self.sortBarButton.title = "과거순"
            self.dateSortMode = .past
        case .past:
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            self.fetchResult = PHAsset.fetchAssets(in: fetchCollections, options: fetchOptions)
            OperationQueue.main.addOperation {
                self.photoCollectionView.reloadData()
            }
            self.sortBarButton.title = "최신순"
            self.dateSortMode = .latest
        }
        
    }
    
    var cellIdentifier: String = "photoCell"
    
    var fetchResult: PHFetchResult<PHAsset> = PHFetchResult<PHAsset>()
    var fetchCollections: PHAssetCollection = PHAssetCollection()
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = fetchCollections.localizedTitle
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.shareBarButton.isEnabled = false
        self.deleteBarButton.isEnabled = false
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - collectionViewSetting
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        collectionViewLayout()
        PHPhotoLibrary.shared().register(self)

    }
    
    // MARK: - prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let asset = sender as! PHAsset

        if segue.identifier == self.segueIdentifier {
            if let viewController = segue.destination as? ImageZoomViewController {
                viewController.asset = asset
            }
        }
    }
    
    // MARK: - collectionViewLayout
    private func collectionViewLayout() {
        let itemWidth: CGFloat = UIScreen.main.bounds.width / 3.0

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: itemWidth - 2, height: itemWidth)
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 3
        flowLayout.minimumInteritemSpacing = 2
        
        photoCollectionView.collectionViewLayout = flowLayout
    }
}

// MARK: - UICollectionViewDelegate
extension AlbumDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch selectMode {
        case .select:
            guard let cell = photoCollectionView.cellForItem(at: indexPath) as? AlbumDetailCollectionViewCell else { return }
            if cell.photoImageView.alpha == 1 {
                cell.photoImageView.alpha = 0.5
                cell.photoImageView.layer.borderWidth = 2
                cell.photoImageView.layer.borderColor = UIColor.black.cgColor

                let asset = fetchResult[indexPath.item]
                self.selectImage.updateValue(asset, forKey: indexPath.item)
                self.navigationItem.title = "\(self.selectImage.count)장 선택"
                
                self.shareBarButton.isEnabled = true
                self.deleteBarButton.isEnabled = true
            }
            else {
                cell.photoImageView.alpha = 1
                cell.photoImageView.layer.borderWidth = 0

                self.selectImage.removeValue(forKey: indexPath.item)
                self.navigationItem.title = "\(self.selectImage.count)장 선택"

                if self.selectImage.count == 0 {
                    self.shareBarButton.isEnabled = false
                    self.deleteBarButton.isEnabled = false
                    self.navigationItem.title = "항목 선택"
                }
            }
        case .basic:
            photoCollectionView.deselectItem(at: indexPath, animated: true)
            let asset = fetchResult[indexPath.item]
            performSegue(withIdentifier: self.segueIdentifier, sender: asset)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension AlbumDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? AlbumDetailCollectionViewCell else { return UICollectionViewCell() }

            let asset = self.fetchResult[indexPath.item]
            self.imageManager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil) { (image, _) in
                    cell.photoImageView?.image = image
                    cell.photoImageView.alpha = 1
                    cell.photoImageView.layer.borderWidth = 0
            }

        return cell
    }
    
}

// MARK: - Mode
extension AlbumDetailViewController {
    enum SelectMode {
        case select
        case basic
    }
    
    enum DateSortMode {
        case latest
        case past
    }
}

// MARK: - PHPhotoLibraryChangeObserver
extension AlbumDetailViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: fetchResult) else { return }
        fetchResult = changes.fetchResultAfterChanges
        OperationQueue.main.addOperation {
            self.photoCollectionView.reloadData()
        }
    }
}
