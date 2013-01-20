From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: nilfs_cleanerd wont run after 3.7.2 upgrade
Date: Sun, 20 Jan 2013 13:42:19 +0300
Message-ID: <3859090E-3011-4A3A-A15B-0569EFEED0B9@dubeyko.com>
References: <CACc=JvH81x9hUqGmn7b-sYuu0UhQpVBnOCSOjtZfDNhK0s-F8Q@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=hinWmHcp598YA9yJJj2viNGPMTEjvbf8p8sWa99bb24=;
	b=WUzBLSkfo247tvGE5VuxRNm34a2dBSeRe95kEaUT/YGZ4+9LRfP3C7IYjUA8l00NHAt9ewpA59GC+ESNZL2oPqlzdQ2eDuvK06osqBnSMNhVQhhqCtN4rPapqcwSAOu/;
In-Reply-To: <CACc=JvH81x9hUqGmn7b-sYuu0UhQpVBnOCSOjtZfDNhK0s-F8Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tim Benham <tim.j.benham-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tim,

On Jan 20, 2013, at 9:51 AM, Tim Benham wrote:

> After upgrading from the 3.5.0 to the 3.7.2 kernel I cannot get
> nilfs_cleanerd to start. Trying to start it causes the following lines
> to be appended to the system log.
> 
> Jan 20 16:36:07 gigasys nilfs_cleanerd[2584]: start
> Jan 20 16:36:07 gigasys nilfs_cleanerd[2584]: cannot open nilfs on
> (null): No such file or directory
> Jan 20 16:36:07 gigasys nilfs_cleanerd[2584]: cannot create cleanerd
> on (null): No such file or directory
> Jan 20 16:36:07 gigasys nilfs_cleanerd[2584]: shutdown
> 
> My root file system is nilfs2. Cleanerd has never started on mount. I
> worked around this by creating a local.d script that starts it. Then
> this stopped working. I was able to get it going again by modifying my
> script to create a /dev/root symlink. Now I cannot get it to start at
> all. Giving it the root device explicitly doesn't work either
> 
> 
> # nilfs_cleanerd /dev/sda2
> Jan 20 16:41:19 gigasys nilfs_cleanerd[2648]: start
> Jan 20 16:41:19 gigasys nilfs_cleanerd[2648]: cannot open nilfs on
> /dev/sda2: No such file or directory
> Jan 20 16:41:19 gigasys nilfs_cleanerd[2648]: cannot create cleanerd
> on /dev/sda2: No such file or directory
> Jan 20 16:41:19 gigasys nilfs_cleanerd[2648]: shutdown
> # ls -l /dev/sda2
> brw-rw---- 1 root disk 8, 2 Jan 20 16:18 /dev/sda2
> 
> mount -t nilfs2 -o remount /dev/sda2 / produces an identical set of messages.

It looks like you have troubles with udev after upgrade. Could you share strace output of nilfs_cleanerd trying to start? Could you share fstab file content on your system?

With the best regards,
Vyacheslav Dubeyko.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
