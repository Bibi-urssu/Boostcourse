//
//  ImageZoomViewController.swift
//  Albums
//
//  Created by 박다연 on 2022/12/13.
//

import UIKit
import Photos

class ImageZoomViewController: UIViewController {
    
    @IBOutlet weak var shareBarButton: UIBarButtonItem!
    @IBOutlet weak var favoriteBarButton: UIBarButtonItem!
    @IBOutlet weak var deleteBarButton: UIBarButtonItem!
    @IBOutlet weak var zoomImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var asset: PHAsset = PHAsset()
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    var favoriteMode: FavoriteMode = .favorite
    
    @IBAction func shareBarButtonTapped(_ sender: UIBarButtonItem) {
        OperationQueue().addOperation {
            var imageShare = UIImage()
            self.imageManager.requestImage(for: self.asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil, resultHandler: { image, _ in
                if let image = image {
                    OperationQueue.main.addOperation {
                        imageShare = image

                        let activityViewController = UIActivityViewController(activityItems: [imageShare], applicationActivities: nil)
                        activityViewController.popoverPresentationController?.sourceView = self.view
                        self.present(activityViewController, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    @IBAction func favoriteBarButtonTapped(_ sender: UIBarButtonItem) {
        switch favoriteMode {
        case .basic:
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest(for: self.asset).isFavorite = true
            } completionHandler: { (success, error) in
                OperationQueue.main.addOperation {
                    self.favoriteBarButton.image = UIImage(systemName: "heart.fill")
                    self.favoriteMode = .favorite
                }
            }
        case .favorite:
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest(for: self.asset).isFavorite = false
            } completionHandler: { (success, error) in
                OperationQueue.main.addOperation {
                    self.favoriteBarButton.image = UIImage(systemName: "heart")
                    self.favoriteMode = .basic
                }
            }
        }
    }
    
    @IBAction func deleteBarButtonTapped(_ sender: UIBarButtonItem) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.deleteAssets([self.asset] as NSArray)
        } completionHandler: { (success, error) in
            if success {
                OperationQueue.main.addOperation {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                print("\(String(describing: error))")
            }
        }
    }

    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        PHPhotoLibrary.shared().performChanges {
            if self.asset.isFavorite {
                OperationQueue.main.addOperation {
                    self.favoriteBarButton.image = UIImage(systemName: "heart.fill")
                }
                self.favoriteMode = .favorite
            } else {
                OperationQueue.main.addOperation {
                    self.favoriteBarButton.image = UIImage(systemName: "heart")
                }
                self.favoriteMode = .basic
            }
        }
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        
        setZoomImageView()
        setFormatter()
        zoomImageViewTapped()
    }
    
    // MARK: - setZoomImageView
    private func setZoomImageView() {
        OperationQueue().addOperation {
            self.imageManager.requestImage(for: self.asset, targetSize: CGSize(width: self.asset.pixelWidth, height: self.asset.pixelHeight), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
                OperationQueue.main.addOperation {
                    self.zoomImageView.image = image
                }
            })
        }
    }
    
    // MARK: - zoomImageViewTapped
    private func zoomImageViewTapped() {
        let tapImageViewRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideNavigationBar(_:)))
        // 이미지뷰가 상호작용할 수 있게 설정
        self.zoomImageView.isUserInteractionEnabled = true
        // 이미지뷰에 제스처 인식기 연결
        self.zoomImageView.addGestureRecognizer(tapImageViewRecognizer)
    }
    
    @objc func hideNavigationBar(_ sender: UITapGestureRecognizer) {
        if self.navigationController?.isNavigationBarHidden == false && self.toolbar.isHidden == false {
            self.navigationController?.isNavigationBarHidden = true
            self.toolbar.isHidden = true
            self.view.backgroundColor = .black
        } else {
            self.navigationController?.isNavigationBarHidden = false
            self.toolbar.isHidden = false
            self.view.backgroundColor = .white
        }
    }
    
    // MARK: - setFormatter
    private func setFormatter() {
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "yyyy-MM-dd"
        let timeFomatter = DateFormatter()
        timeFomatter.dateFormat = "a HH:mm:ss"
        
        guard let creationDate = self.asset.creationDate else { return }
        let date = dateFomatter.string(from: creationDate)
        let time = timeFomatter.string(from: creationDate)
        
        self.navigationItem.titleView = setNavigationTitle(title: date, subtitle: time)
    }
    
    // MARK: - setNavigationTitle
    private func setNavigationTitle(title: String, subtitle: String) -> UIView {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.textAlignment = .center
        titleLabel.text = title
        titleLabel.sizeToFit()

        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 15, width: 0, height: 0))
        subtitleLabel.backgroundColor = .clear
        subtitleLabel.textColor = .gray
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()

        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: titleLabel.frame.size.width, height: 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)

        let widthDifference = subtitleLabel.frame.size.width - titleLabel.frame.size.width

        if widthDifference < 0 {
            let x = widthDifference / 2
            subtitleLabel.frame.origin.x = abs(x)
        } else {
            let newX = widthDifference / 2
            titleLabel.frame.origin.x = newX
        }
        
        return titleView
    }
}

// MARK: - UIScrollViewDelegate
extension ImageZoomViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.zoomImageView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.view.backgroundColor = .black
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.toolbar.isHidden = true
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scale == 1.0 {
            self.view.backgroundColor = .white
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.toolbar.isHidden = false
    }
}

// MARK: - PHPhotoLibraryChangeObserver
extension ImageZoomViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let change = changeInstance.changeDetails(for: self.asset) else { return }
        guard let asset = change.objectAfterChanges else { return }
        if asset.isFavorite != self.favoriteMode.bool {
            if asset.isFavorite {
                PHPhotoLibrary.shared().performChanges {
                    self.favoriteMode = .favorite
                } completionHandler: { (success, error) in
                    OperationQueue.main.addOperation {
                        self.favoriteBarButton.image = UIImage(systemName: "heart.fill")
                    }
                }
            } else {
                PHPhotoLibrary.shared().performChanges {
                    self.favoriteMode = .basic
                } completionHandler: { (success, error) in
                    OperationQueue.main.addOperation {
                        self.favoriteBarButton.image = UIImage(systemName: "heart")
                    }
                }
            }
        }
    }
}

// MARK: - FavoriteMode
extension ImageZoomViewController {
    enum FavoriteMode {
        case favorite
        case basic
        
        var bool: Bool {
            switch self {
            case .favorite:
                return true
            case .basic:
                return false
            }
        }
    }
}

