From: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [kbuild] nilfs2: fix issue with flush kernel thread after
 remount in RO mode because of driver's internal error or metadata corruption
Date: Thu, 25 Apr 2013 22:00:22 +0800
Message-ID: <20130425140022.GD7397@localhost>
References: <20130425074947.GB11880@elgon.mountain>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130425074947.GB11880-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org, kbuild-JC7UmRfGjtg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Apr 25, 2013 at 10:49:47AM +0300, Dan Carpenter wrote:
> [ It's weird that kbuild didn't catch this ].

Sorry about that! I made a big change in the test scripts and took
several days to fixup the new bugs. Quite some branches missed the
tests during the time..

Thanks,
Fengguang
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
