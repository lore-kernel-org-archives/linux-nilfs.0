From: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] nilfs2: add a print message after loading nilfs2
Date: Thu, 8 Apr 2010 23:47:11 +0800
Message-ID: <20100408154711.GA31899@xhl>
References: <20100407142058.GA27224@xhl>
 <20100408.113405.221629738.ryusuke@osrg.net>
 <u2p3a3680031004072245t5ea476a5xbd6cbe6d3302de00@mail.gmail.com>
 <20100408.162141.218082254.ryusuke@osrg.net>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:received:date:from:to:cc:subject
         :message-id:mail-followup-to:references:mime-version:content-type
         :content-disposition:in-reply-to:x-operating-system:user-agent;
        bh=b4Yty9OOzzp8g7QqgwjmaDNBEGbo8xA8Vj+s0oklsGo=;
        b=UiuxHXZDpTOm2F5uwEpcGeWQqVyJfCvSKmIoiKMzR3c4ZmCeCH4tYuroSRs6f684TY
         zUBOzcwMpJYEddgeLraSChOcZfAS2JZtvmh9ddLH5At/EfdyWAewpD32D/mN1V8zXRt0
         tG23jS8y5PAPzYNLHsjVIBvJVyQRVfXSWMizA=
Content-Disposition: inline
In-Reply-To: <20100408.162141.218082254.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke Konishi,

The patch is resent.
Thanks very much for your review and suggestions.

Regards,
Li Hong

------------------ cut here -----------------------

From d5ecb6ca6bafa2c9aa7058aee8918b94eea9b993 Mon Sep 17 00:00:00 2001
From: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Tue, 6 Apr 2010 01:23:04 +0800
Subject: [PATCH] nilfs2: add a print message after loading nilfs2

Printing a message after loading a file system is a practice. Add this to
provide a better user-friendly experience.

Signed-off-by: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/super.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 2e767bc..8777172 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1186,7 +1186,12 @@ static int __init init_nilfs_fs(void)
 		return err;
 
 	err = register_filesystem(&nilfs_fs_type);
-	return err;
+	if (err)
+		return err;
+
+	printk(KERN_INFO "NILFS version 2 loaded\n");
+	return 0;
+
 }
 
 static void __exit exit_nilfs_fs(void)
-- 
1.6.3.3

On Thu, Apr 08, 2010 at 04:21:41PM +0900, Ryusuke Konishi wrote:
> On Thu, 8 Apr 2010 13:45:05 +0800, Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > 2010/4/8 Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>:
> > > On Wed, 7 Apr 2010 22:20:58 +0800, Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >> Hi KONISHI Ryusuke,
> > >>
> > >> Any feedbacks on these patches?
> > >>
> > >> Thanks,
> > >> Li Hong
> > >
> > > Well, adding a load message is ok, but it should be more moderate like
> > > "nilfs2 file system loaded\n".
> > Yes. I just thought that printing a message after loading a file
> > system is a practice.
> > You may choose any string that you think is suitable :)
> 
> How about "NILFS version 2 loaded\n" ?
> 
> Seems that most messages have prefix "NILFS: ..." or "NILFS (device
> %s):".
>  
> > > I think this sort of change should be discussed in the sub topic
> > > mailing list (i.e. linux-nilfs).  You don't have to cc every patch to
> > > linux-kernel.
> > Ok. No problem.
> > 
> > > And, please include some explanation in the change log to clarify the
> > > aim or motivation.
> > I took it as a very simple patch and thought a header was enough. I can add more
> > explanations if here has a demand.
> 
> You thought "printing a message after loading a file system is a
> practice.", so it is the reason :)
> 
> Thanks,
> Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
