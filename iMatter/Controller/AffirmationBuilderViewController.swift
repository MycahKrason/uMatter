//
//  AffirmationBuilderViewController.swift
//  iMatter
//
//  Created by Mycah on 11/23/19.
//  Copyright © 2019 Mycah Krason. All rights reserved.
//

import UIKit
import CoreData

class AffirmationBuilderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var affirmationCategorySegmentDisplay: UISegmentedControl!
    @IBOutlet weak var trackListTable: UITableView!
    @IBOutlet weak var buildBtnDisplay: UIButton!
    @IBOutlet weak var clearBtnDisplay: UIButton!
    @IBOutlet weak var segmentDisplay: UISegmentedControl!
    @IBOutlet weak var ambientPickerDisplay: UIPickerView!
    
    private var trackList : [AffirmationData] = [AffirmationData]()
    private var selectedTrackList : [SelectedAffirmation] = [SelectedAffirmation]()
    private var chosenAffirmationCategory = "builder_positivity"
    
    private var chosenAmbience : String = ""
    
    private var ambientMusicArray : [String] = ["Summer", "Better Days", "Creative Minds", "Acoustic Breeze"]
    private var ambientNatureArray : [String] = ["Forest", "Ocean", "Rain", "Fireplace"]
    
    //Context for Core Data
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentDisplay.selectedSegmentIndex = 0
        
        trackListTable.delegate = self
        trackListTable.dataSource = self
        ambientPickerDisplay.delegate = self
        ambientPickerDisplay.dataSource = self
        
        //Set up the display
        trackListTable.rowHeight = 70
        buildBtnDisplay.layer.cornerRadius = 10
        clearBtnDisplay.layer.cornerRadius = 10
        ambientPickerDisplay.layer.cornerRadius = 10
        
        //Set Font colors of Segments
        let selectedSegmentAttribute = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentDisplay.setTitleTextAttributes(selectedSegmentAttribute, for: .selected)
        affirmationCategorySegmentDisplay.setTitleTextAttributes(selectedSegmentAttribute, for: .selected)
        let normalSegmentAttribute = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        segmentDisplay.setTitleTextAttributes(normalSegmentAttribute, for: .normal)
        affirmationCategorySegmentDisplay.setTitleTextAttributes(normalSegmentAttribute, for: .normal)
        
        trackListTable.register(UINib(nibName: "CustomTrackCell", bundle: nil), forCellReuseIdentifier: "CustomTrackCell")
        
        //Based on the Recieved Category - I will grab differenct Affirmations
        RetrieveAffirmations().getAffirmations(apiPath: chosenAffirmationCategory, completion: { error, result in
            
            print("\(result) - This is what is returned")
            
            
            self.trackList = result
            DispatchQueue.main.async {
                self.trackListTable.reloadData()
            }
            
        })
        
        loadSelectedAffirmationsFromCD()
        
        chosenAmbience = "Summer"
        ambientPickerDisplay.selectRow(0, inComponent: 0, animated: false)
        //Set a color on the selected choice
        guard let label = ambientPickerDisplay.view(forRow: 0, forComponent: 0) as? UILabel else {
            return
        }
        label.backgroundColor = .darkGray
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated);
    }
    
    //Save to Core Data
    fileprivate func saveSelectedAffirmationsToCD(){
        do {
            try context.save()
        } catch  {
            print("Error Saving Coontent to Core Data")
        }
    }
    
    //Load from Core Data
    fileprivate func loadSelectedAffirmationsFromCD(){
        let request : NSFetchRequest<SelectedAffirmation> = SelectedAffirmation.fetchRequest()
        
        do {
            selectedTrackList = try context.fetch(request)
        } catch  {
            print("Unable to Load Saved Favorite Artists - \(error)")
        }
        
    }
    
    
    //************//
    //MARK: Picker//
    //************//
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        //Check the segment selection to determine which array to use
        // 0 = Music
        // 1 = Nature
        // 2 = None
        if segmentDisplay.selectedSegmentIndex == 0{
            return ambientMusicArray.count
        }else if segmentDisplay.selectedSegmentIndex == 1{
            return ambientNatureArray.count
        }else{
            return 1
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var titleData = ""
        
        if segmentDisplay.selectedSegmentIndex == 0{
            titleData = ambientMusicArray[row]
        }else if segmentDisplay.selectedSegmentIndex == 1{
            titleData = ambientNatureArray[row]
        }else{
            titleData = "None"
        }
        
        
        let pickerLabel = UILabel()
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font:UIFont(name: "Avenir Next", size: 26.0)!,NSAttributedString.Key.foregroundColor:UIColor.white])
        pickerLabel.attributedText = myTitle
        
        pickerLabel.textAlignment = .center
        
        
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        //TODO:This will set the Ambience to be played
        chosenAmbience = ambientMusicArray[row]
        
        if segmentDisplay.selectedSegmentIndex == 0{
            chosenAmbience = ambientMusicArray[row]
        }else if segmentDisplay.selectedSegmentIndex == 1{
            chosenAmbience = ambientNatureArray[row]
        }else{
            chosenAmbience = "None"
        }
        
        //Set a color on the selected choice
        guard let label = ambientPickerDisplay.view(forRow: row, forComponent: component) as? UILabel else {
            return
        }
        label.backgroundColor = .darkGray
        
        
    }
    
    //************//
    //MARK: Tables//
    //************//
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = trackListTable.dequeueReusableCell(withIdentifier: "CustomTrackCell", for: indexPath) as! CustomTrackCell
        
        cell.trackLabel.text = trackList[indexPath.row].title
        
        //To find the tracks number - find the index of the track in the selectedTrack array based on the ID number
        let index = selectedTrackList.firstIndex(where: {$0.id == trackList[indexPath.row].id})
        
        
        if let trackIndex = index{
            cell.trackNumberDisplay.text = "\(trackIndex + 1)"
        }else{
            cell.trackNumberDisplay.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return trackList.count
        
    }
    
    //Set up the Cells to be buttons
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        //Check Payment
        if indexPath.row > 200{
            
            performSegue(withIdentifier: "affirmationTracksToIAP", sender: self)
            
        }else{
        
            //Check if the track has already been added - if not, then add the track
            if !selectedTrackList.contains(where: { $0.id == trackList[indexPath.row].id}){
                
                //Add track
                addAffirmationToSelected(indexPath: indexPath)
            }else{
                
                //Remove track
                let index = selectedTrackList.firstIndex(where: {$0.id == trackList[indexPath.row].id})
                
                if let removeIndex = index{
                    
                    context.delete(selectedTrackList[removeIndex])
                    selectedTrackList.remove(at: removeIndex)
                    saveSelectedAffirmationsToCD()
                    
                }
                
            }
            
            trackListTable.reloadData()
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCustomAffirmationPlayer"{

            let destVC = segue.destination as! CustomAffirmationPlayerViewController

            destVC.receivedArray = selectedTrackList
            destVC.receivedAmbience = chosenAmbience

        }else if segue.identifier == "affirmationBuilderToInfo"{
            
            let destVC = segue.destination as! TermsAndPrivacyViewController
            destVC.receivedTitle = "Builder Info"
            
        }
    }
    
    func addAffirmationToSelected(indexPath: IndexPath){
                
        let chosenAffirmation = SelectedAffirmation(context: context)
        
        chosenAffirmation.id = trackList[indexPath[1]].id
        chosenAffirmation.title = trackList[indexPath[1]].title
        chosenAffirmation.audio = trackList[indexPath[1]].audio
        
        saveSelectedAffirmationsToCD()
        selectedTrackList.append(chosenAffirmation)
    }
    
    @IBAction func affirmationCategorySegmentChanged(_ sender: Any) {
        
        //Check which segment is chosen an use that information to decide the chosenAffirmationCategory
        if affirmationCategorySegmentDisplay.selectedSegmentIndex == 0{
            chosenAffirmationCategory = "builder_positivity"
        }else if affirmationCategorySegmentDisplay.selectedSegmentIndex == 1{
            chosenAffirmationCategory = "builder_motivation"
        }else if affirmationCategorySegmentDisplay.selectedSegmentIndex == 2{
            chosenAffirmationCategory = "builder_anxiety"
        }else if affirmationCategorySegmentDisplay.selectedSegmentIndex == 3{
            chosenAffirmationCategory = "builder_confidence"
        }
        
        //Based on the Recieved Category - I will grab differenct Affirmations
        RetrieveAffirmations().getAffirmations(apiPath: chosenAffirmationCategory, completion: { error, result in
            
            print("\(result) - This is what is returned")
            
            
            self.trackList = result
            DispatchQueue.main.async {
                self.trackListTable.reloadData()
                
            }
            
        })
        
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        
        ambientPickerDisplay.reloadAllComponents();
        
        if segmentDisplay.selectedSegmentIndex == 0{
            chosenAmbience = "Summer"
        }else if segmentDisplay.selectedSegmentIndex == 1{
            chosenAmbience = "Forest"
        }else{
            chosenAmbience = ""
        }
        
        ambientPickerDisplay.selectRow(0, inComponent: 0, animated: false)
        //Set a color on the selected choice
        guard let label = ambientPickerDisplay.view(forRow: 0, forComponent: 0) as? UILabel else {
            return
        }
        label.backgroundColor = .darkGray
        
    }
    @IBAction func buildBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "toCustomAffirmationPlayer", sender: sender)
        
        //TODO - save users selected Ambience
        //TODO - Add Replay somewhere in the App
    }
    
    @IBAction func clearBtnPressed(_ sender: Any) {
        
            //create alert for to make sure user is sure
        let alertController = UIAlertController(title: nil, message:"Are you sure you want to clear your chosen Affirmations?", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction) in
              
            for selected in self.selectedTrackList{
                self.context.delete(selected)
            }
            
            self.saveSelectedAffirmationsToCD()
            
            self.selectedTrackList = []
            self.trackListTable.reloadData()
                
        }))
            
        self.present(alertController, animated: true, completion: nil)
       
    }
    
    @IBAction func infoBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "affirmationBuilderToInfo", sender: self)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
