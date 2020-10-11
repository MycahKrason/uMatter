//
//  MoodJournalSelectionViewController.swift
//  iMatter
//
//  Created by Mycah on 2/17/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import UIKit
import Firebase

class MoodJournalSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var loginBtnDisplay: UIButton!
    @IBOutlet weak var addJournalEntryDisplay: UIButton!
    @IBOutlet weak var journalListTable: UITableView!

    var journalEntryArray = [JournalEntryData]()
    let firestoreDB = Firestore.firestore()
    var infoButton: InfoButtonView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "IMG_1057 copy"), for: .default)
        title = "Mood Journal"

        infoButton = InfoButtonView(vcView: self, segueIdentifier: "moodJournalToInfo")
        if let infoBtn = infoButton {
            infoBtn.addInfoButton()
        }

        //Set up buttons
        loginBtnDisplay.layer.cornerRadius = 10
        addJournalEntryDisplay.layer.cornerRadius = 10

        //Set Table Delegates
        journalListTable.delegate = self
        journalListTable.dataSource = self

        //Set up cell
        journalListTable.register(UINib(nibName: "JournalEntryCell", bundle: nil),
                                  forCellReuseIdentifier: "JournalEntryCell")

        journalListTable.rowHeight = UITableView.automaticDimension
        journalListTable.estimatedRowHeight = 50

        //Check if the user is logged in or not
        if Auth.auth().currentUser == nil {
            //Set title and color for login btn
            loginBtnDisplay.setTitle("Login", for: .normal)
            loginBtnDisplay.setTitleColor(.white, for: .normal)

            //Set color for Entry button
            addJournalEntryDisplay.setTitleColor(.lightGray, for: .normal)
            print("You are not logged in")
        } else {
            loginBtnDisplay.setTitle("Logout", for: .normal)
            loginBtnDisplay.setTitleColor(.lightGray, for: .normal)
            print("You are already logged in")

            //Set color for Entry button
            addJournalEntryDisplay.setTitleColor(.white, for: .normal)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        //Check if the user is logged in or not
        if Auth.auth().currentUser == nil {
            loginBtnDisplay.setTitle("Login", for: .normal)
            loginBtnDisplay.setTitleColor(.white, for: .normal)
            print("You are not logged in")

            //Set color for Entry button
            addJournalEntryDisplay.setTitleColor(.lightGray, for: .normal)
        } else {
            loginBtnDisplay.setTitle("Logout", for: .normal)
            loginBtnDisplay.setTitleColor(.lightGray, for: .normal)
            print("You are already logged in")

            //Set color for Entry button
            addJournalEntryDisplay.setTitleColor(.white, for: .normal)
        }
        retrieveJournalEntrie()
    }

    fileprivate func retrieveJournalEntrie() {
        journalEntryArray = []
        //grab the user
        if let userId = Auth.auth().currentUser?.uid {
            firestoreDB
                .collection("Users")
                .document(userId)
                .collection("JournalEntries")
                .order(by: "sortTime", descending: true)
                .getDocuments { (querySnapshot, err) in
                    if let retrievalError = err {
                        print("There was an issue downloading: \(retrievalError)")
                    } else {
                        //Check for the snapshot
                        if let snapDoc = querySnapshot?.documents {
                            //iterate over the snapshot and append the journal data to the array
                            for doc in snapDoc {
                                let docDict = doc.data()

                                var entry = ""
                                if let docEntry = docDict["entry"] as? String {
                                    entry = docEntry
                                } else if let encryptedDocEntry = docDict["JournalEntry"] as? String {
                                    entry = self.decryptMessage(encryptedDocEntry)
                                }

                                if let mood = docDict["mood"] as? String,
                                   let date = docDict["date"] as? String {
                                    //Create the Journal Entry Object
                                    let journalData = JournalEntryData(date: date,
                                                                       mood: mood,
                                                                       entry: entry,
                                                                       entryKey: doc.documentID)
                                    self.journalEntryArray.append(journalData)
                                }
                            }
                            self.journalListTable.reloadData()
                        }
                    }
                }
        }
    }

    func decryptMessage(_ messageToDecrypt: String) -> String {
        var decryptedString = ""
        do {
            print("Message to Decrypt: \(messageToDecrypt)")
            let aes = try AES()
            if let dataReturnedFromServer = Data(base64Encoded: messageToDecrypt) {
                decryptedString = try aes.decrypt(dataReturnedFromServer)
            }
        } catch {
            print("Something went wrong: \(error)")
        }
        return decryptedString
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moodJournalToInfo"{
            guard let destVC = segue.destination as? TermsAndPrivacyViewController else {return}
            destVC.receivedTitle = "Mood Journal"
        }
    }

    // MARK: Tables
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journalEntryArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellString = "JournalEntryCell"
        guard let cell = journalListTable
                .dequeueReusableCell(withIdentifier: cellString, for: indexPath) as? JournalEntryCell else {
            return UITableViewCell()
        }

        cell.entryDateDisplay.text = journalEntryArray[indexPath.row].date
        cell.enteredMoodDisplay.image = UIImage(named: journalEntryArray[indexPath.row].mood)
        cell.entryContentDisplay.text = journalEntryArray[indexPath.row].entry
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //show alert
        let alertController = UIAlertController(title: nil,
                                                message: "Would you like to Delete this entry?",
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Cancel",
                                                style: UIAlertAction.Style.default,
                                                handler: nil))
        alertController.addAction(UIAlertAction(title: "Delete",
                                                style: UIAlertAction.Style.default) { _ -> Void in
            //Delete the journal entry
            print(self.journalEntryArray[indexPath.row].entryKey)

            let idToDelete = self.journalEntryArray[indexPath.row].entryKey
            self.firestoreDB
                .collection("Users")
                .document(Auth.auth().currentUser!.uid)
                .collection("JournalEntries")
                .document(idToDelete).delete()

            self.journalEntryArray.remove(at: indexPath.row)
            self.journalListTable.reloadData()
        })
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func addJournalEntry(_ sender: Any) {
        //Check to make sure that the user is logged in - if they aren't, show a message
        if Auth.auth().currentUser == nil {
            print("user needs to be logged in to add an entry")
            //show alert
            let alertController = UIAlertController(title: nil,
                                                    message: "You must login to add an Entry.",
                                                    preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss",
                                                    style: UIAlertAction.Style.default,
                                                    handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "entryBtnToJournalForm", sender: self)
        }
    }

    // MARK: Buttons
    @IBAction func loginLogoutBtnPressed(_ sender: Any) {
        //To login
        if Auth.auth().currentUser == nil {
            performSegue(withIdentifier: "moodJournalToSignIn", sender: self)
        } else {
            //show alert
            let alertController = UIAlertController(title: nil,
                                                    message: "Are you sure you want to Logout?",
                                                    preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Cancel",
                                                    style: UIAlertAction.Style.default,
                                                    handler: nil))
            alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { _ -> Void in
                //Logout the user
                print("you are tryinig to logout")
                //Clear the array
                self.journalEntryArray = []
                self.journalListTable.reloadData()

                do {
                    try Auth.auth().signOut()
                    self.loginBtnDisplay.setTitle("Login", for: .normal)
                    self.loginBtnDisplay.setTitleColor(.white, for: .normal)

                    //Set color for Entry button
                    self.addJournalEntryDisplay.setTitleColor(.lightGray, for: .normal)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            })
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
