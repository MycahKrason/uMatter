//
//  RetrieveAffirmations.swift
//  iMatter
//
//  Created by Mycah on 11/18/19.
//  Copyright © 2019 Mycah Krason. All rights reserved.
//

import Foundation

class RetrieveAffirmations {
    // swiftlint:disable:next function_body_length
    func getAffirmations(apiPath: String,
                         completion: @escaping (_ error: String,
                                                _ artistArray: [AffirmationData]) -> Void) {

        var returnArray: [AffirmationData] = [AffirmationData]()
        let url = URL(string: Private().urlForAffirmations)
        var request = URLRequest(url: url!)

        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if error != nil {
                completion("Please connect to the internet", [])
                return
            }
            guard let jsonData = data else {return}
            do {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {

                    // Will need to determine Whether we are looking for
                    // affirmations_playlist
                    // builder_tracks
                    if apiPath == "positivity" ||
                        apiPath == "motivation" ||
                        apiPath == "anxiety" ||
                        apiPath == "confidence" {
                        print(apiPath)
                        //This is for the Affirmation Playlists
                        if let affirmationPlaylists = json["affirmations_playlist"] as? [String: Any] {
                            print("This is our location")
                            if let categoryList = affirmationPlaylists["\(apiPath)"] as? [[String: Any]] {
                                for track in categoryList {
                                    let safeId: String = track["id"] as? String ?? ""
                                    let safeTitle: String = track["title"] as? String ?? ""
                                    let safeAudio: String = track["audio"] as? String ?? ""
                                    let safeTime: String = track["time"] as? String ?? ""

                                    let affirmationData = AffirmationData(affirmationID: safeId,
                                                                          title: safeTitle,
                                                                          audio: safeAudio,
                                                                          time: safeTime)
                                    returnArray.append(affirmationData)
                                }
                            }
                        } else {
                            completion("Unable to find Affirmations", [])
                        }
                    } else if apiPath == "builder_positivity" ||
                                apiPath == "builder_motivation" ||
                                apiPath == "builder_anxiety" ||
                                apiPath == "builder_confidence"{
                        //Retrieve affirmation tracks depending on their category
                        if let builderCategory = json["builder_tracks"] as? [String: Any] {
                            //This is for the Affirmation Builder
                            if let builderTracks = builderCategory[apiPath] as? [[String: Any]] {
                                for track in builderTracks {
                                    let safeId: String = track["id"] as? String ?? ""
                                    let safeTitle: String = track["title"] as? String ?? ""
                                    let safeAudio: String = track["audio"] as? String ?? ""

                                    let affirmationData = AffirmationData(affirmationID: safeId,
                                                                          title: safeTitle,
                                                                          audio: safeAudio)
                                    returnArray.append(affirmationData)
                                }
                            } else {
                                completion("Unable to find Affirmation tracks", [])
                            }
                        }
                    } else if apiPath == "daily_5" {
                        //This is for the Affirmation Builder
                        if let dailyTracks = json["daily_5"] as? [[String: Any]] {
                            print("\n\n\(dailyTracks)\n\n")

                            for track in dailyTracks {
                                let safeId: String = track["id"] as? String ?? ""
                                let safeTitle: String = track["title"] as? String ?? ""
                                let safeAudio: String = track["audio"] as? String ?? ""
                                let safeTime: String = track["time"] as? String ?? ""

                                let affirmationData = AffirmationData(affirmationID: safeId,
                                                                      title: safeTitle,
                                                                      audio: safeAudio,
                                                                      time: safeTime)
                                returnArray.append(affirmationData)
                            }
                        } else {
                            completion("Unable to find Affirmation tracks", [])
                        }
                    }
                }
            } catch let error {
                print(error)
                completion("Unable to find Affirmations", [])
            }
            completion("", returnArray)
        }
        task.resume()
    }
}
