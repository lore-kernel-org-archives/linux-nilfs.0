From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: production ready?
Date: Thu, 14 Oct 2010 14:50:18 +0900 (JST)
Message-ID: <20101014.145018.209367253.ryusuke@osrg.net>
References: <AANLkTikL-wSkv4uTUM_g5Cs9=k3Q8TNkWXa0KNtnutXJ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikL-wSkv4uTUM_g5Cs9=k3Q8TNkWXa0KNtnutXJ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dschauer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Wed, 13 Oct 2010 12:14:46 -0500, Dwight Schauer wrote:
> Hello NILFS2 users and developers,
> 
> How stable do you consider NILFS2? Performance issues aside, I'm more
> concerned about reliability.
> 
> I'm considering NILFS2 for a new server setup, as BTRFS does not
> appear to production ready yet from what I've read.
> 
> So, what I'm asking is this, is NILFS2 considered production ready for servers?
> 
> Sincerely,
> Dwight Schauer

NILFS2 is almost stable.  We have a record of nine months operation on
in-house samba servers and a webDAV server.

However, a few crash problems are reported on this mailing list and
remain unresolved.  I suspect they are caused by some sort of bug
related to "garbage collection" mechanism, which often makes trouble
on this sort of filesystems.

I think you may as well wait for resolution of these issues and test
enough if you will actually apply it for business use.  NILFS2 is
still marked "experimental" in kernel as with BTRFS.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
