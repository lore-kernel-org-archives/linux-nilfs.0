From: "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/5] nilfs-utils: skip inefficient gc operations
Date: Thu, 23 Jan 2014 15:57:37 -0500 (EST)
Message-ID: <alpine.LNX.2.11.1401231529460.5162@bpserver.ds>
References: <cover.1390310509.git.andreas.rohner@gmx.net> <52E05863.90604@gmail.com> <52E0EE08.3040703@gmx.net>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=yJLq6nMqC8KcXHVi3rovgE3CGwlWJJxP1DNT4+9+dMM=;
        b=mzJQ3WcOMFWdcYDr1+AKWNmwUstAJ8KQz4l8n7gHIyZjHcYKWOZ54ck3cjpAa6zn8o
         ynyqf4BJRJI3txMDPpR0Ne+b9PmAvfGYMyLNgBE8d4wpXIIeqIwN4G9VedsilydEIu6T
         FmkoBSXcHTPEMfneI1UNxs7I75bML8aexq+RAh14AoZAXBXcbQ6xUKVcOBXGuKUz+mKY
         XBffvG6TrIltszXy6IyF0YUScyWkipwKRANbECGmmY/fxb0iHHyHKMdyzBeyBkLZWhQu
         9pNEHoIeCJaVsl87XgF/SNVU+VQZNK7XhjCUHFHGNfFslXkmbO0oLaFT0OV9xYBX7fKN
         oR+A==
In-Reply-To: <52E0EE08.3040703-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: TEXT/PLAIN; format="flowed"; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 23 Jan 2014, Andreas Rohner wrote:

> Hi Michael,
>
> On 2014-01-23 00:46, Michael L. Semon wrote:
>> Not having your super-secret test suite or disk space to run it, I
>> went the other direction, using the commonly available fs_mark utility
>> to make many tiny writes with 16 threads.  My initial opinion is that
>> your new GC code fixes some obvious lag when a filesystem is populated
>> and nilfs_cleanerd starts to do its work.
>
> Thanks for testing my code. It is not a super-secret test suite :), it's
> just a few 100 lines of crappy C code I am embarrassed to publish.
> Thanks for pointing out fs_mark, I didn't know it. From what I can see
> it seems to be the perfect tool to test the GC. I will repeat my
> measurements with fs_mark over the weekend.

No problem, just making sure.  I had some code to zero random bits
on a partition, and I'll probably never post that in public, either.
It's just hard to verify conclusions based on tools that I don't have.

fs_mark is one tool of many.  That use of fs_mark came from trying to
figure out RAID-0 stripe sizes; the NILFS2 results were by accident but
reflect exactly what I'm seeing in prolonged normal use.  xfstests has
fsstress, fsx, and a few other special-purpose tools.  There's also
Flexible I/O Tester, but it's one of those cool scriptable testers
that are a bit beyond my needs.

>> However, for reasons of code
>> or simple mathematics, the file system hits end-of-space a bit earlier
>> than does the unpatched code.  I'll have to build some kernels, live
>> with the system, and otherwise generate lots of checkpoints to know if
>> this is a problem.  IOW, I need to find out for myself if I need to
>> make a slightly larger filesystem to do the same things using a patched
>> NILFS2.
>
> Maybe my default values are a bit too high. 256 blocks are about 1 MB
> with 4k blocks. So if you use the current default settings, you could
> potentially loose 1/8 of your free space.

As long as I can plan free space in advance, all is well, though 12.5%
is a little much.  I try to plan NILFS2 to where I can run it all
day without causing too much garbage collection, then run `mkcp -s`
and nilfs-clean as cron jobs in the middle of the night.

Thanks!

Michael

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
