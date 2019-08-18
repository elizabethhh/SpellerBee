//
//  GameViewController.swift
//  SpellerBee
//
//  Created by Apple on 8/14/18.
//  Copyright © 2018 KodeWithKlossy. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

func scrubInput(_ input: String) -> String{
    return input.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
}

func checkWord(_ input: String, _ word: String) ->Bool{
    return scrubInput(input) == word
}


class GameViewController: UIViewController {
    
    
    var spellingBee = Speller()
    var coin = Int()


    
    @IBAction func homeButton(_ sender: Any) {
         
    }
    @IBOutlet weak var statusLabel: UILabel!
    
    func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"SpellCD")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as![NSManagedObject] {
                coin = data.value(forKey : "coins") as! Int
                
            }
        } catch {
            print("failed")
        }
        
        
        
        
    }
    override func viewDidLoad() {
        getData()
        coinsLabel.text = "Drops of Honey: \(coin)"
        statusLabel.isHidden = true
        input.isHidden = true
        soundButtonShow.isHidden = true
        doneButtonShow.isHidden = true
        super.viewDidLoad()
        input.autocorrectionType = .no
     
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var coinsLabel: UILabel!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  var words: [String] = ["map", "hat", "home", "bone", "poke", "knee", "toothbrush", "wrong", "again", "clean"]
    var counter = 0
    
    var audioFile : [String] = ["map--_us_1.mp3", "hat--_us_1.mp3", "home--_us_1.mp3", "bone.mp3", "poke--_us_1.mp3", "knee--_us_1.mp3", "toothbrush--_us_1.mp3", "wrong--_us_1.mp3", "again--_us_3.mp3", "clean--_us_1.mp3"]
    var player : AVAudioPlayer = AVAudioPlayer()
    var level : [String] = []
    var levelAudio : [String] = []
    
    var wordstwo : [String] = ["bird","cake","city","egg","funny","gold","grade","hope","lake","live"]
    var wordsthree : [String] = ["orange","rabbit","receive","sandwich","school","snow","stop","summer","three","tree"]
    var levelTwoAudio : [String] = ["bird--_us_1.mp3", "cake--_us_1.mp3", "city--_us_1.mp3", "egg--_us_1.mp3", "funny--_us_1.mp3", "gold--_us_1.mp3", "grade--_us_1.mp3", "hope--_us_1.mp3", "lake--_us_1.mp3", "live--_us_1.mp3"]
    var levelThreeAudio : [String] = ["orange--_us_1_rr.mp3", "rabbit--_us_1.mp3", "receive--_us_1.mp3", "sandwich--_us_1.mp3", "school--_us_1.mp3", "snow--_us_1.mp3", "stop--_us_1.mp3", "summer--_us_1.mp3", "three--_us_1.mp3", "tree--_us_1.mp3"]

    @IBOutlet weak var input: UITextField!
    
    
    
    @IBOutlet weak var soundButtonShow: UIButton!
    
    
    @IBOutlet weak var doneButtonShow: UIButton!
    
    @IBOutlet weak var levelOneShow: UIButton!
    
    @IBOutlet weak var levelThreeShow: UIButton!
    @IBOutlet weak var levelTwoShow: UIButton!
    @IBAction func levelOne(_ sender: Any) {
        level = words
        levelAudio = audioFile
        
        statusLabel.isHidden = false
        input.isHidden = false
        soundButtonShow.isHidden = false
        doneButtonShow.isHidden = false
        levelTwoShow.isHidden = true
        levelThreeShow.isHidden = true
        
        
    }
    
    
    @IBAction func levelTwo(_ sender: Any) {
        level = wordstwo
        levelAudio = levelTwoAudio
        statusLabel.isHidden = false
        input.isHidden = false
        soundButtonShow.isHidden = false
        doneButtonShow.isHidden = false
        levelOneShow.isHidden = true
        levelThreeShow.isHidden = true
        
        
    }
    
    
    
    @IBAction func levelThree(_ sender: Any) {
        level = wordsthree
        levelAudio = levelThreeAudio
        statusLabel.isHidden = false
        input.isHidden = false
        soundButtonShow.isHidden = false
        doneButtonShow.isHidden = false
        levelOneShow.isHidden = true
        levelTwoShow.isHidden = true
        
    }
    
    
    
    
    @IBAction func checkWord(_ sender: Any) {

        if counter > 9{
            performSegue(withIdentifier: "endGame", sender: nil)
            
        }
        else{
            if SpellerBee.checkWord(input.text!, level[counter]){
                statusLabel.text = "Correct! \(counter + 1)/10 correct."
                coin+=5
                coinsLabel.text = "Drops of Honey: \(coin)"
                counter += 1
                input.text = ""
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "SpellCD",in: context)
                let newEntity = NSManagedObject(entity: entity!, insertInto: context)
                newEntity.setValue(coin, forKey: "coins")
                
                do {
                    try context.save()
                    print("saved")
                } catch {
                    print("failed saving")
                }
            }
            else{
                statusLabel.text = "Try Again!"
            }
//        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
//            let speller = SpellCD(entity: SpellCD.entity(), insertInto: context)
            
            
            
           
            }
        
        }
        
    
    
   @IBAction func soundButton(_ sender: Any) {
    do {
        let audioPlayer = Bundle.main.path(forResource: levelAudio[counter], ofType: nil)
        try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPlayer!) as URL)
        player.prepareToPlay()
        player.play()
    }
    catch {
        print("fail to play")
    }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if let storeView = segue.destination as? StoreViewController {
//            if let coins = sender as SpellCD? {
//                storeView.selectedCoin = Int(coins)
//                storeView.gameView = self
//            }
//        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


    
}

