From: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Subject: Re: Nilfs2 crash debugging
Date: Wed, 04 Sep 2013 21:39:15 +0200
Message-ID: <52278C63.6090303@antoneliasson.se>
References: <51F2A8A4.4020400@antoneliasson.se>   <51F2A945.6050909@antoneliasson.se>   <9016EBD5-1E01-476F-B1B9-66AE593F4728@dubeyko.com>   <520CB032.2000602@antoneliasson.se>   <FEA41B6A-7D82-4563-AAF5-D5AFA3734D79@dubeyko.com>   <521A1C88.9080100@antoneliasson.se>  <1377510966.2621.3.camel@slavad-ubuntu> <521BA084.80901@antoneliasson.se> <1377842333.2343.25.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1377842333.2343.25.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Vyacheslav Dubeyko skrev 2013-08-30 07:58:
> On Mon, 2013-08-26 at 20:37 +0200, Anton Eliasson wrote:
>
>>>
>> You're welcome. And thank you for your thorough instructions. It's been
>> very informative and worthwhile for me to patch and build a kernel with
>> custom options. Let me know if you need more experiments run on the
>> damaged filesystem. Otherwise I'll delete the stored disk images in a
>> month or two.
>>
> As I remember, you reproduced the issue by means of starting of two
> virtual machines. I think that I will try to reproduce the issue by this
> way. But I am investigating the another issue currently and,
> unfortunately, I haven't opportunities for investigating this issue in
> parallel.
>
> I don't fully confident that it is possible to do it. But, does it
> possible to collect strace output of virtual machines starting for the
> case of reproduced issue? What do you think? You have shared kernel log
> for the reproduced issue case, currently. But strace output can give
> interesting details from the user-space point of view.
>
> Thanks,
> Vyacheslav Dubeyko.
>
>
I spent about an hour trying to reproduce this today. I built Linux 
3.10.10 using your patches from June. The patch command reported some 
offsets and fuzz so it seems that the nilfs driver has changed since the 
last kernel version. I don't know if the updates affect this bug. With 
this new cusom kernel, everything I/O related ran very slowly. The nilfs 
garbage collector used 100 % CPU constantly. Killing it sped things up a 
little.

I started and stopped the virtual machines a few times, with reboots in 
between. Eventually the system tried to touch some corrupted parts of 
the virtual machine image and /home remounted read-only. At that point I 
gave up. I doubt the strace output will help you but I uploaded it here 
[1] anyway. VMware Workstation is a complex application that consists of 
many executables. Some are run directly by the user, some as system 
services and some as kernel modules. Picking the right place to stick 
the multimeter probe is probably difficult.

Unfortunately I forgot to install syslog-ng today and my instance of 
systemd is not configured to log verbosely enough to capture the kernel 
debug output. So no kernel.log for today. This is all starting to feel 
like a waste of time for me as I don't even use nilfs on any of my 
machines anymore. I'm going to withdraw my offer to debug these issues 
any further. Sorry. I hope you have gathered enough information to solve 
them and I wish you the best of luck.

[1]: http://antoneliasson.se/publicdump/vmware-strace.log.gz

-- 
Best Regards,
Anton Eliasson

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
