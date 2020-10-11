//
//  CustomAffirmationPlayerViewController.swift
//  iMatter
//
//  Created by Mycah on 11/26/19.
//  Copyright © 2019 Mycah Krason. All rights reserved.
//
import UIKit
import AVFoundation

class CustomAffirmationPlayerViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var repeatBtnDisplay: UIImageView!
    @IBOutlet weak var playPauseBtnDisplay: UIImageView!
    @IBOutlet weak var affirmationDuration: UILabel!
    @IBOutlet weak var currentAffirmationDisplay: UILabel!
    @IBOutlet weak var affirmationSliderDisplay: UISlider!

    private var currentAffirmationCount = 0
    var receivedArray: [SelectedAffirmation] = [SelectedAffirmation]()
    var receivedAmbience: String?
    private var isOnRepeat = false

    private var affirmationPlayer: AVPlayer?
    private var ambiencePlayer: AVAudioPlayer?

    // swiftlint:disable:next function_body_length
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomAffirmationPlayerPresenter(vcView: self).presentScene()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "IMG_1057 copy"), for: .default)
        title = "Builder Player"
        repeatBtnDisplay.tintColor = UIColor.darkGray

        //Play Affirmations
        playAffirmationTrack()

        ambiencePlayer?.delegate = self

        //Play Music
        if receivedAmbience == "Summer"{
            playAmbienceTrack(trackName: "Summer")
        } else if receivedAmbience == "Creative Minds" {
            playAmbienceTrack(trackName: "CreativeMinds")
        } else if receivedAmbience == "Better Days" {
            playAmbienceTrack(trackName: "BetterDays")
        } else if receivedAmbience == "Acoustic Breeze" {
            playAmbienceTrack(trackName: "AcousticBreeze")
        } else if receivedAmbience == "Birth of a Hero" {
            playAmbienceTrack(trackName: "BirthOfAHero")
        } else if receivedAmbience == "Energy" {
            playAmbienceTrack(trackName: "Energy")
        } else if receivedAmbience == "Inspire" {
            playAmbienceTrack(trackName: "Inspire")
        } else if receivedAmbience == "Memories" {
            playAmbienceTrack(trackName: "Memories")
        } else if receivedAmbience == "Perception" {
            playAmbienceTrack(trackName: "Perception")
        } else if receivedAmbience == "Going Higher" {
            playAmbienceTrack(trackName: "GoingHigher")
        } else if receivedAmbience == "Slow Motion" {
            playAmbienceTrack(trackName: "SlowMotion")
        } else if receivedAmbience == "Elevate" {
            playAmbienceTrack(trackName: "Elevate")
        }

        //Play Nature
        else if receivedAmbience == "Forest" {
            playAmbienceTrack(trackName: "Forest")
        } else if receivedAmbience == "Ocean" {
            playAmbienceTrack(trackName: "Ocean")
        } else if receivedAmbience == "Rain" {
            playAmbienceTrack(trackName: "Rain")
        } else if receivedAmbience == "Fireplace" {
            playAmbienceTrack(trackName: "Fireplace")
        } else {
            //You would have received a request to not play any background sound
            //You need to manually set the pause button
            playPauseBtnDisplay.image = UIImage(systemName: "pause")
        }

        //Set Duration
        affirmationDuration.text = "\(receivedArray.count)"
        affirmationSliderDisplay.isEnabled = true

        //Play audio in the background
        let session = AVAudioSession.sharedInstance()
        do {
            // Configure the audio session for playback
            try session.setCategory(AVAudioSession.Category.playback,
                                    mode: AVAudioSession.Mode.moviePlayback,
                                    options: [])
        } catch let error as NSError {
            print("Failed to set the audio session category and mode: \(error.localizedDescription)")
        }

        //receive notification when audio stops
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didPlayToEnd),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: nil)

        //Get notified when done sliding
        affirmationSliderDisplay.addTarget(self,
                                           action: #selector(sliderDidEndSliding),
                                           for: [.touchUpInside, .touchUpOutside])
    }

    func playAffirmationTrack() {
        //Not exactly sure the reason for this - but the delegate needs to be called here instead of viewdidload
        ambiencePlayer?.delegate = self

        if receivedArray.count > 0 {
            //play the Affirmation
            if currentAffirmationCount < receivedArray.count {
                let url = URL.init(string: receivedArray[currentAffirmationCount].audio!)
                affirmationPlayer = AVPlayer.init(url: url!)
                affirmationPlayer?.play()
            }

            //Set slider activity
            affirmationSliderDisplay.value = Float(currentAffirmationCount) / Float(receivedArray.count - 1)

            if (currentAffirmationCount + 1) > receivedArray.count {
                currentAffirmationDisplay.text = "\(currentAffirmationCount)"
            } else {
                currentAffirmationDisplay.text = "\(currentAffirmationCount + 1)"
            }
        }
    }

    fileprivate func playAmbienceTrack(trackName: String) {
        let soundURL = Bundle.main.url(forResource: trackName, withExtension: "mp3")

        do {
            ambiencePlayer = try AVAudioPlayer(contentsOf: soundURL!)
        } catch {
            print(error)
        }

        ambiencePlayer?.setVolume(0.5, fadeDuration: 0)
        ambiencePlayer?.play()
        playPauseBtnDisplay.image = UIImage(systemName: "pause")
    }

    @objc func didPlayToEnd() {
        if currentAffirmationCount < receivedArray.count - 1 {
            currentAffirmationCount += 1
            playAffirmationTrack()
        } else {
            //Playlist is over, reset affirmation track
            currentAffirmationCount = 0

            //Set slider activity
            affirmationSliderDisplay.value = Float(currentAffirmationCount) / Float(receivedArray.count - 1)
            currentAffirmationDisplay.text = "\(currentAffirmationCount + 1)"

            if !isOnRepeat {
                playPauseBtnDisplay.image = UIImage(systemName: "play")
                ambiencePlayer?.setVolume(0, fadeDuration: 3)
            } else {
                playAffirmationTrack()
            }
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if !ambiencePlayer!.isPlaying {
            ambiencePlayer?.play()
        }
        print("\n\nFinished\n\n")
    }

    @IBAction func affirmationSliderChanged(_ sender: Any) {
        affirmationPlayer?.pause()
        ambiencePlayer?.pause()

        let totalValForDisplay = receivedArray.count - 1
        let roundedVal = round((affirmationSliderDisplay.value * Float(totalValForDisplay)))

        currentAffirmationCount = Int(roundedVal)
        currentAffirmationDisplay.text = "\(Int(roundedVal) + 1)"
    }

    @objc func sliderDidEndSliding() {
        playPauseBtnDisplay.image = UIImage(systemName: "pause")
        playAffirmationTrack()
        ambiencePlayer?.setVolume(0.5, fadeDuration: 0)
        ambiencePlayer?.play()
    }

    @IBAction func playPauseBtnPressed(_ sender: Any) {
        if affirmationPlayer?.timeControlStatus == .playing {
            affirmationPlayer?.pause()
            ambiencePlayer?.setVolume(0.5, fadeDuration: 0)
            ambiencePlayer?.pause()
            playPauseBtnDisplay.image = UIImage(systemName: "play")
        } else if affirmationPlayer?.timeControlStatus == .paused {
            playAffirmationTrack()
            ambiencePlayer?.setVolume(0.5, fadeDuration: 0)
            ambiencePlayer?.play()
            playPauseBtnDisplay.image = UIImage(systemName: "pause")
        }
    }

    @IBAction func repeatBtnPressed(_ sender: Any) {
        if isOnRepeat {
            isOnRepeat = false
            repeatBtnDisplay.tintColor = UIColor.darkGray
        } else {
            isOnRepeat = true
            repeatBtnDisplay.tintColor = UIColor.white
        }
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
