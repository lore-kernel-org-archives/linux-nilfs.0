From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: A lot of NILFS: bad btree node messages (readonly fs)
Date: Mon, 14 Jan 2013 22:32:59 +0300
Message-ID: <3708CBB8-E701-44D3-B76E-39F5F994A8CF@dubeyko.com>
References: <20121130073219.GB4028@wloczykij> <1356415552.2052.11.camel@slavad-ubuntu> <20130103214913.GE2080@wloczykij> <28ABE57F-66DD-491E-9FDB-A6CE3CF773FB@dubeyko.com> <20130104191633.GF2080@wloczykij> <C2F4A5DE-538B-4468-9A6A-BA619EDDA462@dubeyko.com> <20130105164752.GG2080@wloczykij> <504C0292-D0C6-426C-BDFD-1CD50FB32617@dubeyko.com> <20130109210943.GA22054@wloczykij> <1357801925.2050.41.camel@slavad-ubuntu> <20130112212421.GD22054@wloczykij>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=7EzNeeKDWLbzvwOpoHmt7aZNvF1wlqMvb0p5zeNUj/Y=;
	b=DJQ81JvCrs/MhWG4zDT7MRY8l/Pu6V9JiVRaDU+f0+P9jzGlQN0F0IHqBEAN/4Zbb6K/84yWauTC42465FF7TPlUHbXMVLnjQUr65uVEmvRv4e4I/kXkF9HHrsN2DW1R;
In-Reply-To: <20130112212421.GD22054@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: Elmer Zhang <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?utf-8?B?0KHQtdGA0LPQtdC5INCQ0LvQtdC60YHQsNC90LTRgNC+0LI=?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On Jan 13, 2013, at 12:24 AM, Piotr Szymaniak wrote:

> On Thu, Jan 10, 2013 at 11:12:05AM +0400, Vyacheslav Dubeyko wrote:
>> On Wed, 2013-01-09 at 22:09 +0100, Piotr Szymaniak wrote:
>>> On Tue, Jan 08, 2013 at 03:52:30PM +0300, Vyacheslav Dubeyko wrote:
>>>> 
>> [snip]
>> 
>> Thank you for additional details.
>> 
>> As I remember, you reported about issue with flush kernel thread firstly
>> and, then, about this issue. So, I think that you can have some similar
>> environment peculiarities as Elmer Zhang.
>> 
>> Could you share details of your virtual memory configuration
>> (especially, vm.min_free_kbytes)?
> 
> vm.min_free_kbytes = 3806
> 

I think that it is a very important detail.

> 
>> Could you share more detailed output of your system log? Especially, I
>> interested what was in the first case of the issue occurrence. But it
>> can be interested also part of system log that begins from system start
>> and ends with messages about remounting in RO state.
> 
> I can connect the broken file with other event. User repoted that his
> KDE session wont load or loads very (and it's like few minutes+) long
> time. Now I think the reason for this could be the broken file in
> /var/tmp/kde-foo. User moved his "broken" ~/.kde and everything was back
> to normal state (well, except that he was missing his session and DE
> setting).
> 
> I'm just writing it as this was some time ago (looking at the broken
> file it was ~2 months ago) and the logs are somewhere in /dev/null now
> and I think that those issues are connected somehow.
> 

Thank you for additional info.

Now I am fixing the issue with flush kernel thread. I think that the issue with flush kernel thread is a part of the issue with bad btree node messages.  

With the best regards,
Vyacheslav Dubeyko.

> 
> Piotr Szymaniak.
> -- 
> Stajesz sie odpowiedzialny na zawsze za to, co oswoiles.
>  -- Antoine De Saint-Exupery, "Le Petit Prince"

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
