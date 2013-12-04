From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] nilfs2: rework error message subsystem
Date: Wed, 04 Dec 2013 10:33:07 +0400
Message-ID: <1386138787.4014.17.camel@slavad-ubuntu>
References: <1385993333.3945.3.camel@slavad-ubuntu>
	 <20131203162944.8f9ef3a08a3292a1959dd025@linux-foundation.org>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=kWZu1xK3K2ZLajs4Xrouw9T299SvftpqL6ne+aMOfbQ=;
	b=cGstAq78Qg0EFrvdMej+U/RUY3kPAA8kEFWddW6gdqxzUK3RTG/HPePYrMmyAIhksJAkAythi3cweHJbKbimcdOQTBEzYXTU2TuIp/6+gq6xowZ38dK2+6gKGBZ6GB+a;
In-Reply-To: <20131203162944.8f9ef3a08a3292a1959dd025-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Michael Conrad <mconrad-HsDW+lVSy7tZ66HEZ9PjWw@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, 2013-12-03 at 16:29 -0800, Andrew Morton wrote:

[snip]
> 
> It converts every printk in nilfs2 into pr_foo_ratelimited (and bloats
> nilfs2.ko by 5k in the process).  Isn't this rather overkill?
> 

I have converted not every printk() in nilfs2 but I agree that printk()
was changed in many places by ratelimited version. So, yes, it can be
not very good idea. But such replacement was made for code that can emit
really many count of practically identical error messages. And there are
situation of sophisticated issues in nilfs2 when huge amount of error
messages simply hide an important information about the issue. As a
result, my goal was to reduce amount of repeatable error messages.

So, what could you recommend as possible and proper solution?

Moreover, I cleaned up error messages subsystem of nilfs2 by change of
printk on pr_foo version and by joining error strings that it was split.
I believe that it makes sense. Of course, it is possible to leave nilfs2
error subsystem untouched. But from my point of view, there is the issue
of hiding important information about an issue's reason by huge amount
of repeatable error messages.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
