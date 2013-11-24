From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Filesystem error causes nilfs_btree_do_lookup to trigger cpu soft lockup
Date: Sun, 24 Nov 2013 18:17:28 +0300
Message-ID: <CE0CC383-21F3-4F89-BB19-2963DD4A3B81@dubeyko.com>
References: <52841CE5.6030009@intellitree.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=1TQZ6G/BzYMwVqAjtBjID8TEGC29ivQU3t0TCxuDGn8=;
	b=rDBAqQ5ncRzew1MEoDdrGd9y/tHWWngKorsNi8mAloloGs1iIPgAN9cirx57Ennry9BY1SKILZkeYdRagar6rH1GLR6GkCVA44dtFTcg4VNGdcROcTIAiZZ61oUAMRQg;
In-Reply-To: <52841CE5.6030009-HsDW+lVSy7tZ66HEZ9PjWw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michael Conrad <mconrad-HsDW+lVSy7tZ66HEZ9PjWw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Michael,

On Nov 14, 2013, at 3:44 AM, Michael Conrad wrote:

> Hi, using Nilfs in kernel 3.2.12, I started running into errors after about a week of steady use.  On the system where this happened, it didn't behave very well; the kernel's watchdog detected a soft-lockup after 23 seconds and rebooted the system.  I had it mounted with "-o errors=continue".
> 
> I moved the drive to a different system, and mounted it (with errors=remount-ro), and read the problem files, and got I/O errors in user-land (as I might expect) but it didn't hang up the kernel or trigger a soft-lockup.
> 
> After some reading, I now understand that errors=continue might not be the best idea.  Also, the soft-lockup is detected after 20 seconds, which is maybe too narrow of a window?
> 
> But, I wanted to post here and see if you recognized a bug that was already fixed in a newer kernel, or if it inspires ideas of how to prevent soft-lockups (by putting limits on scanning functions, or something).  Also, I've decided I should at least upgrade to kernel 3.2.52, but do you know if I need to go newer than that, to avoid known bugs?
> 
> Below is the output of "log" on the crash utility, from my vmcore.
> 

Thank you for the issue report.

But anyway I need to understand a reproducing path of the issue.
Could you describe the reproducing path?
I can't investigate the issue without clear understanding of the reproducing
path and how stably it is possible to reproduce it.

Thanks,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
