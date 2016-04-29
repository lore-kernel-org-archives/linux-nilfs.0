From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 06/11] nilfs2: clarify permission to replicate the design
Date: Fri, 29 Apr 2016 22:15:42 +0900
Message-ID: <1461935747-10380-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1461935747-10380-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=APNeabYbBI4W+8AzE5p+RIfS/ouCY0tN0Nc3F9mvjTQ=;
        b=zezU8QKEkjITuZGfJpylqaPX2Wz/nOHTnqo1kAjfqAx6D/vKzjz9kvc6rzeKYpUvy0
         XJisg/IvnHnDy/NRkCWd4mR8LzCp24MsXWrM1Ig2H4Rhu0om2lSvFhVGEKxG78hOCKTw
         L7vaQ7KjzSuXB9Gf1EWnHqCASSDBJ7l6yQ5Kz34sVyG9fdMy1DIOI4S+lGFBymzhMJ7s
         mtqz+3KZ/4UN7v+opwnRvABhDjrgsD60lbWdNt5ezb/rAiTSVDgLJuaOQ1ebDdUbRtBk
         njsKddHXWwBb2marjPUFrpurTDDLeb4R0kdTE6SWMWbdt99cOr/BIaaurp2fdcrunFJT
         yzVQ==
In-Reply-To: <1461935747-10380-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

To respond to a certain developer's request, this explicitly state
that developers can reimplement the nilfs2 design for other operating
systems to share data stored in that format.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 Documentation/filesystems/nilfs2.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/filesystems/nilfs2.txt b/Documentation/filesystems/nilfs2.txt
index 41c3d33..5b21ef7 100644
--- a/Documentation/filesystems/nilfs2.txt
+++ b/Documentation/filesystems/nilfs2.txt
@@ -268,3 +268,8 @@ among NILFS2 files can be depicted as follows:
                                     ( regular file, directory, or symlink )
 
 For detail on the format of each file, please see include/linux/nilfs2_fs.h.
+
+There are no patents or other intellectual property that we protect
+with regard to the design of NILFS2.  It is allowed to replicate the
+design in hopes that other operating systems could share (mount, read,
+write, etc.) data stored in this format.
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
