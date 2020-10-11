//
//  AudioPlayerViewController.swift
//  iMatter
//
//  Created by Mycah on 11/17/19.
//  Copyright © 2019 Mycah Krason. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayerViewController: UIViewController {

    @IBOutlet weak var audioScrubber: UISlider!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var playPauseImage: UIImageView!
    @IBOutlet weak var timeDuration: UILabel!
    @IBOutlet weak var timeLapse: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var audioTitleDisplay: UILabel!

    var stringURLRecieved: String?
    var audioTitle: String?

    private var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "IMG_1057 copy"), for: .default)
        title = "Affirmation Player"

        // Access the shared, singleton audio session instance
        let session = AVAudioSession.sharedInstance()
        do {
            // Configure the audio session for movie playback
            try session.setCategory(AVAudioSession.Category.playback,
                                    mode: AVAudioSession.Mode.moviePlayback,
                                    options: [])
        } catch let error as NSError {
            print("Failed to set the audio session category and mode: \(error.localizedDescription)")
        }

        activitySpinner.startAnimating()

        //turn off slider until audio is loaded
        timeSlider.isEnabled = false

        audioTitleDisplay.text = audioTitle

        if let stringURL = stringURLRecieved {
            let url = URL.init(string: stringURL)

            player = AVPlayer.init(url: url!)
            player?.play()
            playPauseImage.image = UIImage(systemName: "pause")

            //receive notification when audio stops
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.didPlayToEnd),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: nil)

            //recieve notification when Audio is ready to play
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(playerItemDidReadyToPlay(notification:)),
                                                   name: .AVPlayerItemNewAccessLogEntry,
                                                   object: player?.currentItem)

            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval,
                                            queue: DispatchQueue.main,
                                            using: { [weak self] (progressTime) in
                                                let time = CMTimeGetSeconds(progressTime)
                                                let seconds = Int(time) % 60
                                                let minutes = Int(time) / 60
                                                let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
                                                self?.timeLapse.text = timeFormatString

                                                //Move the slider thumb
                                                if let duration = self?.player?.currentItem?.duration {
                                                    let durationSeconds = CMTimeGetSeconds(duration)
                                                    self?.timeSlider.value = Float(time / durationSeconds)
                                                }
                                            })
        }
    }

    @objc func playerItemDidReadyToPlay(notification: Notification) {
        if notification.object as? AVPlayerItem != nil {
            // player is ready to play now!!

            activitySpinner.stopAnimating()

            //Allow access to the slider
            timeSlider.isEnabled = true

            //Set the time Duration
            let timeRange = self.player?.currentItem?.loadedTimeRanges[0].timeRangeValue
            let duration = CMTimeGetSeconds(timeRange!.duration)
            let seconds = Int(duration) % 60
            let minutes = Int(duration) / 60
            let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
            timeDuration.text = timeFormatString
        }
    }

    @objc func didPlayToEnd() {
        player?.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: 1))
        playPauseImage.image = UIImage(systemName: "play")

        //play again
        //        player?.play()
        //        playPauseImage.image = UIImage(systemName: "pause")
    }

    @IBAction func playPauseAudioClicked(_ sender: Any) {
        if player?.timeControlStatus == .playing {
            player?.pause()
            playPauseImage.image = UIImage(systemName: "play")
        } else if player?.timeControlStatus == .paused {
            player?.play()
            playPauseImage.image = UIImage(systemName: "pause")
        }
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func timeSliderAction(_ sender: Any) {
        let timeRange = self.player?.currentItem?.loadedTimeRanges[0].timeRangeValue
        let duration = CMTimeGetSeconds(timeRange!.duration)
        let value = Float64(timeSlider.value) * duration
        let seekTime = CMTime(value: Int64(value), timescale: 1)

        player?.seek(to: seekTime, completionHandler: {(completedSeek) in
            self.player?.pause()

            if completedSeek {
                self.player?.play()
            }
        })
    }
}
