From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: fsck.nilfs2: not found
Date: Wed, 9 May 2012 15:21:37 +0400
Message-ID: <F4C68CD6-CB84-4F60-88D2-8AB0DB9A17AA@dubeyko.com>
References: <CABECqUHJFN-6K1eP29BL39G=EgSTf2usRHLAWsNY98zzMTLT7w@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=V1+vpxI951Jfq0FwCwB9uIHi1TLK2YaE5QRV5VyLsKI=;
	b=LecFyALnbocYGYb+rZz5GeKQygx2goNKlXtxSXfgd/xQDSC1TxUZnHULDOJBpVrKMwiJrJP+QmvAICyD1n7qtVj6YZzFe5GlgFfeJjI3bN+aJsp7K+TlRNdnWvSg6/Ad;
In-Reply-To: <CABECqUHJFN-6K1eP29BL39G=EgSTf2usRHLAWsNY98zzMTLT7w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: karunakar merugu <karuna.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

Sorry, but as I know fsck tool for NILFS filesystem doesn't implemented yet.

With the best regards,
Vyacheslav Dubeyko.

On May 9, 2012, at 1:16 PM, karunakar merugu wrote:

> Hi
> I am using Linux karunakar-VirtualBox 3.0.0-12-generic #20-Ubuntu SMP.
> I installed nilfs utilities  by
> sudo apt-get update
> sudo apt-get install nilfs2-tools
> 
> Even after this I am getting error like:
> fsck from util-linux 2.19.1
> fsck: fsck.nilfs2: not found
> fsck: Error 2 while executing fsck.nilfs2 for /dev/sdb
> 
> can anyone help me in finding the correct package for fsck.nilfs2
> utility please.
> thanks,
> Karunakar.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
