//
//  LaunchVC.swift
//  famouschat
//
//  Created by Oni Angel on 04/11/2018.
//  Copyright © 2018 Oni Angel. All rights reserved.
//

import UIKit

class LaunchVC: UIViewController {

    @IBOutlet weak var video_view: VideoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true       
      
        video_view.configure(url: "lunch_video", local_or_sever: true)
        video_view.isLoop = true
        video_view.play()
        
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when){
            
            self.video_view.stop()
           
            self.navigationController?.pushViewController(LoginVC(), animated: true)
        }
    }

}
