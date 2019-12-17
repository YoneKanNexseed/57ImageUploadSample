//
//  SecondViewController.swift
//  ImageUploadSample
//
//  Created by yonekan on 2019/12/17.
//  Copyright © 2019 yonekan. All rights reserved.
//

import UIKit
import Firebase

class SecondViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // カメラボタン
    @IBAction func runCamera(_ sender: UIButton) {
    }
    
    // アルバムボタン
    @IBAction func showAlbum(_ sender: UIButton) {
        
        // アルバムの使用が許可されているか確認
        if UIImagePickerController
            .isSourceTypeAvailable(.photoLibrary) {
            
            // アルバムの画面を作成
            let albumVC = UIImagePickerController()
            albumVC.sourceType = .photoLibrary
            albumVC.delegate = self
            
            // 作成したアルバムの画面を表示
            present(albumVC, animated: true, completion: nil)
            
        }
        
        
        
    }
    
    // 投稿ボタン
    @IBAction func post(_ sender: UIButton) {
        
        let db = Firestore.firestore()
        
        // ImageViewで表示されている画像を文字データに変換する
        let data = imageView.image?
            .jpegData(compressionQuality: 0.1)
        
        db.collection("posts").addDocument(data: [
            "text": textField.text!,
            "imageData": data as Any
        ]) {error in
            
            if let err = error {
                print(err.localizedDescription)
            }
            
        }
        
        textField.text = ""
    }
    
}

// カメラ機能が使えるように拡張する
extension SecondViewController:
UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    // 撮影 or アルバム選択が終わった時の処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // 写真が存在する場合、
        if let pickedImage = info[.originalImage] as? UIImage {
            // 画面に写真を表示
            imageView.image = pickedImage
        }

        // アルバムの画面を閉じる
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}
