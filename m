From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/1] nilfs2: add omitted comment for ns_mount_state field
 of the_nilfs structure
Date: Tue, 22 May 2012 18:25:15 +0400
Message-ID: <1337696715.2530.14.camel@slavad-ubuntu-11>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Message-ID:Date:Content-Type:To:From:Subject; bh=mXDWb8o0MR6guZvY1Di/VhbAoss7HWIcxKcF1dBaKpE=;
	b=XeQBVeJGGr6qyPRXAZRpjZRWMOIi7tcP0/zXFuWVa0vvf6Du/CXm/IsYqLUvoS+zU43r157JySj82hUA2D96Dedt+iAXaKshP+Ztlnya2dcSmIHxXjicLr6I4HPPl0cu;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I found that ns_mount_state field doesn't commented in the_nilfs
structure. I simply add comment for ns_mount_state field.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/1] nilfs2: add omitted comment for ns_mount_state
field of the_nilfs structure

This patch adds omitted comment for ns_mount_state field of the_nilfs
structure.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 1a588a3..7885bdb 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -53,6 +53,7 @@ enum {
  * @ns_sbwtime: previous write time of super block
  * @ns_sbwcount: write count of super block
  * @ns_sbsize: size of valid data in super block
+ * @ns_mount_state: file system state
  * @ns_seg_seq: segment sequence counter
  * @ns_segnum: index number of the latest full segment.
  * @ns_nextnum: index number of the full segment index to be used next
--


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
