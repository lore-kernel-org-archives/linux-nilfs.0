From: KARBOWSKI Piotr <piotr.karbowski-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [!] Unable to mount nilfs2 filesystem after power outage - error
 loading super root.
Date: Fri, 18 Mar 2016 23:14:38 +0100
Message-ID: <56EC7DCE.1020906@gmail.com>
References: <56EC45FD.7010808@gmail.com>
 <1458331991.2615.6.camel@slavad-ubuntu-14.04> <56EC67A2.8050905@gmail.com>
 <1458337014.2615.14.camel@slavad-ubuntu-14.04>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=hNNUjSSLAa3tuqVI1Icr1mPao3IbF9sPuBqlKBwBtIw=;
        b=j8fm0CZK+oDzcJlYrdtEWg595dxYfIkWju64YmjAvSGvFxd2UXDyFAIYAkyND3mLfv
         M+iRXaLHcvnfxUapMZ2ogegzblKIYNtR2gPNQAuMc6Ikae6Hby6YEzWy/Z5hfvnzwDic
         CU4HEuydbXVJ/BtPsHif7iR1SKRbmOWEvl+4kAuUsvaSsg8qVxnsvGNmyv/sjj8bUai9
         +kQuBcuHnq1y66wJpZQWNWUAtDBeoufb50WbN0V7lHyQLcOBpB3jl4QqFGxUT6DENGza
         9MK07Cj1f9DPVHooSDEobrFDBv/1htmIRR2nY2j0+BvJiX10vsI/I9xVbDydKVA/TrU6
         P/BQ==
In-Reply-To: <1458337014.2615.14.camel-dzAnj6fV1RzTdvqWZYKEhEEK6ufn8VP3@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Viacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On 03/18/2016 10:36 PM, Viacheslav Dubeyko wrote:
> It needs to dive into state of the volume. You can use lscp and lssu
> tools with the goal to retrieve segments and checkpoints state. But,
> again, this path could provide opportunity for understanding the bug
> essence and environment. I could see only one way for "recovering"
> corrupted volume: (1) understand the current state of volume's segments;
> (2) localize erroneous segment; (3) try to zero erroneous segment(s) by
> means of dd utility; (4) try to mount again. But it's really dangerous
> way, you could loose your data.

I could try, but lscp and lssu does not work with this filesystem since 
crash. Only 'nilfs-tune -l' display anything.

# strace lssu /dev/loop/1 2>&1 | grep loop
execve("/usr/bin/lssu", ["lssu", "/dev/loop/1"], [/* 61 vars */]) = 0
readlink("/dev/loop", 0x7ffe6a073ac0, 4096) = -1 EINVAL (Invalid argument)
readlink("/dev/loop/1", 0x7ffe6a073ac0, 4096) = -1 EINVAL (Invalid argument)
readlink("/dev/loop", 0x7ffe6a073ac0, 4096) = -1 EINVAL (Invalid argument)
readlink("/dev/loop/1", 0x7ffe6a073ac0, 4096) = -1 EINVAL (Invalid argument)
write(2, "lssu: cannot open NILFS on /dev/"..., 66lssu: cannot open 
NILFS on /dev/loop/1: No such file or directory

Does lscp and lssu needs actually mounted filesystem? It does run 
readlink() and check /proc/mounts...

-- Piotr.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
