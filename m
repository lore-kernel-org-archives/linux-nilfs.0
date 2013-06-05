From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: My NiLFS2 port to NetBSD: status update
Date: Wed, 05 Jun 2013 15:52:48 +0400
Message-ID: <1370433168.2229.35.camel@slavad-ubuntu>
References: <20130604140257.GA713@diablo.13thmonkey.org>
	 <20130605.092130.52167382.konishi.ryusuke@lab.ntt.co.jp>
	 <20130605090300.GA201@diablo.13thmonkey.org>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=unLnNvVZRQEA5xm3v27S9Tl2SYPKfqrwcxvHQpfD6zQ=;
	b=NQN7i6qoZvEKKigUHG/2sHhiWq6Tg34LIrm61xeaZB8m7NUZzkVkHs2juVPdElgSGHwggOFKMjVZf3il/gZsPP3C9S++flsSIUx0ObqRtVKi0Bjgmzta0V+so//UJuk1;
In-Reply-To: <20130605090300.GA201-HNv6YvNvQKMNqjISwOrxaLFspR4gePGN@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Reinoud,

On Wed, 2013-06-05 at 11:03 +0200, Reinoud Zandijk wrote:

[snip]
> Sorry for the braindump :) Oh, how is the fsck_nilfs going? i plan on creating
> a fsck_nilfs my own as part of the development process, just as an assurance i
> dont mess up my btree's :-D That code is still... well, not that good ;)
> 

I started fsck.nilfs2 development in 2012. But, unfortunately, I don't
make any implementation activity in this direction during this year
because of lack of time. I think that you have very ambitious
implementation plans. :-) I mean that implementation of fsck tool is not
so fast and easy task.

I think that it makes sense to distribute fsck implementation between of
us. Please, find nilfs-utils with current state of my implementation of
fsck.nilfs2 by link:

http://dubeyko.com/development/FileSystems/NILFS/nilfs-utils-fsck-v.0.04-under-development.tar.gz 

Of course, current state of fsck.nilfs2 code is not ideal. But my
implementation can be a ready basis for your efforts in this direction.

What do you think? :-)

To implement the fsck.nilfs2 is very important task, from my viewpoint.
We very need in this tool for stabilization, optimization and further
implementation of NILFS2 driver. But, currently, I am deeply in
investigation and fix of known issues of NILFS2 driver under Linux.

Also I am thinking over another your questions. But, currently, I don't
clear understand your ideas. :-) I need to think yet.

I am going to implement extended attributes and ACLs support in NILFS2
too, because I am implementing ACLs support for HFS+ right now on the
richacl patch set basis. So, if I will lucky then I'll start this
implementation for NILFS2 soon.

With the best regards,
Vyacheslav Dubeyko.

> With regards,
> Reinoud
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
