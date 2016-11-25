//
//  ViewController.swift
//  testVideo
//
//  Created by 小野山　隆 on 2016/11/16.
//  Copyright © 2016年 Takashi Onoyama. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary

class ViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    @IBOutlet weak var myLabel: UILabel!
    // セッションの作成.
    var mySession = AVCaptureSession()


    // ビデオのアウトプット.
    var myVideoOutput: AVCaptureMovieFileOutput!
    
    // スタートボタン.
     var myButtonStart: UIButton!
    
    // ストップボタン.
     var myButtonStop: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // デバイス.
        var myDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        // 出力先を生成.
        let myImageOutput = AVCaptureStillImageOutput()
        
        // デバイス一覧の取得.
        let devices = AVCaptureDevice.devices()
        
        // マイクを取得.
        let audioCaptureDevice = AVCaptureDevice.devices(withMediaType: AVMediaTypeAudio)
        
        // マイクをセッションのInputに追加.
        let audioInput = try! AVCaptureDeviceInput.init(device: audioCaptureDevice?.first as! AVCaptureDevice)
        
        // バックライトをmyDeviceに格納.
        for device in devices! {
            if((device as AnyObject).position == AVCaptureDevicePosition.back){
                myDevice = device as? AVCaptureDevice
            }
        }
        
        // バックカメラを取得.
        let videoInput = try! AVCaptureDeviceInput.init(device: myDevice)
        
        // ビデオをセッションのInputに追加.
        mySession.addInput(videoInput)
        
        // オーディオをセッションに追加.
        mySession.addInput(audioInput)
        
        // セッションに追加.
        mySession.addOutput(myImageOutput)
        
        // 動画の保存.
        myVideoOutput = AVCaptureMovieFileOutput()
        
        // ビデオ出力をOutputに追加.
        mySession.addOutput(myVideoOutput)
        
        // 画像を表示するレイヤーを生成.
        let myVideoLayer = AVCaptureVideoPreviewLayer.init(session: mySession)
        myVideoLayer?.frame = self.view.bounds
        myVideoLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        // Viewに追加.
        self.view.layer.addSublayer(myVideoLayer!)
        
        // セッション開始.
        mySession.startRunning()
        
        // UIボタンを作成.
        myButtonStart = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
        myButtonStop = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
        
        myButtonStart.backgroundColor = UIColor.red
        myButtonStop.backgroundColor = UIColor.gray
        
        myButtonStart.layer.masksToBounds = true
        myButtonStop.layer.masksToBounds = true
        
        myButtonStart.setTitle("撮影", for: .normal)
        myButtonStop.setTitle("停止", for: .normal)
        
        myButtonStart.layer.cornerRadius = 20.0
        myButtonStop.layer.cornerRadius = 20.0
        
        myButtonStart.layer.position = CGPoint(x: self.view.bounds.width/2 - 70, y:self.view.bounds.height-50)
        myButtonStop.layer.position = CGPoint(x: self.view.bounds.width/2 + 70, y:self.view.bounds.height-50)
        
        myButtonStart.addTarget(self, action: #selector(ViewController.onClickMyButton), for: .touchUpInside)
        myButtonStop.addTarget(self, action: #selector(ViewController.onClickMyButton), for: .touchUpInside)
        
        // UIボタンをViewに追加.
        self.view.addSubview(myButtonStart)
        self.view.addSubview(myButtonStop)
    }
    
    /*
     ボタンイベント.
     */
    internal func onClickMyButton(sender: UIButton){
        
        // 撮影開始.
        // フォルダ.
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        
        // ファイル名.
        let filePath = "\(documentsDirectory)/test.mp4"
        
        // URL.
        let fileURL = URL(fileURLWithPath: filePath)

        
        if( sender == myButtonStart ){
            
            
            
            // 録画開始.
            myVideoOutput.startRecording(toOutputFileURL: fileURL, recordingDelegate: self)
            
        }
            // 撮影停止.
        else if ( sender == myButtonStop ){
            myVideoOutput.stopRecording()
            mySession.stopRunning()
            UISaveVideoAtPathToSavedPhotosAlbum(filePath, self, #selector(ViewController.video(_:didFinishSavingWithError:contextInfo:)), nil)
                    }
    }
    
    
    func video(videoPath: String, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutablePointer<Void>) {
        if (error != nil) {
            print("video saving fails")
            myLabel.text = "video saving fails"
        } else {
            print("video saving success")
            myLabel.text = "video saving success"
        }
    }

    
//    @IBAction func tapStop(_ sender: AnyObject) {
//        fileOutput.stopRecording()
//        session.stopRunning()
//        UISaveVideoAtPathToSavedPhotosAlbum(filePath, self, #selector(ViewController.video(_:didFinishSavingWithError:contextInfo:)), nil)
//    }
 
    // MARK: - AVCaptureFileOutputRecordingDelegate
    
    /*
     動画がキャプチャーされた後に呼ばれるメソッド.
     */
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {

    }
}
    
    

