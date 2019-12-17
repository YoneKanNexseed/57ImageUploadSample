//
//  ViewController.swift
//  ImageUploadSample
//
//  Created by yonekan on 2019/12/17.
//  Copyright © 2019 yonekan. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // 投稿された全データを持つ配列
    var posts: [Post] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // postsコレクションの監視をする
        let db = Firestore.firestore()
        db.collection("posts").addSnapshotListener
            { (querySnapShot, error) in
            
            guard let docs = querySnapShot?.documents else {
                return
            }
             
                var resutls: [Post] = []
                
                for doc in docs {
                    let text = doc.get("text") as! String
                    let imageData = doc.get("imageData") as! Data
                    
                    let post = Post(text: text, imageData: imageData)
                    resutls.append(post)
                }
                
                self.posts = resutls
        }
        
    }

    @IBAction func didClickButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toNext", sender: nil)
    }
    
}

extension ViewController:
UICollectionViewDataSource,
UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        // 表示対象の投稿を全データの配列から取得
        let post = posts[indexPath.row]
        
        // セルの中のImageViewの設定
        let imageView =
            cell.contentView.viewWithTag(1) as! UIImageView
        imageView.image = UIImage(data: post.imageData)
        
        // セルの中のLabelの設定
        let label = cell.contentView.viewWithTag(2) as! UILabel
        label.text = post.text
        
        return cell
    }
    
}

// セルのレイアウトを調整するための拡張
extension ViewController:
UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 画面の幅を取得
        let screenSize = self.view.bounds.width
        
        // 画面の幅の半分を計算
        let cellSize = screenSize / 2 - 5
        
        // セルのサイズを返す
        return CGSize(width: cellSize, height: cellSize)
        
    }
    
}
