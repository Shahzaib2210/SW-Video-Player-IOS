//
//  ViewController.swift
//  SW Player
//
//  Created by Shahzaib on 10/27/21.
//  Copyright © 2021 Shahzaib. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Photos

class ViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    var playerController = AVPlayerViewController()
    var player:AVPlayer?
    
    var imagesAndVideos: PHFetchResult<PHAsset>!
    var fetchOptions = PHFetchOptions()
    
    let helper = Helper()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        FetchSongFromGallery()
    }
    
    private func FetchSongFromGallery() {
        
        PHPhotoLibrary.requestAuthorization (
            { [weak self] status in
                
                if status == .authorized
                {
                    print("Permision Granted")
                    
                    DispatchQueue.main.async {
                        
                        self?.fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false) ]
                        self?.fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)
                        self?.imagesAndVideos = PHAsset.fetchAssets(with: self?.fetchOptions)
                        self?.tableView.reloadData()
                    }
                }
                else
                {
                    DispatchQueue.main.async
                        {
                            self?.helper.showAlert(message: "Please Go to Setting -> SW Player -> Photos -> Click on Read and Write.", title: "Alert!", viewController: self!)
                    }
                }
        })
        
        self.fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false) ]
        self.fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)
        self.imagesAndVideos = PHAsset.fetchAssets(with: self.fetchOptions)
        self.tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 160
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return imagesAndVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
        let asset = imagesAndVideos!.object(at: indexPath.row)
        
        let width: CGFloat = 408
        let height: CGFloat = 154
        
        let size = CGSize(width:width, height:height)
        
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.aspectFill, options: nil)
        { (image, userInfo) -> Void in
            
            cell.thumbnail.image = image
            
            if  cell.watchtime.text != nil
            {
                cell.watchtime.text = String(format: "%02d:%02d",Int((asset.duration / 60)),Int(asset.duration) % 60)
            } else {
                print("Mo Value")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let path = imagesAndVideos!.object(at: indexPath.row)
        self.playVideo(asset: path)
    }
    
    func playVideo(asset: PHAsset)
    {
        guard asset.mediaType == .video else {
            // Handle if the asset is not a video.
            return
        }
        
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        
        PHCachingImageManager().requestPlayerItem(forVideo: asset, options: options)
        { [weak self] (playerItem, info) in
            DispatchQueue.main.async
                {
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = AVPlayer(playerItem: playerItem)
                    self?.present(playerViewController, animated: true)
                    {
                        playerViewController.player?.play()
                    }
            }
        }
    }
}
