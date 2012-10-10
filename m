From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Wed, 10 Oct 2012 14:43:54 +0400
Message-ID: <1349865834.1889.95.camel@slavad-ubuntu>
References: <20121009105239.GV28032@wloczykij>
	 <1349784514.1921.9.camel@slavad-ubuntu> <20121009135833.GX28032@wloczykij>
	 <20121010.012440.17932600.konishi.ryusuke@lab.ntt.co.jp>
	 <20121010073912.GA28032@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=r9ONe5oRZTHuz4WD8XV80bMEN0Q/Onr/9zeV1PmgkrQ=;
	b=YqNlTEGCCae/RmX5S9IEQQyrRv4xS4L/Jep0Jqb9qAxgGW4eq94jJwrqvonthmmHUsfvZlbGU23nzgpRB4N01Q1SMKnYYilIPwHSQjzLWIfVLWF4ataN+78hfW/Z0Hd1;
In-Reply-To: <20121010073912.GA28032@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Wed, 2012-10-10 at 09:39 +0200, Piotr Szymaniak wrote:
> On Wed, Oct 10, 2012 at 01:24:40AM +0900, Ryusuke Konishi wrote:
> > > (the card is in a card reader)
> > > 
> > > > Maybe, you will have some troubles with getting of outputs. So, I need in your segment #0 (first 8 MB) raw output for issue analysis beginning, anyway.
> > > 
> > > maszyn ~ # dumpseg /dev/sdf3 0 > /tmp/dumpseg-0.out
> > > 
> > > Attached.
> > 
> > The segment zero may not include any useful information.
> > Please try nilfs-tune command to know which segment should be investigated.
> > 
> > # nilfs-tune -l /dev/sdf3
> > ...
> > Last checkpoint #:	  160345
> > Last block address:	    131015
> > Last sequence #:	      7675
> > ..
> 

Could you share full output of "nilfs-tune -l"? I can't start analysis without superblock's content.

Thanks,
Vyacheslav Dubeyko.


> Last checkpoint #:	  1873
> Last block address:	  734128
> Last sequence #:	  358
> 
> So it seems to be segment #358.
> 
> dump attached.
> 
> 
> Piotr Szymaniak.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
