From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Nilfs2 crash debugging
Date: Thu, 5 Sep 2013 00:00:14 +0400
Message-ID: <5F100CD4-56F8-4F0F-84CA-7A9CA525DA59@dubeyko.com>
References: <51F2A8A4.4020400@antoneliasson.se>   <51F2A945.6050909@antoneliasson.se>   <9016EBD5-1E01-476F-B1B9-66AE593F4728@dubeyko.com>   <520CB032.2000602@antoneliasson.se>   <FEA41B6A-7D82-4563-AAF5-D5AFA3734D79@dubeyko.com>   <521A1C88.9080100@antoneliasson.se>  <1377510966.2621.3.camel@slavad-ubuntu> <521BA084.80901@antoneliasson.se> <1377842333.2343.25.camel@slavad-ubuntu> <52278C63.6090303@antoneliasson.se>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=9N51EIR46qPeAoXP6j4EF9/1O5L20MGKODb7tmO6yw8=;
	b=Dd3CnCBxKgE9Nuhe7Qg14RQUZ+WRF2jGCjy7T2eclggYpG5f6rmgHvrpAhadFHrmBeBbMcVrdo3ogiZGmnkCJ+rQ7fxSTdg3DdkB1TWvMl5lBc3mHc1Y98zKQ0xhrCDw;
In-Reply-To: <52278C63.6090303-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Anton,

On Sep 4, 2013, at 11:39 PM, Anton Eliasson wrote:

[snip]
>> 
> I spent about an hour trying to reproduce this today. I built Linux 3.10.10 using your patches from June. The patch command reported some offsets and fuzz so it seems that the nilfs driver has changed since the last kernel version. I don't know if the updates affect this bug. With this new cusom kernel, everything I/O related ran very slowly. The nilfs garbage collector used 100 % CPU constantly. Killing it sped things up a little.
> 
> I started and stopped the virtual machines a few times, with reboots in between. Eventually the system tried to touch some corrupted parts of the virtual machine image and /home remounted read-only. At that point I gave up. I doubt the strace output will help you but I uploaded it here [1] anyway. VMware Workstation is a complex application that consists of many executables. Some are run directly by the user, some as system services and some as kernel modules. Picking the right place to stick the multimeter probe is probably difficult.
> 
> Unfortunately I forgot to install syslog-ng today and my instance of systemd is not configured to log verbosely enough to capture the kernel debug output. So no kernel.log for today. This is all starting to feel like a waste of time for me as I don't even use nilfs on any of my machines anymore. I'm going to withdraw my offer to debug these issues any further. Sorry. I hope you have gathered enough information to solve them and I wish you the best of luck.
> 
> [1]: http://antoneliasson.se/publicdump/vmware-strace.log.gz
> 

Thank you for your efforts.

I think that I have discovered the reason of all issues that you were reported.
I posted the patch ([PATCH] [CRITICAL] nilfs2: fix issue with race condition
of competition between segments for dirty blocks) in Monday. Currently, this
patch is under discussion. So, I hope that NILFS2 will be more stable.

Anyway, your reports were very important for finding the reason of issues
and fix elaboration.

Thanks,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
