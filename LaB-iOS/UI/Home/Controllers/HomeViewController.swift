//
//  HomeViewController.swift
//  LaB-iOS
//
//  Created by 鲁浩 on 16/9/8.
//  Copyright © 2016年 鲁浩. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	let cellIdentifier = "PosterCell"

	var isAddPosterViewShowing = false

	@IBOutlet weak var tableView: UITableView!

	@IBOutlet weak var maskingView: UIView!

	@IBOutlet weak var addButtonIcon: UIView!

    @IBOutlet weak var addPosterView: UIView!

    @IBOutlet weak var lendPosterLabelView: UIView!
    @IBOutlet weak var borrowPosterLabelView: UIView!
    @IBOutlet weak var showPosterLabelView: UIView!
    
    @IBOutlet weak var lendPosterIconView: UIView!
    @IBOutlet weak var borrowPosterIconView: UIView!
    @IBOutlet weak var showPosterIconView: UIView!
    
    @IBAction func addButtonClicked(_ sender: AnyObject) {
        self.isAddPosterViewShowing = !self.isAddPosterViewShowing
		UIView.animate(
			withDuration: 0.25, animations: {
                if (self.isAddPosterViewShowing) {
                    self.maskingView.alpha = 0.7
                    self.addButtonIcon.transform = self.addButtonIcon.transform.rotated(by: CGFloat(-M_PI_4))
                    self.addPosterView.alpha = 1
                } else {
                    self.maskingView.alpha = 0
                    self.addButtonIcon.transform = self.addButtonIcon.transform.rotated(by: CGFloat(M_PI_4))
                    self.addPosterView.alpha = 0
				}
		})
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.

		// 初始化TableView
		tableView.register(UINib(nibName: "PosterTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.estimatedRowHeight = 250
		tableView.rowHeight = UITableViewAutomaticDimension

		// 添加蒙版
		let tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.dismissAddPosterView))
		maskingView.addGestureRecognizer(tap)
	}

	func dismissAddPosterView() {
        self.isAddPosterViewShowing = false
        UIView.animate(
            withDuration: 0.25, animations: {
                self.maskingView.alpha = 0
                self.addButtonIcon.transform = self.addButtonIcon.transform.rotated(by: CGFloat(M_PI_4))
                self.addPosterView.alpha = 0
        })
	}
    
    override func viewWillDisappear(_ animated: Bool) {
        if (isAddPosterViewShowing) {
            self.maskingView.alpha = 0
            self.addButtonIcon.transform = self.addButtonIcon.transform.rotated(by: CGFloat(M_PI_4))
            self.addPosterView.alpha = 0
            isAddPosterViewShowing = false
        }
    }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 20
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let detail: UIViewController = UIStoryboard(name: "PosterDetail", bundle: nil).instantiateInitialViewController() as! PosterDetailViewController
		self.navigationController?.pushViewController(detail, animated: true)
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PosterTableViewCell
		return cell
	}

	/*
	 // MARK: - Navigation

	 // In a storyboard-based application, you will often want to do a little preparation before navigation
	 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	 // Get the new view controller using segue.destinationViewController.
	 // Pass the selected object to the new view controller.
	 }
	 */

}
