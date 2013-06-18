From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 00/24] nilfs2: introduce debugging subsystem
 implementation
Date: Tue, 18 Jun 2013 13:43:30 +0400
Message-ID: <1371548610.2265.63.camel@slavad-ubuntu>
References: <1371471701.2075.129.camel@slavad-ubuntu>
	 <20130618.020235.402928744.konishi.ryusuke@lab.ntt.co.jp>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=K1o7Bt1TFFfobLdEQSa40huhXZfJ1Ptx3eCv8MZPox4=;
	b=hXh3ORUbgKUq4aa4aJDd8zaMiFiDnfozx7KhTh2faVGB3EH8OjR1Y5P7NNLWHdCAMydKIivZlN3QIKhStDYcSfEa0weBbEHZAlIEQ+E5lqagUGGRFhDc55at8uhvoTic;
In-Reply-To: <20130618.020235.402928744.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Ryusuke,

On Tue, 2013-06-18 at 02:02 +0900, Ryusuke Konishi wrote:

[snip]
> 
> Looks like you are trying to reinvent the wheel.
> 

I don't think so. :) But trying to reinvent the wheel is in background
of the technical progress at whole, from my viewpoint. And old way
doesn't mean bad way. :)

> Please consider using trace events kernel API (See
> Documentation/trace/events.txt and include/trace/events/xxxx.h etc),
> and do not try to add own debug/tracing framework.  With the trace
> events framekwork, you will be able to add flexible and switchable
> debug functionalities without abusing NILFS2_DEBUG_XXXX kernel options
> and printk variants.
> 

So, I suppose that I need to describe my vision and my intentions in
more details.

Yes, I agree that tracepoints framework should be used. But I think that
tracepoints framework is more suitable for performance analysis than for
investigation of an issue by means of debugging. Debugging and
tracepoints frameworks have different goals, from my understanding. So,
I think that NILFS2 should have as debugging as tracepoints
opportunities. The debugging framework can be used for gathering
information about an issue's environment on reporters' side and for deep
issue investigation. The tracepoint framework can be used for
performance analysis. And, moreover, I am thinking about adding
tracepoints into NILFS2 and I am going to do it.

The main goal of this patch set is to provide a simple way to gather
information about the issue on reporter's side. In my current approach
it is possible to ask a reporter about collecting additional details by
means of such simple steps: (1) Enable kernel configuration options for
necessary subsystems and debugging output opportunities; (2) Rebuild the
kernel; (3) Restart kernel and reproduce the issue; (4) Send content of
system log by e-mail. I think that such way is really simple and
efficient.

Ok, you dislike the way of using kernel configuration options for
subsystems and using printk variants. One of the suggested way of
debugging output in this patch set is using
pr_debug()/print_hex_dump_bytes() methods. The behaviour of these
methods are controlled via writing to a control file in the 'debugfs'
filesystem. So, you can configure in very flexible way what will be
printed out (please, see Documentation/dynamic-debug-howto.txt). As a
result, it is possible to use only pr_debug()/print_hex_dump_bytes()
instead of printk() variants. Moreover, most of the suggested kernel
configuration options will be not necessary in such case.

This patch set suggests such debugging output opportunities: (1) output
with information about internal errors; (2) output with current values
of variables/function arguments; (3) output with hexdumps of on-disk or
in-core data structures; (4) dump stack output.

I think that information about internal errors that takes place in
NILFS2 driver is very important output. Such information can provide a
clue for understanding a possible reason of an issue and a way of
further investigation. But information about internal errors is
preliminary and rough knowledge that can be used for localization of the
error. So, from my point of view, it doesn't make sense to restrict such
output by any subsystem. As a result, I use simple printk() for this
output.

Debugging output and hexdump output are very important information also.
These outputs should be made by pr_debug()/print_hex_dump_bytes(), from
my point of view. I think that dump stack can be useful information in
some situations. But if it will be used only dynamic version of printk()
then flags of for subsystems will be unnecessary. As a result, there
isn't opportunity for restricting of the dump stack output.

So, as a resume, I think that NILFS2 needs in debugging subsystem and
tracepoints subsystem. It is a complementary subsystems, from my
viewpoint.

With the best regards,
Vyacheslav Dubeyko.

> As I usually comment to you, start small, with a simple but powerful
> change, and try to keep your patchset as simple as you can.

> Regards,
> Ryusuke Konishi
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
