//
//  AudioRecorder.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 06/10/2022.
//

import Foundation
import AVFoundation

class AudioRecorder: NSObject, AVAudioRecorderDelegate{
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var isAudioRecordingGrented: Bool!
    
    static let shared = AudioRecorder()
    
    private override init(){
        super.init()
        checkForRecordPermisssion()
    }
    
    func checkForRecordPermisssion(){
        switch AVAudioSession.sharedInstance().recordPermission{
        case .granted:
            isAudioRecordingGrented = true
            break
        case .denied:
            isAudioRecordingGrented = false
            break
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { isAllowed in
                self.isAudioRecordingGrented = isAllowed
            }
        default:
            break
        }
    }
    
    func setupRecorder(){
        if isAudioRecordingGrented{
            recordingSession = AVAudioSession.sharedInstance()
            do {
                try recordingSession.setCategory(.playAndRecord, mode: .default)
                try recordingSession.setActive(true)
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func startRecording(fileName: String){
        let audioFileName = FileDocumentManager.shared.getDocumentURL().appendingPathComponent(fileName + ".m4a", isDirectory: false)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do{
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        }catch{
            print(error.localizedDescription)
            finishRecording()
        }
    }
    
    func finishRecording(){
        if audioRecorder != nil{
            audioRecorder.stop()
            audioRecorder = nil
        }
    }
    
}
