From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Nilfs (kernel 3.2.52) frozen mountpoint after USB disconnect
Date: Sun, 24 Nov 2013 18:10:58 +0300
Message-ID: <6330B150-83E6-403D-A5F6-8E238BF3DBEE@dubeyko.com>
References: <528BA5AF.2080007@intellitree.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=fI9gISQ/9VG3LZ4DCnIVfKi5wYqb2GmVPk5s/FZ2nOI=;
	b=VxQ4EevSNPSYVQtzd7VPIrvVoNh/KJYorAKJMWFuM14TWC4MB2hEPRWiFonyJb7VHFZc6DGfcoU5Kn0lZf6XjiU8hNDMB+05ylYNwXsLyRK9eaIjy8b9yYmDSAEFe/CS;
In-Reply-To: <528BA5AF.2080007-HsDW+lVSy7tZ66HEZ9PjWw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michael Conrad <mconrad-HsDW+lVSy7tZ66HEZ9PjWw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Michael,

On Nov 19, 2013, at 8:53 PM, Michael Conrad wrote:

Sorry, I were in business trip and I haven't access to my e-mail.

> Hi, its me again.
> 
> I've upgraded my systems to 3.2.52 (direct from kernel.org, no gentoo patches any more), and haven't had a reboot since.  However, I just ran into a new problem where a power glitch caused an external USB drive to reset, and the nilfs kernel module didn't handle it well.  The mount point is frozen, and any process that accesses it freezes and can't be killed even with kill -9.  It was mounted with default mount options.
> 
> I've attached the complete kernel log from the time the USB device disconnected.  It ends with "Kernel Bug,  invalid opcode 0000" in nilfs_btnode_prepare_change_key.
> 
> The system is still running and doing fine other than this, and "umount -l" worked to remove it from the filesystem so that more processes don't get stuck.  However, this project I'm working on has used up a lot more time than I expected, and I'll have to try a different filesystem if I can't get it working reliably, soon :-( Would you like any additional debugging info?
> 

Thank you for the issue report.

So, I need in reproducing path for investigating of the issue.
Can you reproduce the issue stably on your side?
Could you describe reproducing path for me?
What workload do you have during power glitch and USB drive reset?
Could you describe your environment in more details?

Thanks,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
