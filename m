From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: nilfs2 not garbage collecting
Date: Sun, 5 Aug 2012 20:51:21 +0400
Message-ID: <D99F26AB-309D-4325-A87C-DBF0F7BA6360@dubeyko.com>
References: <CANku=ggohcWWoxE1x=XmfWpANKyWRTWb5p_aHh8LU6+utU4OPQ@mail.gmail.com> <CANku=ghnDzkFHpPZ8eT9Y3kTM62zBKMk6TjBVraE4Kisa1TRPQ@mail.gmail.com> <F50BDE9A-4863-49CC-AC87-EEDC5B854E9C@dubeyko.com> <CANku=gjkTr-nYq8RxTUCVK9YU+xTjHyPbktB86BUpeuMwMBC4A@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=M73OgNyZJMrOszZIr1O+zlIWkXEZhLouHyCSlqMF4vE=;
	b=k/bUKpznagXGhor11D+kzYkaBtFEciAvdRQ6x3ftU2169ibv7kCLjKKzdne+fdqVXKtAg2BLWt/80Bn1LQeYkqrQnx2UkLeisJd73lYFuDpG70/epvH4EvIgU31PItA9;
In-Reply-To: <CANku=gjkTr-nYq8RxTUCVK9YU+xTjHyPbktB86BUpeuMwMBC4A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paolo Giangrandi <paolo-UnihLHphgvQ1GQ1Ptb7lUw@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Paolo,

On Aug 5, 2012, at 6:46 PM, Paolo Giangrandi wrote:

> No, didn't try, I missed that program, and I'm quite afraid of
> breaking something...
> 
> Currently checkpoints are like this:
> 
> # lscp | head
>                 CNO        DATE     TIME  MODE  FLG     NBLKINC       ICNT
>              302507  2012-07-19 15:36:17   cp    -          429     138707
>              302508  2012-07-19 15:36:17   cp    -           27     138707
>              302509  2012-07-19 15:36:21   cp    -           86     138708
>              302510  2012-07-19 15:36:22   cp    -           30     138708
>              302511  2012-07-19 15:36:22   cp    -           29     138708
>              302512  2012-07-19 15:36:22   cp    -           27     138708
>              302513  2012-07-19 15:36:22   cp    -           29     138708
>              302514  2012-07-19 15:36:24   cp    -           34     138708
>              302515  2012-07-19 15:36:24   cp    -           26     138708
> # lscp | tail
>              305341  2012-08-04 23:03:21   cp    -          141     138492
>              305342  2012-08-04 23:05:06   cp    -          646     138418
>              305343  2012-08-04 23:07:22   cp    -          229     138392
>              305344  2002-02-26 00:01:56   cp    -          708     138392
>              305345  2002-02-26 00:02:03   cp    -           33     138392
>              305346  2002-02-26 00:02:22   cp    -           29     138392
>              305347  2002-02-26 00:05:30   cp    -           25     138392
>              305348  2002-02-26 00:08:25   cp    -           29     138392
>              305349  2002-02-26 00:14:28   cp    -           27     138392
>              305350  2002-02-26 00:15:01   cp    -           32     138392
> 
> (the date of some checkpoints is set to 2002 because that EeePC has
> some issues with the clock: the clock battery is probably broken)
> 
> Should I just run `rmcp ..305350` ?
> Will it be safe?

I think that you can convert some important checkpoints into snapshots, firstly. It can be more safely. As I can understand, rmcp doesn't delete snapshots by default.

Moreover, you can delete some very old checkpoints and try to use file system, firstly. Checkpoints duplicate information usually and deleting of some old checkpoints don't be a dangerous action. Anyway, be careful, if you have some hesitations then it make sense to backup important information before any activity.

With the best regards,
Vyacheslav Dubeyko.


> 
> On Sun, Aug 5, 2012 at 3:44 PM, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote:
>> Hi Paolo,
>> 
>> By the way, did you try to use the rmcp utility? This utility is dedicated by removing of checkpoints by hands.
>> 
>> With the best regards,
>> Vyacheslav Dubeyko.
>> 
>> On Aug 5, 2012, at 3:00 PM, Paolo Giangrandi wrote:
>> 
>>> Hello,
>>> 
>>> I'm using NILFS2 as the root filesystem of an ArchLinux on my EeePC
>>> 900A. The filesystem has been created last November.
>>> At the moment there's no more space left, `lscp` shows that there are
>>> 2648 checkpoints, but nilfs_cleanerd is in idle.
>>> I tried to tweak nilfs_cleanerd configuration, but couldn't achieve anything.
>>> 
>>> Is it possible to know why nilfs_cleanerd isn't collecting the
>>> checkpoints, or force it to collect them?
>>> 
>>> Thanks,
>>> Paolo
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
