From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Strange "flush" process bahaviour
Date: Tue, 13 Nov 2012 21:24:11 +0300
Message-ID: <6B9E40B0-90F8-4130-9798-87253FEDDA78@dubeyko.com>
References: <50A159BC.9060600@li.ru> <20121113152856.GP25100@wloczykij>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=yHbSf9xlj82/gj3wbnMR2HByufkWF8Z8RxvDHVGetZA=;
	b=nHqeDowAuUnlu7CBFc5Z6ZeQfxcQD0FssHhELxTlBVqiHeyNRi+C62/CB5b7tlI6tRjRUKBpfk7qngNM4SqOk7ml/WUckojm5ep0sjEaJcsIrJdsPLvdlKeR320VzX37;
In-Reply-To: <20121113152856.GP25100@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On Nov 13, 2012, at 6:28 PM, Piotr Szymaniak wrote:

> On Tue, Nov 13, 2012 at 12:19:08AM +0400, fwdnilfsml.to.11df-2pMamKoQTv4@public.gmane.org wrote:
>> Hello!
>> Some time ago I've noticed, that "flush" kernel process associated with 
>> device running nilfs2 filesystem, generate huge amount of IO activity 
>> (using 100% CPU time). "iotop" utility show speeds about 5-15 GB\S on 
>> that "flush" process, but no actual disk activity happens.
>> This condition lasts about 1-2 minutes, and then it stops for some time 
>> (usually 10-20 minutes).
> 
> I can confirm this (but never bothered to check what caused it). But I
> saw some huge load (few days ago) on 1 CPU core that was stopped
> immediately after runnig "sync". This could be the same as mentioned
> here.
> 

What operations were on file system before the issue reproduction? I simply need to understand the way of issue reproduction on my side.

> And I just checked that machine and it eats my CPU. ps ax attached.
> 

I see some similarities in these both cases. You mount rootfs with definition the special configuration file also:

2175 ?        Ss     0:00 /sbin/nilfs_cleanerd -c /etc/nilfs_cleanerd_rootfs.conf /dev/disk/by-uuid/1aa9e6fb-cf7d-45bd-bbfb-08110a8840b7

So, do you have the reported issue as reproducible in the case of default way of mount or in not rootfs case?

With the best regards,
Vyacheslav Dubeyko.

> 
> Piotr Szymaniak.
> -- 
> - You know nothing about woman!
> - Of course not, I'm a man, so how could I know?
>  -- Berserk
> <ps.out>

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
