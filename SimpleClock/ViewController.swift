//
//  ViewController.swift
//  Calculator
//
//  Created by Sidney Teague on 6/12/23
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
	
	@IBOutlet weak var label1: UILabel!
	@IBOutlet weak var label2: UILabel!
	@IBOutlet weak var datePicker: UIDatePicker!
	
	//Show live clock
	var liveClock = Timer()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		liveClock = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
		//to change the background color for AM to PM
		var t = time(nil)
		var tmValue = tm()
		localtime_r(&t, &tmValue)
		let hour = tmValue.tm_hour
		if hour > 12 {
			view.backgroundColor = UIColor.red
		} else {
				view.backgroundColor = UIColor.blue
		}
	}
	//To show the live time for label1
	@objc func tick(){
		label1.text = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
	}
	
	//Button to run timer
	var countdownTime: TimeInterval = 0
	var timer: Timer?
	var endDate: Date?
	
	@IBAction func startTimerButtonTapped(_ sender: UIButton) {
		if timer == nil {
			//start timer
			countdownTime = datePicker.countDownDuration
			startTimer()
			sender.setTitle("Stop Timer", for: .normal)
		} else {
			//stop timer
			stopTimer()
			sender.setTitle("Start Timer", for: .normal)
		}
	}
	
	func startTimer() {
		guard countdownTime > 0 else {
			return
		}
		endDate = Date().addingTimeInterval(countdownTime)
		timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
	}
	func stopTimer() {
		timer?.invalidate()
		timer = nil
		endDate = nil
		updateTimerLabel(with: countdownTime)
	}
	@objc func updateTimer() {
		guard let endDate = endDate else {
			return
		}
		let currentTime = Date()
		let timeRemaining = max(0,endDate.timeIntervalSince(currentTime))
		
		if timeRemaining <= 0 {
			//stop timer
			stopTimer()
			playMusic()
		} else {
			//timer running
			updateTimerLabel(with: timeRemaining)
		}
	}
	func updateTimerLabel(with timeRemaining: TimeInterval)  {
		let formatter = DateComponentsFormatter()
		formatter.unitsStyle = .positional
		formatter.allowedUnits = [.hour, .minute, .second]
		formatter.zeroFormattingBehavior = [.pad]
		
		if let formattedString = formatter.string(from: timeRemaining) {
			label2.text = formattedString
		}
	}
	//playing the music
	var audioPlayer: AVAudioPlayer?
	let musicFileName = "TunePocket-My-Soul-Piano-Audio-Logo-Preview"
	
	func playMusic() {
		guard let musicURL = Bundle.main.url(forResource: musicFileName, withExtension: "mp3") else {
			return
		}
		do {
			audioPlayer = try AVAudioPlayer(contentsOf: musicURL)
			audioPlayer?.play()
		} catch {
			print("Failed to play music: \(error)")
		}
	}
	
}

