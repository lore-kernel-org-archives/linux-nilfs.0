From: Viacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [!] Unable to mount nilfs2 filesystem after power outage -
 error loading super root.
Date: Fri, 18 Mar 2016 14:36:54 -0700
Message-ID: <1458337014.2615.14.camel@slavad-ubuntu-14.04>
References: <56EC45FD.7010808@gmail.com>
	 <1458331991.2615.6.camel@slavad-ubuntu-14.04> <56EC67A2.8050905@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cF6dXnmRWrF6UJ6Um0T6HsFqqoRI1IfRO1aWX0L++5Q=;
        b=R+BqI+L9f2F/lx9ZChnxotLZhqEcsUG0vDO2IxPxQWtA5w2Oj0xeoUuXC99+tZWgP0
         f1U8u2LywTaunNGwdLojnTYGpZXOlFiCVpnumPl2xTG49z30Tyt2plurM9jy4RTjVV7c
         cI//PwvtcqY20ojazPiSh3gBOFYwp1pDY+uWfG9SriuKzFnjz2OEGZDuqH3ct+SFR+d0
         RF4KTFCW328orj8+wvsdFme3wAHy+/O9hCoV+JOie1oXDyQelD/Pjqt2pRN0Wa28g+E+
         pd17iSWc706lNTPRav1DEvMblmayhghwc9ojkUaxODIewua1n2/F/uCgkImfdASe+eA9
         o+rQ==
In-Reply-To: <56EC67A2.8050905-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KARBOWSKI Piotr <piotr.karbowski-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 2016-03-18 at 21:40 +0100, KARBOWSKI Piotr wrote:
> Hi,
> 
> On 03/18/2016 09:13 PM, Viacheslav Dubeyko wrote:
> > On Fri, 2016-03-18 at 19:16 +0100, KARBOWSKI Piotr wrote:
> >> Hi,
> >>
> >> Yesterday I had an power outage. After booting my notebook again, I was
> >> no longer able to mount /home that was on the top of nilfs2 filesystem.
> >>
> >> I've come across a post from 2011 about fsck in git.nilfs.org but that
> >> repo is no longer accessable. The repo from githab does not have any
> >> trace of the experimental fsck tool thus I've dumped the filesystem to
> >> image, recreated ext4 and restored backup.
> >>
> >
> > NILFS2 hasn't fsck utility. And no implementation efforts exist.
> 
> I was refering to http://marc.info/?l=linux-nilfs&m=130799952525081&w=2
> 

You could check this link
http://nilfs.sourceforge.net/en/current_status.html
The fsck tool is still in TODO list.

> >> The symptoms:
> >>
> >> # mount -o loop ./kurogane_ssd-home.17.03.2016.img /mnt/tmp
> >> mount.nilfs2: Error while mounting /dev/loop/0 on /mnt/tmp: No such file
> >> or directory
> >>
> >> # dmesg
> >> [ 9591.626210] NILFS warning: mounting unchecked fs
> >> [ 9591.824166] NILFS: error loading super root.
> >>
> >
> > Do you have any NILFS2 related errors before mount operation in your
> > syslog? Does strace show something interesting for mount operation?
> 
> Nothing special. Right now all I have is a image of the filesystem, and 
> just the two lines are printed when I try to mount it. Strace does not 
> provide anything useful
> 
>      mount("/dev/loop/1", "/mnt/tmp", "nilfs2", MS_MGC_VAL, NULL) = -1 
> ENOENT
> 

It needs to dive into state of the volume. You can use lscp and lssu
tools with the goal to retrieve segments and checkpoints state. But,
again, this path could provide opportunity for understanding the bug
essence and environment. I could see only one way for "recovering"
corrupted volume: (1) understand the current state of volume's segments;
(2) localize erroneous segment; (3) try to zero erroneous segment(s) by
means of dd utility; (4) try to mount again. But it's really dangerous
way, you could loose your data.

Thanks,
Vyacheslav Dubeyko.



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
