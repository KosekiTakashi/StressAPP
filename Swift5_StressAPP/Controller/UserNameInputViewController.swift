//
//  UserNameInputViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/12/12.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import Firebase
import TextFieldEffects

class UserNameInputViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var userNameTextField: KaedeTextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageView.layer.cornerRadius = logoImageView.frame.height / 2

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func test(_ sender: UITapGestureRecognizer) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        showAlert()
    }
    
    
    @IBAction func done(_ sender: Any) {
        //dataを保存
        
        UserDefaults.standard.set(userNameTextField.text!, forKey: "userName\(UserData.userID)")
        
        let data = logoImageView.image?.jpegData(compressionQuality: 0.1)
        if let data = data{
            DispatchQueue.main.async {
                let imageURL = self.imagefetch(userImageData: data)
                print("imageURL-------------------")
                print(imageURL)
            }
        }
        UserDefaults.standard.set(data, forKey: "userImage\(UserData.userID)")
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        
        if userNameTextField.text != nil{
            changeRequest?.displayName = userNameTextField.text
            changeRequest?.commitChanges(completion: { (error) in
                print(error as Any)
                return
            })
        }
        
        
        self.performSegue(withIdentifier: "tab", sender: nil)
        
    }
    
    func imagefetch(userImageData: Data) -> String{
        
        let timeLineDB = Database.database().reference().child("timeLines").childByAutoId()
        let storageRef = Storage.storage().reference()
        let key = timeLineDB.child("Users").childByAutoId().key
        let riversRef = storageRef.child("userImage").child("userlogo").child("\(String(describing: key!)).jpg")
    
        
        var urlString = ""
        
        let uploadTask = riversRef.putData(userImageData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                return
            }
            let size = metadata.size
            print(size)
              
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url
                    else {
                        print(error as Any)
                        return
                    }
                
                let imageURL = downloadURL.absoluteString
                DispatchQueue.main.async {
                    urlString = imageURL
                }
                
            }
        }
        
        uploadTask.resume()
        if urlString != ""{
            return urlString
        }
        
        return urlString
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    
}


//MARK: - Selected image
extension UserNameInputViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    //camera立ち上げ
    func docamera(){
        
        let sourceType:UIImagePickerController
            .SourceType = .camera
        
        //許可があるか
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    
    func doAlubum(){
        
        let sourceType:UIImagePickerController
            .SourceType = .photoLibrary
        
        //許可があるか
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        
        }
        
    }
    
    //選んだ画像が入ってくる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //あるなら保存(０．１倍)
        if info[.originalImage] as? UIImage != nil{
            let selectedImage = info[.originalImage] as! UIImage
            
            UserDefaults.standard.set(selectedImage.jpegData(compressionQuality: 0.1), forKey: "userImage")
            //投影
            logoImageView.image = selectedImage
            //pickerを閉じる
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    //キャンセルを押された場合
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //アラートを出す
    func showAlert(){
        
        let aleartController = UIAlertController(title: "選択してください", message: "どれにしますか？", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Camera", style: .default) { (alert) in
            
            self.docamera()
        }
        
        let action2 = UIAlertAction(title: "Album", style: .default) { (alert) in
            self.doAlubum()
        }
        
        let action3 = UIAlertAction(title: "Cancel", style:.cancel)
    
        
        aleartController.addAction(action1)
        aleartController.addAction(action2)
        aleartController.addAction(action3)
        self.present(aleartController, animated: true, completion: nil)
        
    }
    
}
