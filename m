From: Kenneth Langga <klangga-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NILFS: bad btree node
Date: Sat, 26 May 2012 02:15:41 +0800
Message-ID: <CAHmELnVyRNGn1gda0Sw53YCSOAYMm5JUonebi-9NxaFBP7Uidw@mail.gmail.com>
References: <CAHmELnWvFNdiePs=mQJ=nqfsxJ_49zxawa9jncE-RJ2-omYHOg@mail.gmail.com>
 <20120525180649.GA1236@heethoofdje.13thmonkey.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type;
        bh=V2JBK66RKMi5vxtGqkzembrFIRMUNGHYVV77lxmaoQQ=;
        b=t9VwVTUhVkqGgVR9uAyJNwjQwD9cvg1MxMk2Nl2HHLm3iE/MTkYrasutGfP4dFxMWo
         t+5zO2XS9TcOQvxWDIgj5B+KwKrDhDEXF2xGxDVEwBAgVtw1EEbrs48r9WlmIk+drLvM
         lXHC+icAc4iQchtdwdc4St3ah+wSLQ0kx+iTG6ZPQeWgmJCZOl6q2MbdocLbGaqA6l1P
         wW7K6t8U0FlkH4RdB8KyYE4eSSKOfL4yWG7OFxcLHzS+yh3hB8C1p7cxUd3FP37mhOl+
         UTi0g3GylXbsy3L4K+ZmosOk+mfK/BhyvKTRih3N7URhQPVt82e6+byGk2J3nXuvfYzD
         ylTA==
In-Reply-To: <20120525180649.GA1236-bVHBekiX4bNgoMqBc1r0ESegHCQxtGRMHZ5vskTnxNA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

It's a 3TB harddisk. Could that be the reason?

Right now, it's mounted read-only. Is it safe to make it read/write
again? And can I run nilfs-clean on it and maybe the error would be
gone?

On Sat, May 26, 2012 at 2:06 AM, Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org> wrote:
> Hi Kenneth.
>
> On Fri, May 25, 2012 at 10:30:40PM +0800, Kenneth Langga wrote:
>> NILFS: bad btree node (blocknr=111560943): level = 242, flags = 0x3f,
>> nchildren = 23369
>> NILFS error (device sdc2): nilfs_bmap_lookup_contig: broken bmap
>> (inode number=19696)
>>
>> What is the correct course of action for this type of error? And what
>> would have caused this?
>
> What struck me is the very high level and the absurt number of number of
> children. That can't be good. AFAIR NiLFS only has say upto 3 (or 4?) levels
> in its B-tree. It *could* be failing in rebalancing or more likely pointing to
> garbage?
>
> Cheers,
> Reinoud
>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
