//
//  AffirmationsListViewController.swift
//  iMatter
//
//  Created by Mycah on 11/17/19.
//  Copyright © 2019 Mycah Krason. All rights reserved.
//

import UIKit
import CoreData

class AffirmationsListViewController: UIViewController, AffirmationsCellDelegate {
    @IBOutlet weak var affirmationTableView: UITableView!

    var recievedCategory: String?
    private var affirmationsArray: [AffirmationData] = [AffirmationData]()
    private var favoritesArray: [FavoriteAffirmations] = [FavoriteAffirmations]()

    //Context for Core Data
    weak var context: NSManagedObjectContext?
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate

    var infoButton: InfoButtonView?

    override func viewDidLoad() {
        super.viewDidLoad()
        AffirmationsListPresenter(vcView: self).presentScene()
        if let appDelegate = appDelegate {
            context = appDelegate.persistentContainer.viewContext
        }
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "IMG_1057 copy"), for: .default)

        infoButton = InfoButtonView(vcView: self, segueIdentifier: "affirmationPlayListToInfo")
        if let infoBtn = infoButton {
            infoBtn.addInfoButton()
        }

        //Set up the display
        affirmationTableView.rowHeight = 70
        if let categoryTitle = recievedCategory {
            title = categoryTitle
        }

        affirmationTableView.delegate = self
        affirmationTableView.dataSource = self

        affirmationTableView.register(UINib(nibName: "CustomAffirmationsCell", bundle: nil),
                                      forCellReuseIdentifier: "CustomAffirmationsCell")

        if recievedCategory != "Favorites"{
            RetrieveAffirmations().getAffirmations(apiPath: (recievedCategory?.lowercased())!,
                                                   completion: { _, result in
                                                    self.affirmationsArray = result
                                                    DispatchQueue.main.async {
                                                        self.affirmationTableView.reloadData()
                                                    }
                                                   })
        }
        //Load the saved Favorite Artists
        loadFavoriteAffirmationsFromCD()
    }

    //Save to Core Data
    fileprivate func saveFavoriteAffirmationsToCD() {
        do {
            try context?.save()
        } catch {
            print("Error Saving Coontent to Core Data")
        }
    }

    //Load from Core Data
    fileprivate func loadFavoriteAffirmationsFromCD() {
        print("\n\nloadFavoriteAffirmationsFromCD\n\n")
        let request: NSFetchRequest<FavoriteAffirmations> = FavoriteAffirmations.fetchRequest()
        do {
            if let favTracks = try context?.fetch(request) {
                favoritesArray = favTracks
            }
        } catch {
            print("Unable to Load Saved Favorite Artists - \(error)")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAudioPlayer"{
            if let indexPath = affirmationTableView.indexPathForSelectedRow {
                guard let destVC = segue.destination as? AudioPlayerViewController else {return}

                if recievedCategory != "Favorites"{
                    destVC.stringURLRecieved = affirmationsArray[indexPath.row].audio
                    destVC.audioTitle = affirmationsArray[indexPath.row].title
                } else {
                    destVC.stringURLRecieved = favoritesArray[indexPath.row].audio
                    destVC.audioTitle = favoritesArray[indexPath.row].title
                }
            }
        } else if segue.identifier == "affirmationPlayListToInfo" {
            guard let destVC = segue.destination as? TermsAndPrivacyViewController else {return}
            destVC.receivedTitle = "Play List Info"
        }
    }

    func favoriteBtnSelected(cell: UITableViewCell) {
        let indexPathClickedOn = affirmationTableView.indexPath(for: cell)
        if recievedCategory != "Favorites" {
            if favoritesArray.count != 0 {
                print("Favorites is not equal to 0")
                //Check to see if the Affirmation is already in the Favorites Array
                var favoriteMatch: Bool = false
                var removeAtIndex: Int?
                for (index, favs) in favoritesArray.enumerated() {

                    if favs.id == affirmationsArray[indexPathClickedOn![1]].affirmationID {
                        favoriteMatch = true
                        removeAtIndex = index
                        break
                    } else {
                        print("NO Match")
                    }

                }

                if favoriteMatch == true {
                    /*If safeFavoriteMatch is true
                     - then there is already a favorite, and you don't want to add another
                     - but should instead delete it */
                    affirmationsArray[indexPathClickedOn![1]].favorite = false

                    if let safeRemoveAtIndex = removeAtIndex {
                        context?.delete(favoritesArray[safeRemoveAtIndex])
                        favoritesArray.remove(at: safeRemoveAtIndex)
                        saveFavoriteAffirmationsToCD()
                    }
                } else {
                    //if safeFavoriteMatch is false - then there is no favorite and we need to add it to the list
                    if let safeIndexPathClickedOn = indexPathClickedOn {
                        addAffirmationToFavorites(indexPath: safeIndexPathClickedOn)
                    }
                }
            } else {
                //if there is nothing in the Favorites array, then this affirmation is a new entry and should be added
                if let safeIndexPathClickedOn = indexPathClickedOn {
                    addAffirmationToFavorites(indexPath: safeIndexPathClickedOn)
                }
            }
        } else {
            //This is in when you are in the Favorites selection
            if favoritesArray.count != 0 {
                context?.delete(favoritesArray[indexPathClickedOn![1]])
                favoritesArray.remove(at: indexPathClickedOn![1])
                saveFavoriteAffirmationsToCD()
            }
        }
        affirmationTableView.reloadData()
    }

    fileprivate func addAffirmationToFavorites(indexPath: IndexPath) {
        guard let context = context else {return}
        let favoriteAffirmation = FavoriteAffirmations(context: context)

        favoriteAffirmation.id = affirmationsArray[indexPath[1]].affirmationID
        favoriteAffirmation.title = affirmationsArray[indexPath[1]].title
        favoriteAffirmation.audio = affirmationsArray[indexPath[1]].audio
        favoriteAffirmation.time = affirmationsArray[indexPath[1]].time
        saveFavoriteAffirmationsToCD()
        favoritesArray.append(favoriteAffirmation)
    }
}

extension AffirmationsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "CustomAffirmationsCell"
        guard let cell = tableView
                .dequeueReusableCell(withIdentifier: cellString, for: indexPath) as? CustomAffirmationsCell else {
            return UITableViewCell()
        }

        //Set the cell delegate
        cell.delegate = self

        if recievedCategory != "Favorites"{
            //Set whether the cell is a Favorite
            for favs in favoritesArray where favs.id == affirmationsArray[indexPath.row].affirmationID {
                affirmationsArray[indexPath.row].favorite = true
            }

            if affirmationsArray[indexPath.row].favorite == true {
                cell.favoriteBtnDisplay.image = UIImage(systemName: "circle.fill")
            } else {
                cell.favoriteBtnDisplay.image = UIImage(systemName: "circle")
            }

            //Set the title of the track and time
            cell.affirmationsDescription.text = affirmationsArray[indexPath.row].title
            cell.audioTimeDisplay.text = affirmationsArray[indexPath.row].time
        } else {
            //this is specifically for Favorites
            cell.favoriteBtnDisplay.image = UIImage(systemName: "circle.fill")

            //Set the title of the track and time
            cell.affirmationsDescription.text = favoritesArray[indexPath.row].title
            cell.audioTimeDisplay.text = favoritesArray[indexPath.row].time
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Check if use is paying
        if true {
            if recievedCategory != "Favorites"{
                return affirmationsArray.count
            } else {
                return favoritesArray.count
            }
        }
        //        else {
        //            //Only return 2 if user is not paying
        //            return 5
        //        }
    }

    //Set up the Cells to be buttons to retrieve the modal
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //This will need further development once in app purchasing is set up
        //Check Payment
        if indexPath.row > 10 {
            performSegue(withIdentifier: "affirmationPlayListToIAP", sender: self)
        } else {
            performSegue(withIdentifier: "toAudioPlayer", sender: self)
        }
    }
}
