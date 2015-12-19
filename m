From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Unrecovered read error issue
Date: Sat, 19 Dec 2015 13:58:10 -0800
Message-ID: <1450562290.2693.9.camel@ubuntu-slavad-14.04>
References: <1450488372.2652.25.camel@slavad-ubuntu-14.04>
	 <20151219071703.GP3706@home.paul.comp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:mime-version:content-transfer-encoding;
        bh=pijx3wh8PWwiwwTXZaStyHh2SoxDXvRlXOqVDhm4WhY=;
        b=JVRjvQUipJtEzEsI8x4IjnQyTMOJRem00AXnWdqJ9TuDDaw7y6VvYh3fX6pCpZiFtb
         eKS+kkw2eKM+ARySDeZo4yOEZjcmZ2Xxm8FFCizym73UMdRBNoVBOZPJZ70illkheM1H
         egad0B6Ex+TXzpDwGAhGyUejthewoTuJTctlqaJ0jX6WyvGp1kbym14JlQhYJ37rgibP
         VpRtmfzO5lNadRlFSYHbO1q2VQ9f8fzdJLy3chMmIxLGJWh+xcSTHOGH/h6TvpnlaPnU
         aajnU3LyfKRKnqwxXIi7gzahgL8oSQeYpwTfgRQA3vjZJAuT2gfFc7qocvMBSOLfieVl
         QolQ==
In-Reply-To: <20151219071703.GP3706-VZXms658p7SUKArSQO4KrA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paul Fertser <fercerpav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Brian Cottingham <spiffytech-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Paul,

On Sat, 2015-12-19 at 10:17 +0300, Paul Fertser wrote:
> Hey Viacheslav,
> 
> On Fri, Dec 18, 2015 at 05:26:12PM -0800, Viacheslav Dubeyko wrote:
> > So, what do you think about such issue? What possible and easy solution
> > do you see? We haven't opportunity for long-term implementation and we
> > need in some easy hack for it. What do you think?
> 
> I reported this issue several years ago (in my case GC was choking on
> bad sectors of an eMMC), and no hack was considered to be necessary; I
> had to resort to manually dd 4096 zero bytes to the affected block
> every time I faced it.
> 
> I'm glad to see this is finally getting some attention!
> 

I think that I've encounter likewise problem with Seagate hybrid HDD
too.

But I suppose that eMMC or SSD will do re-assignment of bad logical
sector into valid physical page on write operation. And I am not sure
that bad sector will be re-assigned on write operation for HDD case.
File systems had special bad sectors table a decades ago. But this table
is considered as unnecessary metadata structure in modern file systems.

So, it needs to process likewise error as for read operation as for
write operation too, I assume.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
