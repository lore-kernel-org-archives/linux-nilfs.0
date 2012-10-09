From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Wed, 10 Oct 2012 01:24:40 +0900 (JST)
Message-ID: <20121010.012440.17932600.konishi.ryusuke@lab.ntt.co.jp>
References: <20121009105239.GV28032@wloczykij>
	<1349784514.1921.9.camel@slavad-ubuntu>
	<20121009135833.GX28032@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121009135833.GX28032@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org
Cc: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Tue, 9 Oct 2012 15:58:33 +0200, Piotr Szymaniak wrote:
> On Tue, Oct 09, 2012 at 04:08:34PM +0400, Vyacheslav Dubeyko wrote:
> > First of all, I need some details about your NILFS2 partition for issue analysis.
> > 
> > I need in:
> > 1. Full output of "lscp -a".
> > 2. Full output of "lssu -a".
> > 3. Output of dumpseg for segment #0.
> > 
> > Could you share these outputs?
> 
> Sure!
> maszyn ~ # lscp -a /dev/sdf3
> lscp: /dev/sdf3: cannot open NILFS
> maszyn ~ # lssu -a /dev/sdf3
> lssu: /dev/sdf3: cannot open NILFS

lscp and lssu don't work if the target partition is not mounted, so
these seem to be its direct result.

> (the card is in a card reader)
> 
> > Maybe, you will have some troubles with getting of outputs. So, I need in your segment #0 (first 8 MB) raw output for issue analysis beginning, anyway.
> 
> maszyn ~ # dumpseg /dev/sdf3 0 > /tmp/dumpseg-0.out
> 
> Attached.

The segment zero may not include any useful information.
Please try nilfs-tune command to know which segment should be investigated.

# nilfs-tune -l /dev/sdf3
...
Last checkpoint #:	  160345
Last block address:	    131015
Last sequence #:	      7675
..

In this example, the active super block points to the segment #63:

  (value of the "Last block address" field) / 2048 = 131015 / 2048 = 63

Note that you can track the latest segment from the pointed segment.
"next segnum" field and "sequence number" field in the dumpseg outputs
tell you information about its successive segments.


By the way, Raspberry Pi Linux seems to be the kernel for an ARM-based
machine.  Is there possibility that this is a platform dependent
problem?


Regards,
Ryusuke Konishi


> Piotr Szymaniak.
> -- 
> Od  czasu  do  czasu  bij swoja zone,  jezeli ty nie wiesz za co ona na
> pewno bedzie wiedziec.
>   -- Przyslowie arabskie
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
