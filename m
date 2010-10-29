From: Andrea Gelmini <andrea.gelmini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs_btree_propagate problem
Date: Fri, 29 Oct 2010 14:48:05 +0200
Message-ID: <AANLkTikhULg7H_BECRc42gfNTLBJ7jJ6q3qp9ydMxswW@mail.gmail.com>
References: <AANLkTinw3anEyeWf95krAt5SH45RaaE6iCm-LU5Egj=1@mail.gmail.com>
	<20101029.162749.48197647.ryusuke@osrg.net>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:received:in-reply-to
         :references:date:message-id:subject:from:to:cc:content-type;
        bh=4naMl6FZkGebYj9COxtRR2XjOdch0XkeJerJJ/xaWnM=;
        b=t74z/fjiAKSHh6YQ97nd5AJBzonmC2lBGgcB8ZpkiY9ZzWgkkohq8rpcJ/9plzyB0C
         8CzpOa1Y64hTXbyutYHMAFL4ivmuZ90DkhvtKBGHKRkWZwumR1LglI30IuwRaUEPC1O3
         iKWV96maTK+UBL/0qIb5+qLPDc4lwomo66zGc=
In-Reply-To: <20101029.162749.48197647.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

2010/10/29 Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>:

Hi Ryusuke,
    and thanks a lot for your reply.

> Do you still have this problem?

Well, I hit the problem a few times.
Nothing that a reboot couldn't reboot.
But one day kernel started to complain about
btree corruption, so I gave up.
I don't have the old log, anyway if you are interested
I could try to replicate my usage pattern, to see if
the problem came back.

> If you meet the issue next time, try dmesg command to print kernel log
> buffered on memory. It may give us some clue.

Well, I usually check dmesg/logs, but I didn't find something useuful.

Thanks a lot for your work,
Gelma
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
