From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Kernel Bug: unable to handle kernel paging request
Date: Mon, 22 Jul 2013 15:11:42 -0400
Message-ID: <CALJXSJrj0J_-ZUCOurJXaYhx_wEJwxb2_5OOJjQSSmmP-PQDgg@mail.gmail.com>
References: <CALJXSJquK6YxGKuH97Ec2CTMyJaZrJjOfePSKtgPDm8_9YXzzw@mail.gmail.com>
	<CALJXSJoW9Qpp9t42u_k4cW3gO6qzSPoeCjtQDU3tDKq6TJ=K8Q@mail.gmail.com>
	<F4156394-8A25-4F81-81C3-9921CB00BD92@dubeyko.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=iXLFBdrBYNdRwZhz3jykDJKzLi2Y8FuJSnU7lFFiAqM=;
        b=Kmb2hDRenuvq+YTyJAfVSdFrhrzUyzPRkQrm4SO/ULgd6ir3/vDezmrqvFDLIYHERb
         56F3ax83pTLeiBFzLammIFaSwoMUk0pp/p7ZrzWfxLEx349vB6xMp3jNz1dmHViMH9Gt
         /vATbGO7WP+5PwGaYeDlpc5SigDgmqnBJNT+dajBHUHA9wm0NEQsHRmABl3GlqUT6b7k
         U/5p5BBCDV8A5IEc3nbkBEMgBNLM48su91YUUrilGjtSyXKSfo2OQ1OLepPBiQyucucG
         98T4cXoK03G6GfVTWawVTSGNnq0xtB3gVXvUiyFwS1WRWGAe3pA+chQkPnJzZ9C0xrQ1
         gT8A==
In-Reply-To: <F4156394-8A25-4F81-81C3-9921CB00BD92-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jul 18, 2013 at 1:30 PM, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote:
>
> > The problem happened again today after resume, it seems to be more
> > frequent since last week. Here is a pastebin of the traceback +
> > sysrq+W.
> >
> > http://pastebin.ca/2426059
> >
>
> Unfortunately, currently I haven't access to this share.

I'm back using my laptop but wasn't able to reproduce it again, it is
not as easy as it was before to reproduce, sometimes apt-get update
works, sometimes it freezes. Here is a different paste bin as
pastebin.ca seems to be down for some time now:
http://pastebin.com/ALmuHdfh

> So, as I see, the reproducing path is: (1) delete /var/cache/apt; (2) issue apt-get update.

In fact it is the other way around;
(1) Issue apt-get update: Crash.
(2) Reboot, try again: Crash.
(3) Delete /var/lib/apt/lists/* and try again: Works for some time.


> (1) The strace output for the case of issuing the apt-get update (in the case of issue reproducing).

That will be hard to obtain except maybe if I alias my apt-get update
to strace -f -o /boot/somefile.txt apt-get update and hope the problem
occur again. It sometimes happen when launched from the Ubuntu Store
which doesn't use bash to launch the update.

> (2) I need more details about your NILFS2 partition. Could you share output of "nilfs-tune -l"?

$ sudo nilfs-tune -l /dev/vgUbuntu/root
nilfs-tune 2.1.4
Filesystem volume name:  root
Filesystem UUID:  336f247d-c8d1-4e91-887a-258121c4face
Filesystem magic number:  0x3434
Filesystem revision #:  2.0
Filesystem features:      (none)
Filesystem state:  invalid or mounted
Filesystem OS type:  Linux
Block size:  4096
Filesystem created:  Thu Apr 11 22:34:29 2013
Last mount time:  Mon Jul 22 13:35:46 2013
Last write time:  Mon Jul 22 15:06:02 2013
Mount count:  86
Maximum mount count:  50
Reserve blocks uid:  0 (user root)
Reserve blocks gid:  0 (group root)
First inode:  11
Inode size:  128
DAT entry size:  32
Checkpoint size:  192
Segment usage size:  16
Number of segments:  25599
Device size:  214748364800
First data block:  1
# of blocks per segment:  2048
Reserved segments %:  5
Last checkpoint #:  3229012
Last block address:  17242181
Last sequence #:  136170
Free blocks count:  17827840
Commit interval:  0
# of blks to create seg:  0
CRC seed:  0x7ab1d7ed
CRC check sum:  0xfab54710
CRC check data size:  0x00000118
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
