/**
 * Copyright (C) 2015 JianyingLi <lijy91@foxmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit
import TUSafariActivity

class TopicDetailController: BaseListController<Article> {
    
    var topicId: Int!
    var topic: Topic!
    
    init(_ id: Int) {
        super.init()
        self.topicId = id
        self.topic = Topic(id: id, name: "", description: "")
    }

    init(_ data: Topic) {
        super.init()
        self.topicId = data.id
        self.topic = data
    }
    
    var menuShare: UIBarButtonItem!
    var headerView: TopicDetailHeaderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = trans("topic_detail.title")
        
        self.menuShare = UIBarButtonItem(image: UIImage(named: "ic_menu_share"), style: .Plain, target: self, action: #selector(shareButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = self.menuShare
        
        self.headerView = TopicDetailHeaderView.instanceFromNib()
        self.headerView!.data = self.topic
        self.tableView!.tableHeaderView = self.headerView!
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0
        
        self.tableView.registerClass(TopicItemCell.self, forCellReuseIdentifier: "ArticleItemCell")
        self.tableView.registerNib(UINib(nibName: "ArticleItemCell", bundle: nil), forCellReuseIdentifier: "ArticleItemCell")
        
        self.tableView.registerClass(TopicItemCell.self, forCellReuseIdentifier: "ArticleNoImageItemCell")
        self.tableView.registerNib(UINib(nibName: "ArticleNoImageItemCell", bundle: nil), forCellReuseIdentifier: "ArticleNoImageItemCell")
        
        self.firstRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let navigationController = self.navigationController as! BaseNavigationController
        navigationController.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let navigationController = self.navigationController as! BaseNavigationController
        navigationController.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        navigationController.navigationBar.shadowImage = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.sizeHeaderToFit()
    }
    
    private func sizeHeaderToFit() {
        if let headerView: TopicDetailHeaderView = tableView.tableHeaderView as! TopicDetailHeaderView {
            
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
                        
            let height = headerView.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize).height
            var newFrame = headerView.frame
            
            // Needed or we will stay in viewDidLayoutSubviews() forever
            if height != newFrame.size.height {
                newFrame.size.height = height
                headerView.frame = newFrame
                
                tableView.tableHeaderView = headerView
            }
        }
    }
    
    override func loadData(page: Int) {
        let completionBlock = { (pagination: Pagination!, data: [Article]!, error: NSError!) -> Void in
            self.loadComplete(pagination, data)
        }
        Api.getArticleListByTopicId(page, topicId: self.topicId, completion: completionBlock)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = self.itemsSource[indexPath.row]
        data.topic = nil
        
        var identifier: String = "ArticleItemCell"
        if (data.image_url == nil || data.image_url == "") {
            identifier = "ArticleNoImageItemCell";
        } else {
            //            if (indexPath.row < 10) {
            //                identifier = "ArticleBigImageItemCell";
            //            }
        }
        
        let cell: ArticleItemCell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! ArticleItemCell
        
        cell.data = data
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        let data = self.itemsSource[indexPath.row]
        
        let controller = ArticleDetailController(data)
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func shareButtonPressed(sender: UIBarButtonItem) {
        let activities: [UIActivity] = [TUSafariActivity()];
        let activityViewController = UIActivityViewController(activityItems: self.topic.sharingContent, applicationActivities: activities)
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
}
