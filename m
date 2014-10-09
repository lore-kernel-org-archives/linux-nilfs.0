From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: nilfs-diff experimental branch
Date: Fri, 10 Oct 2014 00:53:37 +0900 (JST)
Message-ID: <20141010.005337.27802719.konishi.ryusuke@lab.ntt.co.jp>
References: <CAFK5svByXZfnaEMsdiMhrC62tgsMxiAbVFmCcp8KG90=oLc-SQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFK5svByXZfnaEMsdiMhrC62tgsMxiAbVFmCcp8KG90=oLc-SQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Hugo Pacheco <hpacheco-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Wed, 8 Oct 2014 16:53:05 -0400, Hugo Pacheco wrote:
> Hi everyone,
> 
> I have been experimenting with the versioning capabilities of nilfs-tools
> and it works beautifully, but I have now started wanting to explore the
> hottest features only in the experimental branch, namely nilfs-diff.
> 
> I understand that this diff branch has never made it to mainstream, and
> probably won't soon, but has anyone succeeded in installing it for a modern
> 3.x linux kernel? The latest code available at github seems to require
> 2.6.x.
> 
> A more up-to-date picture would be really appreciated.

I rebased diff branches and pushed them out to github:

nilfs-utils  git://github.com/konis/nilfs-utils.git  (diff-v2 branch)
kernel       git://github.com/konis/nilfs2.git       (diffapi-v2 branch)

These are still experimental and need disk format change.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
