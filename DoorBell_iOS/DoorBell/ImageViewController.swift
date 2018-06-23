//
//  ImageViewController
//  SamplePhotoApp
//
//  Created by Douglas Galante on 4/6/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit
import PhotosUI
import Alamofire
import MBProgressHUD
import MobileCoreServices
import LocalAuthentication

class ImageViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let dataStore = DataStore.sharedInstance
    var spacing: CGFloat!
    var sectionInsets: UIEdgeInsets!
    var itemSize: CGSize!
    var numberOfCellsPerRow: CGFloat = 3
    var selectedPhotoIndex = -1
    var selectedAlbumIndex = -1
    var hitBottomOfScrollView = false
    fileprivate let refreshControl = UIRefreshControl()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var button: UIBarButtonItem!
    
    @IBAction func chose(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Chose photo", message: nil, preferredStyle: .actionSheet)
        let alertActionLib = UIAlertAction(title: "Album", style: .default) { (_) in
            if #available(iOS 9.1, *) {
                self.imagePickerController.mediaTypes = [kUTTypeLivePhoto as String, kUTTypeImage as String]
            } else {
                self.imagePickerController.mediaTypes = [kUTTypeImage as String]
            }
            self.imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let alertActionCamera = UIAlertAction(title: "Camera", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
        }
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(alertActionLib)
        alertController.addAction(alertActionCamera)
        alertController.addAction(alertActionCancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        return imagePickerController
    }()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let livePhoto: PHLivePhoto? = info[UIImagePickerControllerLivePhoto] as? PHLivePhoto
        if (livePhoto != nil) {
//            let livePhotoView = PHLivePhotoView(frame: backgroundView.frame)
//            livePhotoView.livePhoto = info[UIImagePickerControllerLivePhoto] as? PHLivePhoto
//            livePhotoView.startPlayback(with: .full)
//            livePhotoView.contentMode = .scaleAspectFill
//            backgroundView.addSubview(livePhotoView)
            print("2")
        } else {
//            let staticPhotoView = UIImageView(frame: backgroundView.frame)
//            staticPhotoView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
//            staticPhotoView.contentMode = .scaleAspectFill
//            backgroundView.addSubview(staticPhotoView)
            print("2")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        configureLayout()
        getPhotoData()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(getPhotoData), for: .valueChanged)
        
//        button.action = #selector(buttonClicked)
    
    }
    
//    @objc func buttonClicked(sender: UIBarButtonItem) {
//        print("ok")
//    }
    
    
    
    // Gets photodata when collection view is loaded or refreshed
    func getPhotoData() {
        errorView.isHidden = true
        dataStore.getJSON { success in
            if success {
                self.dataStore.albums = []
                self.dataStore.appendNext30Photos {
                    DispatchQueue.main.async {
                        self.activityIndicatorView.stopAnimating()
                        self.refreshControl.endRefreshing()
                        self.collectionView.reloadData()
                    }
                }
            } else {
                if self.dataStore.albums.isEmpty {
                    self.errorView.isHidden = false
                }
                self.activityIndicatorView.stopAnimating()
                self.refreshControl.endRefreshing()
            }
        }
    }    
    
}



// Updates collection view when swipping to new images in detail view controller
extension ImageViewController: GetPhotoDataDelegate {
    
    func getNextBatch(with completion: @escaping (Bool) -> Void) {
        dataStore.appendNext30Photos {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.hitBottomOfScrollView = false
                completion(true)
            }
        }
    }
    
    
}



// MARK: collectionView datasource and Delegate
extension ImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataStore.albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataStore.albums[section].photos.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! AlbumCollectionViewHeader
        
        headerView.textLabel.text = "Album: \(dataStore.albums[indexPath.section].albumID)"
        
        return headerView
    }
    
    // Handles downloading thumbnail images for cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        let photo = dataStore.albums[indexPath.section].photos[indexPath.row]
        
        if let thumbnail = photo.thumbnail {
            cell.errorView.isHidden = true
            cell.imageView.isHidden = false
            cell.activityIndicatorView.stopAnimating()
            cell.imageView.image = thumbnail
        } else {
            cell.activityIndicatorView.startAnimating()
            cell.imageView.image = nil
            photo.downloadThumbnail {
                DispatchQueue.main.async {
                    if photo.thumbnail != nil {
                        cell.imageView.image = photo.thumbnail
                    } else {
                        cell.errorView.isHidden = false
                        cell.imageView.isHidden = true
                    }
                    cell.activityIndicatorView.stopAnimating()
                }
            }
        }
    
        return cell
    }

    // Handles creating more photoData when collection view reachs bottom of collection view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + 1) >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            if !hitBottomOfScrollView {
                hitBottomOfScrollView = true
                dataStore.appendNext30Photos {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.hitBottomOfScrollView = false
                    }
                }
            }
        }
    }
    
    // MARK: Segue
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPhotoIndex = indexPath.row
        selectedAlbumIndex = indexPath.section
        self.performSegue(withIdentifier: "presentDetailView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentDetailView" {
            let destination = segue.destination as! DetailViewController
            destination.albumIndex = selectedAlbumIndex
            destination.photoIndex = selectedPhotoIndex
            destination.delegate = self
        }
    }
    
    
}



// MARK: collectionView Layout
extension ImageViewController: UICollectionViewDelegateFlowLayout {
    
    func configureLayout () {
        spacing = 5
        let itemWidth = (UIScreen.main.bounds.width / numberOfCellsPerRow) - (spacing * (numberOfCellsPerRow + 1) / numberOfCellsPerRow)
        let itemHeight = itemWidth
        sectionInsets = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    
}



