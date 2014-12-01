From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 2/3] nilfs2: Deletion of an unnecessary check before the function call "iput"
Date: Tue,  2 Dec 2014 01:41:46 +0900
Message-ID: <1417452107-6411-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1417452107-6411-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=+lQ70PhCSSMwM+Xq9dre1g/qGxXZu6S8CfrsFiYt8eg=;
        b=LlMHJNEC8+sMI/OLrgB3iyTbL58DgNxm+oje0o5+9rbsMbvTX4BkjJ7s9lXIrpGskd
         eX+/Nkr3vAT9Txd1hKe0Fyy/B049GEqY9Q4Y5TNFb7L+1PeiZtLElpEalKPY3cPfPo8r
         neAiBXKz9dMPK0hPL7CqL+eDYv5kz2HlWLpygL9hdTLopHh9wTtPX8wAwfda9j1He+mp
         0PuD0w+tjrLpULoR9QUZSI5J2qsCaK9PiWQfGv+a/QCCbCP6OC3iIKtk0d2gHCOhquPw
         AkG/5j8ZRQu7iQyqaSI14HzZcrUtSrRwSOeQD50P+E4deuxu/cDeVGV/vplVIKu9GLfY
         xDHA==
In-Reply-To: <1417452107-6411-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nilfs <linux-nilfs@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Markus Elfring <elfring@users.sourceforge.net>

From: Markus Elfring <elfring@users.sourceforge.net>

The iput() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/the_nilfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 9da25fe..69bd801 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -808,8 +808,7 @@ void nilfs_put_root(struct nilfs_root *root)
 		spin_lock(&nilfs->ns_cptree_lock);
 		rb_erase(&root->rb_node, &nilfs->ns_cptree);
 		spin_unlock(&nilfs->ns_cptree_lock);
-		if (root->ifile)
-			iput(root->ifile);
+		iput(root->ifile);
 
 		kfree(root);
 	}
-- 
1.8.3.1
