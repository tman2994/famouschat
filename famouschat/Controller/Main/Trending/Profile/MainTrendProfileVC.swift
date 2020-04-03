//
//  MoreProfileVC.swift
//  famouschat
//
//  Created by Oni Angel on 08/11/2018.
//  Copyright © 2018 Oni Angel. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SCLAlertView
import ObjectMapper
import AVKit
import MobileCoreServices
import Alamofire


class MainTrendProfileVC: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var photo_height: NSLayoutConstraint!
    
    @IBOutlet weak var back_img: UIImageView!
    @IBOutlet weak var back_btn: UIButton!
    @IBOutlet weak var menu_img: UIImageView!
    @IBOutlet weak var menu_btn: UIButton!
    @IBOutlet weak var reviewe_frame: UIView!
    
    @IBOutlet weak var profile_frame: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var follwoing_num: UILabel!
    @IBOutlet weak var follower_num: UILabel!
    @IBOutlet weak var rating_num: UILabel!
    @IBOutlet weak var follow_btn: UIButton!
    @IBOutlet weak var msg_frame: UIView!
    @IBOutlet weak var video_btn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var month_collectionView: UICollectionView!
    @IBOutlet weak var day_collectionView: UICollectionView!
    
    @IBOutlet weak var available_frame: UIView!
    @IBOutlet weak var available_collectionView: UICollectionView!
    @IBOutlet weak var duration_frame: UIView!
    @IBOutlet weak var duration_collectionView: UICollectionView!
    @IBOutlet weak var ques_frame: UIView!
    @IBOutlet weak var ques_label: UILabel!
    @IBOutlet weak var ques_in: UITextView!
    @IBOutlet weak var fee_label: UILabel!
    @IBOutlet weak var time_label: UILabel!
    @IBOutlet weak var duration_label: UILabel!
    @IBOutlet weak var book_btn: UIButton!
    @IBOutlet weak var video_frame: UIView!
    @IBOutlet weak var video_msg_title: UILabel!
    @IBOutlet weak var video_bio: UILabel!
    @IBOutlet weak var video_check: UIImageView!
    @IBOutlet weak var video_fee_label: UILabel!
    @IBOutlet weak var video_record_btn: UIButton!
    @IBOutlet weak var video_frame_left: NSLayoutConstraint!
    
    let progressDlg = ShareData.progressDlgs[ShareData.progress_index]
    var coin_buy_status = false
    var month_index = [Bool]()
    var day_index = [Int]()
    var available_index = [Int]()
    var duration_index = [Bool]()
    
    var alert_view: SCLAlertView!
    var alert_status = ""
    
    var book_time = ["2019", "02", "10", "10:00"]
    var duration = "05"
    
    let month_day_cnt_list = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    var month_day_cnt = 28
    
    var fee_rate: Double = 0.0
    
    var available_time_array = [String]()
    let duration_array = ["05", "10", "15", "20", "30", "45", "60"]
    
    var booked_list = ["2019-02-11-10-30", "2019-02-11-14-00", "2019-02-11-15-30", "2019-02-11-16-00", "2019-03-08-10-30", "2019-03-08-13-00", "2019-03-08-14-30"]
    var coin_in: UITextField!
    var video_check_status = false
    var video_uploading_status = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        month_index = Array(repeating: false, count: ShareData.month_short_names.count)
        duration_index = Array(repeating: false, count: duration_array.count)
        
        let array = CommonFuncs().splitString(CommonFuncs().currentTime())
        book_time = [array[0], array[1], array[2], ""]
        month_day_cnt = month_day_cnt_list[Int(array[1])! - 1]
        
        availabeTimeCheck()
        weekDayCheck()
        
        book_time[3] = available_time_array[0]
        
        duration = duration_array[2]
        month_index[Int(array[1])! - 1] = true
        duration_index[2] = true
        
        var formater_0 = DateFormatter()
        formater_0.dateFormat = "yyyy-MM-dd"
        let time_str_0 = formater_0.date(from: "\(book_time[0])-\(book_time[1])-\(book_time[2])")!
        
        let calendar_0 = Calendar.current
        let weekDay_0 = calendar_0.component(.weekday, from: time_str_0) as! Int - 1
        
        let array2 = CommonFuncs().splitString(ShareData.selected_influencer.chat_rate!.characters.split(separator: ",").map(String.init)[weekDay_0])
        fee_rate = (Double(array2[2])! + Double(array2[3])! / 100) / (Double(array2[0])! * 60 + Double(array2[1])!)
        
        booked_list = ShareData.selected_influencer.booked_list ?? [""]
        
        init_UI()
    }
    
    func init_UI()
    {
        self.navigationController?.isNavigationBarHidden = true
        
        let back_image = UIImage.init(named: "back")!.withRenderingMode(.alwaysTemplate)
        back_img.image = back_image
        back_img.tintColor = UIColor.white
        
        let menu_image = UIImage.init(named: "menu")!.withRenderingMode(.alwaysTemplate)
        menu_img.image = menu_image
        menu_img.tintColor = UIColor.white
        
        menu_btn.addTarget(self.slideMenuController, action: #selector(slideMenuController.toggleMenuAnimated(_:)), for: .touchUpInside)
        back_btn.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        
        let data = ShareData.selected_influencer!
        
        photo_height.constant = photo.frame.width * 0.7
        profile_frame.dropShadow(color: .gray, opacity: 0.5, offSet: CGSize.zero, radius: 5, scale: true)
        photo.load(url: data.photo!)
        name.text = data.name!
        
        
        reviewe_frame.layer.cornerRadius = CGFloat(ShareData.btn_radius)
        reviewe_frame.clipsToBounds = true
        
        follow_btn.layer.cornerRadius = CGFloat(ShareData.btn_radius)
        follow_btn.clipsToBounds = true
        follow_btn.dropShadow(color: .gray, opacity: 0.8, offSet: CGSize.zero, radius: 3, scale: true)
        
        video_btn.layer.cornerRadius = CGFloat(ShareData.btn_radius)
        video_btn.clipsToBounds = true
        video_btn.setImage(UIImage.init(named: "video_record")?.withRenderingMode(.alwaysTemplate), for: .normal)
        video_btn.tintColor = UIColor.white
        video_btn.dropShadow(color: .gray, opacity: 0.8, offSet: CGSize.zero, radius: 3, scale: true)
        
        msg_frame.layer.cornerRadius = CGFloat(ShareData.btn_radius)
        msg_frame.clipsToBounds = true
        msg_frame.dropShadow(color: .gray, opacity: 0.8, offSet: CGSize.zero, radius: 3, scale: true)
        
        follower_num.text = data.follow_num!
        follwoing_num.text = data.following_num!
        rating_num.text = String(format: "%.01f", Double(data.rate!)!)
        
        month_collectionView.dataSource = self
        month_collectionView.delegate = self
        month_collectionView.register(UINib(nibName: "OneLabelCell", bundle: nil), forCellWithReuseIdentifier: "OneLabelCell")
        
        day_collectionView.dataSource = self
        day_collectionView.delegate = self
        day_collectionView.register(UINib(nibName: "OneLabelCell", bundle: nil), forCellWithReuseIdentifier: "OneLabelCell")
        
        available_frame.dropShadow(color: .gray, opacity: 0.5, offSet: CGSize.zero, radius: 5, scale: true)
        available_collectionView.dataSource = self
        available_collectionView.delegate = self
        available_collectionView.register(UINib(nibName: "OneLabelCell", bundle: nil), forCellWithReuseIdentifier: "OneLabelCell")
        
        duration_frame.dropShadow(color: .gray, opacity: 0.5, offSet: CGSize.zero, radius: 5, scale: true)
        duration_collectionView.dataSource = self
        duration_collectionView.delegate = self
        duration_collectionView.register(UINib(nibName: "OneLabelCell", bundle: nil), forCellWithReuseIdentifier: "OneLabelCell")
        
        ques_label.text = "Question for \(data.name!)"
        ques_frame.layer.cornerRadius = 8
        ques_frame.layer.borderWidth = 1
        ques_frame.layer.borderColor = Utility.color(withHexString: ShareData.btn_color).cgColor
        ques_in.delegate = self
        ques_in.textColor = UIColor.gray
        ques_in.text = "Required Field..."
        
        
        book_btn.layer.cornerRadius = CGFloat(ShareData.btn_radius)
        book_btn.clipsToBounds = true
        book_btn.dropShadow(color: .gray, opacity: 0.8, offSet: CGSize.zero, radius: 5, scale: true)
        
        video_frame.isHidden = true
        video_check_status = false
        video_check.image = UIImage.init(named: "uncheck")
        let gesture = UITapGestureRecognizer(target: self, action: #selector(videoCheck(_:)))
        video_bio.text = data.bio!
        video_check.isUserInteractionEnabled = true
        video_check.addGestureRecognizer(gesture)
        video_msg_title.text = "VIDEO MESSAGE FOR \(data.name!.uppercased())"
        video_fee_label.text = "$\(ShareData.app_config.msg_fee!)/Message"
        video_record_btn.backgroundColor = UIColor.darkGray
        video_record_btn.shadow(color: UIColor.gray, opacity: 0.8, offSet: .zero, radius: 3, scale: true)
        video_record_btn.isUserInteractionEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        video_frame.isHidden = true
        bookTimeDisplay()
        scrollView.setContentOffset(CGPoint(x: CGFloat(0), y: CGFloat(0)), animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        
        let month_indexPath = IndexPath(item: Int(book_time[1])! - 1, section: 0)
        self.month_collectionView.scrollToItem(at: month_indexPath, at: [.centeredVertically,   .centeredHorizontally], animated: true)
        
        
        let day_indexPath = IndexPath(item: Int(book_time[2])! - 1, section: 0)
        self.day_collectionView.scrollToItem(at: day_indexPath, at: [.centeredVertically,   .centeredHorizontally], animated: true)
        
        var index = available_time_array.index(where: { $0 == book_time[3] }) ?? 0
        let available_indexPath = IndexPath(item: index, section: 0)
        self.available_collectionView.scrollToItem(at: available_indexPath, at: [.centeredVertically,   .centeredHorizontally], animated: true)
        
        index = duration_array.index(where: { $0 == self.duration }) ?? 0
        let duration_indexPath = IndexPath(item: index, section: 0)
        self.duration_collectionView.scrollToItem(at: duration_indexPath, at: [.centeredVertically,   .centeredHorizontally], animated: true)
    }
    
    @IBAction func reviewAction(_ sender: Any) {
        
        ShareData.review_from_status = false
        ShareData.rate_or_follow_status = true
        self.startAnimating(CGSize(width: 40, height: 40), message: nil, type: progressDlg, color: .darkGray, fadeInAnimation: nil)
        let parmeters = ["user_id": ShareData.selected_influencer.id!, "type": "0"] as [String: Any]
        
        CommonFuncs().createRequest(false, "review/request", "POST", parmeters, completionHandler: {data in
            
            let status = data["status"] as! Bool
            let message = data["message"] as! String
            
            DispatchQueue.main.async {
                
                if status
                {
                    if let detail = data["data"], let temp = Mapper<ReviewMDL>().mapArray(JSONObject: detail["reviews"])
                    {
                        ShareData.reviews = temp
                        self.navigationController?.pushViewController(MoreRateReviewVC(), animated: true)
                    }
                    else
                    {
                        CommonFuncs().doneAlert(ShareData.appTitle, "There are no reviews", "CLOSE", {})
                    }
                }
                else
                {
                    CommonFuncs().doneAlert(ShareData.appTitle, message, "CLOSE", {})
                }
                
                self.stopAnimating(nil)
            }
        })
        
    }
    
    @IBAction func followingUserAction(_ sender: Any) {
        
        ShareData.follow_or_following = "1"
        ShareData.rate_or_follow_status = false
        self.startAnimating(CGSize(width: 40, height: 40), message: nil, type: progressDlg, color: .darkGray, fadeInAnimation: nil)
        let parmeters = ["user_id": ShareData.selected_influencer.id!, "status": ShareData.follow_or_following] as [String: Any]
        
        
        CommonFuncs().createRequest(false, "detail/follow_users", "POST", parmeters, completionHandler: {data in
            
            let status = data["status"] as! Bool
            let message = data["message"] as! String
            
            DispatchQueue.main.async {
                
                if status
                {
                    if let temp = Mapper<UserMDL>().mapArray(JSONObject: data["data"])
                    {
                        ShareData.new_following_list = temp
                        self.navigationController?.pushViewController(MoreRateReviewVC(), animated: true)
                    }
                    
                }
                else
                {
                    CommonFuncs().doneAlert(ShareData.appTitle, message, "CLOSE", {})
                }
                
                self.stopAnimating(nil)
            }
        })
        
    }
    
    
    @IBAction func followedUserAction(_ sender: Any) {
        
        ShareData.follow_or_following = "0"
        ShareData.rate_or_follow_status = false
        self.startAnimating(CGSize(width: 40, height: 40), message: nil, type: progressDlg, color: .darkGray, fadeInAnimation: nil)
        let parmeters = ["user_id": ShareData.selected_influencer.id!, "status": ShareData.follow_or_following] as [String: Any]
        
        
        CommonFuncs().createRequest(false, "detail/follow_users", "POST", parmeters, completionHandler: {data in
            
            let status = data["status"] as! Bool
            let message = data["message"] as! String
            
            DispatchQueue.main.async {
                
                if status
                {
                    if let temp = Mapper<UserMDL>().mapArray(JSONObject: data["data"])
                    {
                        ShareData.new_following_list = temp
                        self.navigationController?.pushViewController(MoreRateReviewVC(), animated: true)
                    }
                    
                }
                else
                {
                    CommonFuncs().doneAlert(ShareData.appTitle, message, "CLOSE", {})
                }
                
                self.stopAnimating(nil)
            }
        })
    }
    
    
    @IBAction func msgAction(_ sender: Any) {
        
        ShareData.msg_vc_from = "1"
        self.navigationController?.pushViewController(MainTrendProfileMsgVC(), animated: true)
    }
    
    @IBAction func followAction(_ sender: Any) {
        
        self.startAnimating(CGSize(width: 40, height: 40), message: nil, type: progressDlg, color: .darkGray, fadeInAnimation: nil)
        
        let send_time = CommonFuncs().currentTime()
        
        let parmeters = ["normal_id": ShareData.user_info.id!, "influencer_id": ShareData.selected_influencer.id!, "time": send_time, "time_zone": ShareData.user_info.time_zone!] as [String: Any]
        
        CommonFuncs().createRequest(false, "follow/request", "POST", parmeters, completionHandler: {data in
            
            let status = data["status"] as! Bool
            let message = data["message"] as! String
            
            DispatchQueue.main.async {
                
                self.stopAnimating(nil)
                CommonFuncs().doneAlert(ShareData.appTitle, message, "CLOSE", {})
                
            }
        })
        
        
    }
    
    @IBAction func videoRecordAction(_ sender: Any) {
        
        video_frame.isHidden = false
        
        video_frame_left.constant = UIScreen.main.bounds.width
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.1) {
            
            self.video_frame_left.constant = 0
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func videoRecordStart(_ sender: Any) {
        
        
        let coin_num = Int(fee_rate * 5 / Double(ShareData.app_config.popcoin_price)!)
        
        if ShareData.user_info.paypal_id! == "" && ShareData.user_info.venmo_id! == ""
        {
            
            alert_view = CommonFuncs().selectAlert(ShareData.appTitle, "Your credit account is not verified. Please verify credit account", 2, ["VERIFY NOW", "CANCEL"], [Utility.color(withHexString: ShareData.btn_color), UIColor.gray], [UIColor.white, UIColor.white], self, [#selector(paymentVerifyOK(_:)), #selector(paymentVerifyCancel(_:))])
            alert_view.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertOutSideTapped(_:))))
            
            
        }
        else if Int(ShareData.user_info.popcoin_num!)! < coin_num
        {
            alert_view = CommonFuncs().selectAlert(ShareData.appTitle, "You don`t have enough PopCoin for this request(need more \(coin_num - Int(ShareData.user_info.popcoin_num!)!)). Do you want to buy PopCoin?", 2, ["BUY NOW", "CANCEL"], [Utility.color(withHexString: ShareData.btn_color), UIColor.gray], [UIColor.white, UIColor.white], self, [#selector(coinBuyOkAction(_:)), #selector(coinBuyCancelAction(_:))])
            alert_view.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertOutSideTapped(_:))))
        }
        else
        {
//            var controller = UIImagePickerController()
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//
//                controller.sourceType = .camera
//                controller.mediaTypes = [kUTTypeMovie as String]
//                controller.delegate = self
//
//                present(controller, animated: true, completion: nil)
//            }
//            else {
//                print("Camera is not available")
//            }
            
            self.navigationController?.pushViewController(VideoRecordVC(), animated: true)
            
        }
    }
    
    
    @IBAction func bookConfrimAction(_ sender: Any) {
        
        let coin_num = Int(fee_rate * Double(duration)! / Double(ShareData.app_config.popcoin_price)!)

        if ques_in.text == "" || ques_in.text == nil
        {
            CommonFuncs().doneAlert(ShareData.appTitle, "Please insert your question", "CLOSE", {})
        }
        else
        {
            if ShareData.user_info.paypal_id! == "" && ShareData.user_info.venmo_id! == ""
            {
                
                alert_view = CommonFuncs().selectAlert(ShareData.appTitle, "Your credit account is not verified. Please verify credit account", 2, ["VERIFY NOW", "CANCEL"], [Utility.color(withHexString: ShareData.btn_color), UIColor.gray], [UIColor.white, UIColor.white], self, [#selector(paymentVerifyOK(_:)), #selector(paymentVerifyCancel(_:))])
                alert_view.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertOutSideTapped(_:))))
                
                
            }
            else if Int(ShareData.user_info.popcoin_num!)! < coin_num
            {
                alert_view = CommonFuncs().selectAlert(ShareData.appTitle, "You don`t have enough PopCoin for this book(need more \(coin_num - Int(ShareData.user_info.popcoin_num!)!)). Do you want to buy PopCoin?", 2, ["BUY NOW", "CANCEL"], [Utility.color(withHexString: ShareData.btn_color), UIColor.gray], [UIColor.white, UIColor.white], self, [#selector(coinBuyOkAction(_:)), #selector(coinBuyCancelAction(_:))])
                alert_view.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertOutSideTapped(_:))))
            }
            else
            {
                
                let current_time = CommonFuncs().splitString(CommonFuncs().currentTime())
                
                var status = false
                
                if Int(current_time[1])! == Int(book_time[1])!
                {
                    if Int(current_time[2])! == Int(book_time[2])!
                    {
                        if Int(current_time[3])! < Int(book_time[2])!
                        {
                            status = true
                        }
                    }
                    else if Int(current_time[2])! < Int(book_time[2])!
                    {
                        status = true
                    }
                }
                else if Int(current_time[1])! < Int(book_time[1])!
                {
                    status = true
                }
                
                if status
                {
                    ShareData.booking_time = "\(book_time[0])-\(book_time[1])-\(book_time[2])-\(book_time[3])"
                    ShareData.booking_duration = duration
                    ShareData.booking_question = ques_in.text!
                    ShareData.booking_popcoin = "\(coin_num)"
                    self.navigationController?.pushViewController(MainTrendProfileConfirmVC(), animated: true)
                }
                else
                {
                    CommonFuncs().doneAlert(ShareData.appTitle, "Please check booking time", "CLOSE", {})
                }
                
            }

        }
    }
    
    @objc func backAction(_ sender: UIButton) {
        
        ShareData.selected_influencer = nil
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

extension MainTrendProfileVC: UITextViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate
{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        ques_in.resignFirstResponder()
        if coin_buy_status
        {
            coin_in.resignFirstResponder()
        }
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        return numberOfChars < 300
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        scrollView.setContentOffset(CGPoint(x: CGFloat(0), y: CGFloat(580)), animated: true)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        ques_in.text = ""
        ques_in.textColor = UIColor.darkGray
        scrollView.setContentOffset(CGPoint(x: CGFloat(0), y: CGFloat(580)), animated: true)
        
        return true
    }
    
    @objc func alertOutSideTapped(_ sender: UITapGestureRecognizer)
    {
        alert_view.hideView()
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.contains("\n")
        {
            let str = textView.text!
            textView.text = str.substring(to: str.index(before: str.endIndex))
            
        }
    }
    
}

extension MainTrendProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 1
        

        if let videoURL = info[UIImagePickerControllerMediaURL] as? NSURL {
            
            var movieData: Data?
            do {
                movieData = try Data(contentsOf: videoURL as URL, options: Data.ReadingOptions.alwaysMapped)
                
                self.startAnimating(CGSize(width: 40, height: 40), message: nil, type: progressDlg, color: .darkGray, fadeInAnimation: nil)
                let parameter = ["normal_id": ShareData.user_info.id!, "influencer_id": ShareData.selected_influencer.id!, "time": CommonFuncs().currentTime(), "time_zone": ShareData.user_info.time_zone!] as [String: String]
                
                let url = URL(string: "\(ShareData.main_url)book/video_sent.php")!
                
                Alamofire.upload(multipartFormData: { (multiPartFormData: MultipartFormData) in
                    for (key, value) in parameter as! [String: String] {
                        multiPartFormData.append((value as String).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                    }
                    
                    multiPartFormData.append(movieData! as Data, withName: "upload", fileName: "upload", mimeType: "video/mov")
                    
                }, to: url) { (result: SessionManager.MultipartFormDataEncodingResult) in
                    switch result {
                    case .success(request: let uploadRequest, _, _ ):
                        
                        
                        uploadRequest.uploadProgress(closure: { (progress) in
                            
                            print("===== \(progress)")
                        })
                        
                        
                        uploadRequest.responseJSON(completionHandler: {response in
                            
                            if let JSON = response.result.value
                            {
                                let dictData = JSON as! NSDictionary
                                let status = dictData["status"] as! Bool
                                let message = dictData["message"] as! String
                                
                                do {
                                    try FileManager.default.removeItem(at: videoURL as URL)
                                } catch {
                                    print("Could not delete file: \(error)")
                                }
                                
                                self.stopAnimating(nil)
                                
                                CommonFuncs().doneAlert(ShareData.appTitle, message, "CLOSE", {})
                                
                            }
                            
                        })
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            } catch _ {
                
                movieData = nil
                CommonFuncs().doneAlert(ShareData.appTitle, "Failed Video Record", "CLOSE", {})
                return
            }
            
        }
        
        picker.dismiss(animated: true)
        
    }
    
}



extension MainTrendProfileVC
{
    
    func availabeTimeCheck()
    {
        available_time_array = [String]()
        
        var formater_0 = DateFormatter()
        formater_0.dateFormat = "yyyy-MM-dd"
        let time_str_0 = formater_0.date(from: "\(book_time[0])-\(book_time[1])-\(book_time[2])")!
        
        let calendar_0 = Calendar.current
        let weekDay_0 = calendar_0.component(.weekday, from: time_str_0) as! Int - 1
        
        let array1 = CommonFuncs().splitString(ShareData.selected_influencer.chat_time!.characters.split(separator: ",").map(String.init)[weekDay_0])
        
        let array2 = CommonFuncs().splitString(ShareData.selected_influencer.chat_rate!.characters.split(separator: ",").map(String.init)[weekDay_0])
        fee_rate = (Double(array2[2])! + Double(array2[3])! / 100) / (Double(array2[0])! * 60 + Double(array2[1])!)
        
        
        var chat_start_time_hour = Int(array1[0])!
        var chat_start_time_min = Int(array1[1])!
        var chat_end_time_hour = Int(array1[2])!
        var chat_end_time_min = Int(array1[3])!
        
        if chat_start_time_min <= 15
        {
            chat_start_time_min = 0
        }
        else if chat_start_time_min >= 45
        {
            chat_start_time_min = 0
            chat_start_time_hour += 1
        }
        else
        {
            chat_start_time_min = 30
        }
        
        if chat_end_time_min <= 15
        {
            chat_end_time_min = 30
            chat_end_time_hour -= 1
        }
        else if chat_end_time_min >= 45
        {
            chat_end_time_min = 30
        }
        else
        {
            chat_end_time_min = 0
        }
        
        var chat_time_hour = chat_start_time_hour
        var chat_time_min = chat_start_time_min
        
        while chat_time_hour <= chat_end_time_hour && chat_time_min <= chat_end_time_min {
            
            let cell_hour = String(format: "%02d", chat_time_hour)
            let cell_min = String(format: "%02d", chat_time_min)
            let temp_book = "\(book_time[0])-\(book_time[1])-\(book_time[2])-\(cell_hour)-\(cell_min)"
            
            var status = false
            
            for i in 0..<booked_list.count
            {
                if temp_book == booked_list[i]
                {
                    status = true
                    break
                }
            }
            
            if !status
            {
                available_time_array.append("\(cell_hour)-\(cell_min)")
            }
            
            let add_min = (chat_time_min + 30) % 60
            let add_hour = (chat_time_min + 30) / 60
            
            chat_time_min = add_min
            chat_time_hour += add_hour
        }
        
        var formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        let time_str = formater.date(from: "\(book_time[0])-\(book_time[1])-\(book_time[2])")!
        
        let calendar = Calendar.current
        let weekDay = calendar.component(.weekday, from: time_str) as! Int
        
        let array = CommonFuncs().splitString(ShareData.selected_influencer.work_day!)
        
        if array[weekDay] == "1"
        {
            available_index =  Array(repeating: 0, count: available_time_array.count)
            available_index[0] = 1
        }
        else
        {
            available_index =  Array(repeating: 2, count: available_time_array.count)
        }
        
        available_collectionView.reloadData()
        
    }
    
    func weekDayCheck()
    {
        let array = CommonFuncs().splitString(ShareData.selected_influencer.work_day!)
        
        day_index = Array(repeating: 0, count: month_day_cnt)
        var formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        
        for i in 1..<month_day_cnt + 1
        {
            
            let time_str = formater.date(from: "\(book_time[0])-\(book_time[1])-\(i)")!
            
            let calendar = Calendar.current
            let weekDay = calendar.component(.weekday, from: time_str) as! Int
            
            if array[weekDay] == "0"
            {
                day_index[i - 1] = 2
            }
        }
        
        day_collectionView.reloadData()
    }
    
    func bookTimeDisplay()
    {
        self.duration_label.text = self.duration
        
        let array = CommonFuncs().splitString(book_time[3])
        let str = CommonFuncs().timeString("\(book_time[0])-\(book_time[1])-\(book_time[2])-\(array[0])-\(array[1])", "\(duration)", 2)
        
        fee_label.text = "$\(String(format: "%.02f", fee_rate * Double(duration)!))"
        
        duration_label.text = "\(duration) mins"
        self.time_label.text = "\(str) EST \(ShareData.selected_influencer.time_zone!)"
    }
    
    @objc func paymentVerifyOK(_ sender: UIButton) {
        
        ShareData.pay_from_status = false
        self.navigationController?.pushViewController(MorePayVC(), animated: true)
    }
    
    @objc func paymentVerifyCancel(_ sender: UIButton) {
        
        return
    }
    
    @objc func coinBuyOkAction(_ sender: UIButton) {
        
        coin_in = CommonFuncs().inputAlert(ShareData.appTitle, "Buy new PopCoin", "Input coin numbers...", 2, ["BUY", "CANCEL"], [Utility.color(withHexString: ShareData.btn_color), UIColor.gray], [UIColor.white, UIColor.white], self, [#selector(coinBuyConfirmOkAction(_:)), #selector(coinBuyConfirmCancelAction(_:))])
        coin_buy_status = true
        self.coin_in.delegate = self
    }
    
    @objc func coinBuyCancelAction(_ sender: UIButton) {
        
        return
    }
    
    @objc func coinBuyConfirmOkAction(_ sender: UIButton) {
        
        coin_buy_status = false
        
        if coin_in.text == "" || coin_in.text == nil
        {
            return
        }
        else
        {
            
            let parmeters = ["user_id": ShareData.user_info.id!, "popcoin": coin_in.text!, "status": "1"] as [String: Any]
            
            self.startAnimating(CGSize(width: 40, height: 40), message: nil, type: self.progressDlg, color: .darkGray, fadeInAnimation: nil)
            
            CommonFuncs().createRequest(false, "payment/popcoin_buy", "POST", parmeters, completionHandler: {data in
                
                let status = data["status"] as! Bool
                let message = data["message"] as! String
                
                DispatchQueue.main.async {
                    
                    self.stopAnimating(nil)
                    
                    if status
                    {
                        var coin_num = Int(ShareData.user_info.popcoin_num!)!
                        coin_num += Int(self.coin_in.text!)!
                        ShareData.user_info.popcoin_num = "\(coin_num)"
                        
                    }
                    else
                    {
                        CommonFuncs().doneAlert(ShareData.appTitle, message, "CLOSE", {})
                        
                    }
                    
                }
            })
            
            
        }
        
    }
    
    @objc func coinBuyConfirmCancelAction(_ sender: UIButton) {
        
        return
    }
    
    
    @objc func videoCheck(_ sender: UITapGestureRecognizer) {
        
        if video_check_status
        {
            video_check_status = false
            video_check.image = UIImage.init(named: "uncheck")
            video_record_btn.backgroundColor = UIColor.darkGray
            video_record_btn.isUserInteractionEnabled = false
        }
        else
        {
            video_check_status = true
            video_check.image = UIImage.init(named: "check")
            video_record_btn.backgroundColor = Utility.color(withHexString: ShareData.btn_color)
            video_record_btn.isUserInteractionEnabled = true
            
        }
        
    }
}

extension MainTrendProfileVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView == month_collectionView
        {
            return ShareData.month_short_names.count
        }
        else if collectionView == day_collectionView
        {
            return month_day_cnt
        }
        else if collectionView == available_collectionView
        {
            return available_time_array.count
        }
        else
        {
            return duration_array.count
        }
        
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var width: CGFloat = 0
        var height: CGFloat = 0
        
        if collectionView == month_collectionView
        {
            width = 80
            height = 30
        }
        else if collectionView == day_collectionView
        {
            width = 30
            height = 30
        }
        else if collectionView == available_collectionView
        {
            width = 100
            height = 30
        }
        else
        {
            width = 100
            height = 30
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == month_collectionView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OneLabelCell", for: indexPath) as! OneLabelCell
            
            if month_index[indexPath.row]
            {
                cell.backgroundColor = Utility.color(withHexString: "143755")
                cell.name.textColor = UIColor.white
            }
            else
            {
                cell.backgroundColor = UIColor.white
                cell.name.textColor = UIColor.darkGray
            }
            
            cell.layer.cornerRadius = CGFloat(ShareData.btn_radius)
            cell.clipsToBounds = true
            cell.dropShadow(color: .gray, opacity: 0.5, offSet: CGSize.zero, radius: 3, scale: true)
            
            
            cell.name.text = ShareData.month_short_names[indexPath.row]
            
            return cell
            
        }
        else if collectionView == day_collectionView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OneLabelCell", for: indexPath) as! OneLabelCell
            
            if day_index[indexPath.row] == 1
            {
                cell.backgroundColor = Utility.color(withHexString: "143755")
                cell.name.textColor = UIColor.white
            }
            else if day_index[indexPath.row] == 0
            {
                cell.backgroundColor = UIColor.white
                cell.name.textColor = UIColor.darkGray
            }
            else
            {
                cell.backgroundColor = UIColor.lightGray
                cell.name.textColor = UIColor.white
            }
            
            cell.layer.cornerRadius = cell.frame.height / 2
            cell.clipsToBounds = true
            cell.dropShadow(color: .gray, opacity: 0.5, offSet: CGSize.zero, radius: 3, scale: true)
            
            cell.name.text = "\(indexPath.row + 1)"
            
            return cell
        }
        else if collectionView == available_collectionView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OneLabelCell", for: indexPath) as! OneLabelCell
            
            if available_index[indexPath.row] == 1
            {
                cell.backgroundColor = Utility.color(withHexString: "143755")
                cell.name.textColor = UIColor.white
            }
            else if available_index[indexPath.row] == 0
            {
                cell.backgroundColor = UIColor.white
                cell.name.textColor = UIColor.darkGray
            }
            else
            {
                cell.backgroundColor = UIColor.lightGray
                cell.name.textColor = UIColor.white
            }
            
            cell.layer.cornerRadius = CGFloat(ShareData.btn_radius)
            cell.clipsToBounds = true
            cell.dropShadow(color: .gray, opacity: 0.5, offSet: CGSize.zero, radius: 3, scale: true)
            
            let array = CommonFuncs().splitString(available_time_array[indexPath.row])
            let array1 = CommonFuncs().time24To12(array[0])
            cell.name.text = "\(array1[0]) : \(array[1]) \(array1[1])"
            
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OneLabelCell", for: indexPath) as! OneLabelCell
            
            if duration_index[indexPath.row]
            {
                cell.backgroundColor = Utility.color(withHexString: "143755")
                cell.name.textColor = UIColor.white
            }
            else
            {
                cell.backgroundColor = UIColor.white
                cell.name.textColor = UIColor.darkGray
            }
            
            cell.layer.cornerRadius = CGFloat(ShareData.btn_radius)
            cell.clipsToBounds = true
            cell.dropShadow(color: .gray, opacity: 0.5, offSet: CGSize.zero, radius: 3, scale: true)
            
            cell.name.text = "\(duration_array[indexPath.row]) minutes"
            
            return cell
        }

    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if collectionView == month_collectionView
        {
            month_index = Array(repeating: false, count: ShareData.month_short_names.count)
            month_index[indexPath.row] = true
            book_time[1] = String(format: "%02d", indexPath.row + 1)
            
            month_day_cnt = month_day_cnt_list[indexPath.row]
            if Int(book_time[2])! > month_day_cnt_list[indexPath.row]
            {
                book_time[2] =  String(format: "%02d", month_day_cnt_list[indexPath.row])
            }
            weekDayCheck()
            availabeTimeCheck()
            
        }
        else if collectionView == day_collectionView
        {
            if day_index[indexPath.row] != 2
            {
                weekDayCheck()
                day_index[indexPath.row] = 1
                book_time[2] = String(format: "%02d", indexPath.row + 1)
                availabeTimeCheck()
            }
            else
            {
                CommonFuncs().doneAlert(ShareData.appTitle, "\(ShareData.selected_influencer.name!) don`t work on this day", "CLOSE", {})
            }
            
        }
        else if collectionView == available_collectionView
        {
            if available_index[indexPath.row] != 2
            {
                available_index = Array(repeating: 0, count: available_time_array.count)
                available_index[indexPath.row] = 1
                book_time[3] = available_time_array[indexPath.row]
            }
            
        }
        else
        {
            duration_index = Array(repeating: false, count: duration_array.count)
            duration_index[indexPath.row] = true
            duration = duration_array[indexPath.row]
        }
        
        bookTimeDisplay()
        collectionView.reloadData()
    }
    
}

