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

class ArticleCommentItemCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var articleComment: ArticleComment!
    
    var data: ArticleComment {
        get {
            return self.articleComment!
        }
        set(newValue) {
            self.articleComment = newValue
            self.avatarImageView.sd_setImageWithURL(NSURL(string: (self.articleComment.user.avatar_small_url)))
            self.nameLabel.text = self.articleComment.user.name
            self.contentLabel.text = self.articleComment.content
            self.timeLabel.text = self.articleComment.created_at.timeAgoSinceNow()
        }
    }
}