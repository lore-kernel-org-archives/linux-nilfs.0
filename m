From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: A lot of NILFS: bad btree node messages (readonly fs)
Date: Wed, 09 Jan 2013 16:10:29 +0400
Message-ID: <1357733429.2101.41.camel@slavad-ubuntu>
References: <20121129210650.GA4028@wloczykij>
	 <1354255744.2090.3.camel@slavad-ubuntu> <20121130073219.GB4028@wloczykij>
	 <1356415552.2052.11.camel@slavad-ubuntu> <20130103214913.GE2080@wloczykij>
	 <28ABE57F-66DD-491E-9FDB-A6CE3CF773FB@dubeyko.com>
	 <20130104191633.GF2080@wloczykij>
	 <C2F4A5DE-538B-4468-9A6A-BA619EDDA462@dubeyko.com>
	 <20130105164752.GG2080@wloczykij>
	 <504C0292-D0C6-426C-BDFD-1CD50FB32617@dubeyko.com>
	 <30D452FB-F1A5-425C-97ED-1A12CA4DCFD9@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=sHU8+puAym2ntWcVrGHCXXcoL45Cpvp5TbyPV/yxTI8=;
	b=i5fYlBt5jQWntZOxhFonWLVnryngYBLnSMFp0nqHzt29Ozs79pClKK8dIjUgGzq+QBJ/Rr6GHxmYVx1g6A+u5qBe13rWQzmwlGytjKrnYyzOrorWZAcMshmogu6C5B/M;
In-Reply-To: <30D452FB-F1A5-425C-97ED-1A12CA4DCFD9-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Elmer Zhang <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>, =?UTF-8?Q?=D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9_?= =?UTF-8?Q?=D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE?= =?UTF-8?Q?=D0=B2?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 2013-01-09 at 14:20 +0800, Elmer Zhang wrote:
[snip]
> 
> > 6. I understand that it can be not so easy. But, anyway, could you share details of your system log for the case of first case of the issue occurrence? I need only details about how live system before the issue.
> > 
> 
> I found some backtrace in syslog: http://d.pr/n/ddZd
> 

Thank you for additional details. It is very helpful for me.

So, I have a picture of the situation on your system after analyzing
your system log.

First of all, as I can see, you have many regular error messages about
page allocation failure:

Dec 24 12:24:11 yf237 kernel: swapper: page allocation failure. order:1, mode:0x20

As I understand, you have incorrect memory subsystem configuration or
issue with NIC driver. Do you have e1000 NIC? As I can see after surfing
in the internet the reason of it can be a NIC's driver issue or
configuration of vm.min_free_kbytes. It recommends to enhance the value
of vm.min_free_kbytes = 65536. Could you share details of your virtual
memory configuration? You can find different details of your
configuration in /proc/sys/vm (especially, I need to know
vm.min_free_kbytes). I suspect that I need to decrease this value on my
system for issue reproducing.

Secondly, as I can see you have regular troubles with page allocation
failures from:

Dec 24 12:24:11 yf237 kernel: <IRQ>  [<ffffffff8112405f>] ? __alloc_pages_nodemask+0x77f/0x940

till:

Dec 27 04:06:11 yf237 kernel: <IRQ>  [<ffffffff8112405f>] ? __alloc_pages_nodemask+0x77f/0x940

Then your system was suddenly power-off. I think so because I can't see
message about nilfs_cleanerd shutdown before new system start that was
in:

Dec 27 11:16:29 yf237 kernel: Linux version 2.6.32-220.13.1.el6.x86_64 (mockbuild-ktcNWDX7ZkcnYXo6ltff2qQZW8Oz2YPi@public.gmane.org) (gcc version 4.4.6 20110731 (Red Hat 4.4.6-3) (GCC) ) #1 SMP Tue Apr 17 23:56:34 BST 2012

And then we have:

Dec 27 11:32:34 yf237 kernel: NILFS warning: mounting unchecked fs
Dec 27 11:32:34 yf237 kernel: NILFS: recovery complete.
Dec 27 11:32:34 yf237 kernel: segctord starting. Construction interval = 60 seconds, CP frequency < 30 seconds
Dec 27 11:32:34 yf237 kernel: NILFS warning: mounting fs with errors

This means that we mounted filesystem that was not unmounted cleanly.

Finally, I can see such messages:

Dec 27 14:03:50 yf237 kernel: INFO: task nilfs_cleanerd:5046 blocked for more than 120 seconds.
Dec 27 14:03:50 yf237 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[snip]
Dec 27 14:03:50 yf237 kernel: INFO: task mysqld:4379 blocked for more than 120 seconds.
Dec 27 14:03:50 yf237 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[snip]
Dec 27 14:03:50 yf237 kernel: INFO: task mysqld:4380 blocked for more than 120 seconds.
Dec 27 14:03:50 yf237 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[etc...]

These messages means that you have encounter issue with flush kernel
thread. This issue was reported firstly before the report about
discussed here issue. I achieved such messages after deleting some big
file and executing sync command when I can see flush kernel thread that
eats 100% CPU time.

So, currently, I think that the reason of the issue can be issue with
flush kernel thread with adding some incorrect virtual memory subsystem
configuration (that lead into page allocation failure). These two
reasons can summarize in corruption metadata in memory pages that
flushed on the volume as a result or not flushed properly.

As a resume, I need to fix issue with flush kernel thread (I can
reproduce in easily). And, anyway, I need to try to reproduce this issue
also.

With the best regards,
Vyacheslav Dubeyko.

> > 7. I analyzed the raw dump of segment that I received from Elmer Zhang. Currently, I have such feeling that it takes place situation when driver tries to take block that was filled by GC yet. But it needs to investigate the issue more deeply. And, currently, I don't understand how the issue can be achieved. Successful reproducing of the issue is a half of the success.
> > 
> > Thanks,
> > Vyacheslav Dubeyko.
> > 
> 
> ---
> Elmer Zhang
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
