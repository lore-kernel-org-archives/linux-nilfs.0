From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] nilfs2_ss_manager: fix TypeError at exit
Date: Sun, 06 Feb 2011 21:34:53 +0900 (JST)
Message-ID: <20110206.213453.187450645.ryusuke@osrg.net>
References: <1296995057-30479-1-git-send-email-ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1296995057-30479-1-git-send-email-ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ryusuke-sG5X7nlA6pw@public.gmane.org

On Sun,  6 Feb 2011 21:24:17 +0900, Ryusuke Konishi wrote:
> Fixes the following error on shutdown:
> 
> Traceback (most recent call last):
>   File "./nilfs2_ss_manager", line 211, in <module>
>     mainloop.run()
> TypeError: __exit__() takes exactly 1 argument (4 given)
> 
> Signed-off-by: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>

There is a typo on the previous patch.

Please apply the following one instead.

Thanks,
Ryusuke Konishi
--
From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>

nilfs2_ss_manager: fix TypeError at exit

Fixes the following error on shutdown:

Traceback (most recent call last):
  File "./nilfs2_ss_manager", line 211, in <module>
    mainloop.run()
TypeError: __exit__() takes exactly 1 argument (4 given)

Signed-off-by: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
---
 nilfs2_ss_manager/nilfs2_ss_manager |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/nilfs2_ss_manager/nilfs2_ss_manager b/nilfs2_ss_manager/nilfs2_ss_manager
index 5821e2a..2243034 100755
--- a/nilfs2_ss_manager/nilfs2_ss_manager
+++ b/nilfs2_ss_manager/nilfs2_ss_manager
@@ -150,7 +150,7 @@ class NODaemonContext:
     def __enter__(self):
         pass
 
-    def __exit__(self):
+    def __exit__(self, *excinfo):
         pass
 
 def register_sighandlers(managers, mainloop):
-- 
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
