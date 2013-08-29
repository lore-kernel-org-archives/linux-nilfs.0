From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Cleaner won't start
Date: Thu, 29 Aug 2013 19:47:23 -0400
Message-ID: <CALJXSJrsGhW4noeXpwnpco_W1mS4DVEfdcc-pvipQJ5fsir=qA@mail.gmail.com>
References: <CALJXSJq9DR6tapLRvq3rZGFsne-CUriruGAyzgO7pAB9ESe-bA@mail.gmail.com>
	<1377511770.2621.11.camel@slavad-ubuntu>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=yUlIX3jmzG0Bu6KU2OQxgD00+4ity7ub8DWttD4zOOs=;
        b=JSXLYIalhYNzPMnmwRkK3STjSlYJyQVrL+BvzNgJc0Y5FAfiJfIRnw0LlRAnxvH5uw
         EXy0eHDYfb4YXP2YRpLmM6PSaORTuI5C3CFmzA7kfjqPAOlF2ORfYZ0UiaCM4L2xXecT
         egJ+ikP/t/haIFQhAkgwtAY8LruDSylXVZnVO15utCGHjI3NGFre1QUUBZQziGMfmNOe
         r6Ap3Drrp7wEufgCOPcWVYstwMA/4EWjPT/jQi4sWROxN2FGdFIFFgKYmM5TD0oloUmZ
         VcyOPAmY4qW1Yrh0adSA0+fYJTwTuhvHLdEdWk9N2ujWjek5NRhUcz+jCIuBYPj5cvRZ
         /ryw==
In-Reply-To: <1377511770.2621.11.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Aug 26, 2013 at 6:09 AM, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote:
> As I remember, one of the report is contained such error message. But I
> can't recollect in what environment such error message was.
>
> I suspect that it is a sequence of the problem that it was more earlier.
> Did you have any NILFS2 error messages in your system log earlier? Or,
> maybe, do you try to use NILFS2 volume after getting some NILFS2 issue
> earlier?

I continued using the volume daily as the issue only popped out when
using apt-get, so I was safe for the rest. Now I migrated to ext4 to
get my laptop working, I was able to succesfully rsync all the data on
a new volume and keep the NILFS2 volume archived.

Earlier logs:
Aug 23 22:08:50 JeromeCauca nilfs_cleanerd[2369]: start
Aug 23 22:08:50 JeromeCauca nilfs_cleanerd[2369]: pause (clean check)
First time it happened was there:
Aug 24 03:59:10 JeromeCauca nilfs_cleanerd[2369]: resume (clean check)
Aug 24 03:59:40 JeromeCauca kernel: [21196.506395]
nilfs_ioctl_move_inode_block: conflicting data buffer: ino=76070,
cno=3769693, offset=0, blocknr=46096310, vblocknr=4731085
Aug 24 03:59:40 JeromeCauca kernel: [21196.506425] NILFS: GC failed
during preparation: cannot read source blocks: err=-17
Aug 24 03:59:40 JeromeCauca nilfs_cleanerd[2369]: cannot clean
segments: File exists
Aug 24 03:59:40 JeromeCauca nilfs_cleanerd[2369]: shutdown

I don't have anything earlier than August 21st and not any other log
has "nilfs" in them.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
