From: Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v4 11/12] nilfs2: rename d_count field of dentry to d_refcount
Date: Wed,  3 Jul 2013 23:34:38 -0400
Message-ID: <1372908878-33547-1-git-send-email-Waiman.Long@hp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Linus Torvalds <torvalds@linux-foundation.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Andi Kleen <andi@firstfloor.org>, "Chandramouleeswaran, Aswin" <aswin@hp.com>, "Norton, Scott J" <scott.norton@hp.com>

Because of the d_count name change made in dcache.h, all references
to d_count have to be changed to d_refcount.  There is no change in
logic and everything should just work.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/nilfs2/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index c7d1f9f..cea6c1a 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -973,7 +973,7 @@ static int nilfs_attach_snapshot(struct super_block *s, __u64 cno,
 
 static int nilfs_tree_was_touched(struct dentry *root_dentry)
 {
-	return root_dentry->d_count > 1;
+	return root_dentry->d_refcount > 1;
 }
 
 /**
-- 
1.7.1
