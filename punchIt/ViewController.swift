//
//  ViewController.swift
//  punchIt
//
//  Created by Risul Rashed
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var imageSHow: UIImageView!
    var audioPlayer: AVAudioPlayer!
    var imagePic = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePic.delegate = self
    }

    func someAlert(){
        let someAlert = UIAlertController(title: "Camera", message: "No camera device found", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Ok", style: .default)
        someAlert.addAction(action1)
        present(someAlert, animated: true)
    }
    
    func loadPicAlert(){
        let picUp = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Photos", style: .default) { (_) in
            print("Photo Library Opened")
            self.accessPhotoLibrary()
        }
        let action2 = UIAlertAction(title: "Camera", style: .default) { (_) in
            print("Camera Opened")
            //self.accessCamera()
            self.someAlert()
        }
        let action3 = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            print("You canceled")
        }
        picUp.addAction(action1)
        picUp.addAction(action2)
        picUp.addAction(action3)
        present(picUp, animated: true)
    }
    
    @IBAction func justTapped(_ sender: UITapGestureRecognizer) {
        punchAnimation()
        playAudio()
    }
    @IBAction func picButtonPressed(_ sender: UIButton) {
        loadPicAlert()
    }
    
    func punchAnimation(){
        let original = imageSHow.frame
        let shrinkSize:CGFloat = 30
        let shrink = CGRect(x: imageSHow.frame.origin.x + shrinkSize,
                            y: imageSHow.frame.origin.y + shrinkSize,
                            width: imageSHow.frame.width - 60,
                            height: imageSHow.frame.height - 60)
        
        imageSHow.frame = shrink
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 30, options: [.transitionCurlUp]) {
            self.imageSHow.frame = original
        }

    }
    
    func playAudio(){
        if let sound = NSDataAsset(name: "punchSound"){
            do{
                try audioPlayer = AVAudioPlayer(data: sound.data)
                audioPlayer.play()
            }
            catch{
                print("Sound can't be played")
            }
        }
        else{
            print("Couldn't convert the sound data to 'if let'")
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editI = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            imageSHow.image = editI
            dismiss(animated: true)
        }
        if let originalI = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageSHow.image = originalI
            dismiss(animated: true)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func accessPhotoLibrary(){
        imagePic.sourceType = .photoLibrary
        present(imagePic, animated: true)
    }
    func accessCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePic.sourceType = .camera
            present(imagePic, animated: true)
        }
        else{
            someAlert()
        }
    }
}


