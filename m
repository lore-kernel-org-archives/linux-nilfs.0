From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Contributing to NILFS
Date: Wed, 12 Dec 2012 22:57:07 +0300
Message-ID: <706EE260-E8A2-410A-9211-FB4859516478@dubeyko.com>
References: <1355169902.803.19.camel@terok>  <1355208388.2627.16.camel@slavad-ubuntu> <1355234065.803.61.camel@terok> <1355296112.2042.35.camel@slavad-ubuntu> <1355326242.67765.YahooMailNeo@web121802.mail.ne1.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=9MbPo3hYbYjF1RgdjpHZyxnLt9aE0Rg03NVhgfRV+ho=;
	b=cMXQhrDh/OfdyOt91GSaqyLegMfTH4/qzj5Y00mKu8lumujvoPK4pAt1rvXkEoq72eff5O9iuA3jcJwduaCQKFIjjCcN2fj780rWbUsbsXIzgApj9gRvQyXemxrnsjbo;
In-Reply-To: <1355326242.67765.YahooMailNeo-mKBY30tKGRG2Y7dhQGSVAJOW+3bF1jUfVpNB7YpNyf8@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?iso-8859-1?Q?Sven-G=F6ran_Bergh?= <svengbergh-nilfs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Cc: Andreas Rohner <e0502196-oe7qfRrRQffzPE21tAIdciO7C/xPubJB@public.gmane.org>, "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

On Dec 12, 2012, at 6:30 PM, Sven-G=F6ran Bergh wrote:

[snip]
>>=20
>> I think that this task hides many difficult questions. How does it
>> define what files fragmented or not? How does it measure the
>> fragmentation degree? What fragmentation degree should be a basis fo=
r
>> defragmentation activity? When does it need to detect fragmentation =
and
>> how to keep this knowledge? How does it make defragmentation without
>> performance degradation?
>=20
> These questions are of special interest if we through in the type of
> media in the discussion. Fragmentation is not a big deal on NAND-base=
d
> media (SSD:s, memory cards, USB-sticks, etc). Defragmentation activit=
y
> might even shorten the lifetime for such media due to the limited amo=
unt
> write/erase cycles.
>=20

It is a good remark. Thank you.

Yes, of course, it needs to remember about NAND wearing, especially, in=
 the case of online defragmenting. But, as you know, NILFS2 makes garba=
ge collection. As I understand, GC can copy some blocks from cleaning s=
egments into new ones. So, such copying also shorten NAND lifetime. Do =
you suggest not to make garbage collection because of it?

We have as minimum two points for online defragmenting: (1) before flus=
hing; (2) during garbage collection. Thereby, if you make defragmenting=
 before any write then you don't shorten NAND lifetime. We need to make=
 garbage collection anyway. As a result, it is possible to use this act=
ivity for defragmenting also.

Yes, of course, NAND flash has good performance for the case of random =
reads. But the case of contiguous file's blocks is more better than fra=
gmented case anyway. First of all, during reading of fragmented file yo=
u need to generate block address before every not sibling block's data =
reading. So, you will spend more cycles for read fragmented file than f=
or the case of  contiguous file's blocks. Secondly, because of read dis=
turbance the random read can force FTL to copy more erase blocks to a n=
ew ones and, as a result, to lead to more shorter NAND lifetime. Thirdl=
y, fragmented volume state leads to more complex and unpredictable work=
loads with more intensive metadata operations. It can degrade filesyste=
m performance. And, finally, GC has more harder work in the case of fra=
gmented volume state, especially, for the case of presence of deleted f=
iles.

Thereby, I think that it makes sense to implement online defragmenting =
for the case of NILFS2. But, of course, it is a difficult and complex t=
ask because of probability to degrade performance and to shorten NAND l=
ifetime.

With the best regards,
Vyacheslav Dubeyko.

> Brgds
> /S-G
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
