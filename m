From: Heinz Diehl <htd-iEI8Y0CNJBYdnm+yROfE0A@public.gmane.org>
Subject: Re: NILFS2: double uuid
Date: Mon, 8 Jun 2015 19:23:45 +0200
Message-ID: <20150608172324.GA7760@fritha.org>
References: <20150608094559.GB15702@fritha.org>
 <20150608100835.GA16569@fritha.org>
 <55756F17.7080603@lab.ntt.co.jp>
 <20150609.003127.1516615115859573912.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150609.003127.1516615115859573912.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 08.06.2015, Ryusuke Konishi wrote: 

> I succeeded to reproduce this issue on Fedora 20, 21, 22 and Debian
> jessie.  Also, I could narrow down the issue.

Thanks a lot for your effort!

> Here, the backup super block of /dev/sdb1 got detected also for
> /dev/sdb by the commit 5f77ce6f3269.

Just in case this matters, there is also a report from the util-linux
mailing list pointing to this particular commit:

http://permalink.gmane.org/gmane.linux.utilities.util-linux-ng/10766

> This change has been applied between v2.24 and v2.24.1 of util-linux,
> and not yet fixed in the mainline.

Ok, I'll try to identify and revert this commit in the meantime.

Thanks, Heinz.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
