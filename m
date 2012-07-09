From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: nilfs2 weird issue - snapshots are gone, cleanerd not running
Date: Mon, 09 Jul 2012 14:31:56 +0400
Message-ID: <1341829916.1965.16.camel@slavad-ubuntu-11>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Message-ID:Date:Content-Type:Cc:To:From:Subject; bh=Tnf75qfjE/hd3kc6C+2IiP/ZRcvxYzuxU1VncgSrJbE=;
	b=bdg3rEYG+noCzxtNNJoFF3FK87kXpzn8r6Ekl3FTgKyWqF8TBpwMc2nfhpn0JDixhZTrSQ4mxL9r5M5jIL6LbUFO2BB9J8jLelqhzbA8tormZg9o03B5Xa1eChaY1k6K;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Piotr,

Does your nilfs_cleanerd.conf file contains any special values of
configuration parameters? Could you publish content of your
nilfs_cleanerd.conf file?

Thanks,
Vyacheslav Dubeyko.

On Mon, 2012-07-09 at 11:41 +0200, Piotr Szymaniak wrote:
> On Mon, Jul 09, 2012 at 01:28:32PM +0400, Vyacheslav Dubeyko wrote:
> > Hi Piotr,
> > 
> > Does system journals on your machines contain any interested details
> > about reported issue? Could you try to extract some error or warning
> > messages from system journal?
> 
> If by journals you mean logs then no. I'm only able to find some like
> this:
> Jul  3 10:32:45 wloczykij nilfs_cleanerd[1434]: resume (clean check)
> Jul  3 10:41:37 wloczykij nilfs_cleanerd[1434]: pause (clean check)
> 
> That's all about nilfs in the last week and current log has only
manual
> runs related to those operation described before.
> 
> Piotr Szymaniak.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
