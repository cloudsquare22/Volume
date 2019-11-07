//
//  ViewController.swift
//  Volume
//
//  Created by InabaShin on 2016/08/30.
//  Copyright © 2016年 shi-n. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {
    
    @IBOutlet weak var sliderVolume: UISlider!
    @IBOutlet weak var labelVolume: UILabel!
    @IBOutlet weak var labelAlbum: UILabel!
    @IBOutlet weak var labelArtist: UILabel!
    @IBOutlet weak var labelPersistentId: UILabel!
    @IBOutlet weak var labelSaveVolume: UILabel!
    
    var player:MPMusicPlayerController! = MPMusicPlayerController.systemMusicPlayer
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

//        let image = UIImage(contentsOfFile: "volume.png")
//        sliderVolume.setThumbImage(image, forState: UIControlState.Normal)
//        sliderVolume.setThumbImage(image, forState: UIControlState.Highlighted)
        sliderVolume.setThumbImage(UIImage(named: "volume50.png"), for: UIControl.State())

        let volumeValue : Float = player.value(forKey: "volume")! as! Float
        sliderVolume.value = volumeValue
        dispLabelVolume(volumeValue)
        displabelMusic()
        loadDispSaveVolume()
        
        let notif = NotificationCenter.default
        notif.addObserver(self, selector: #selector(ViewController.change(_:)), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: player)
        player.beginGeneratingPlaybackNotifications()
    }
    
    @objc func change(_ notification:Notification?) {
        displabelMusic()
        loadDispSaveVolume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sliderVolumeValueChange(_ sender: AnyObject) {
        let volumeValue : Float = sliderVolume.value
        dispLabelVolume(volumeValue)
        displabelMusic()
        player.setValue(volumeValue, forKey: "volume")
    }
    
    @IBAction func touchButtonSave(_ sender: AnyObject) {
        print("Save!!")
        if let now : MPMediaItem = player.nowPlayingItem {
            let volumeValue : Float = Float(labelVolume.text!)!
            userDefaults.set(volumeValue, forKey: String(now.albumPersistentID))
            loadDispSaveVolume()
            print("Save Complete!!")
        }
    }
    
    @IBAction func touchButtonSet(_ sender: AnyObject) {
        print("Set!!")
        if let now : MPMediaItem = player.nowPlayingItem {
            if userDefaults.bool(forKey: String(now.albumPersistentID)) == true {
                let saveVolume = userDefaults.float(forKey: String(now.albumPersistentID))
                dispLabelVolume(saveVolume)
                sliderVolume.value = saveVolume
                player.setValue(saveVolume, forKey: "volume")
            }
        }
        
    }
    
    func dispLabelVolume(_ volumeValue:Float) {
        let volumeString = String(format: "%.2f", volumeValue)
        labelVolume.text = volumeString
//        print("volume[\(volumeValue)]")
    }
    
    func displabelMusic() {
        if let now : MPMediaItem = player.nowPlayingItem {
            labelAlbum.text = now.albumTitle
            labelArtist.text = now.artist
            labelPersistentId.text = String(now.albumPersistentID)
        }
        else {
            labelAlbum.text = "-"
            labelArtist.text = "-"
            labelPersistentId.text = "-"
        }
    }
    
    func loadDispSaveVolume() {
        var saveVolume:Float? = nil
        if let now : MPMediaItem = player.nowPlayingItem {
            if userDefaults.bool(forKey: String(now.albumPersistentID)) == true {
                saveVolume = userDefaults.float(forKey: String(now.albumPersistentID))
            }
        }
        if(saveVolume == nil) {
            labelSaveVolume.text = "No Save Data."
        }
        else {
            labelSaveVolume.text = String(format: "%.2f", saveVolume!)
        }
    }


}

