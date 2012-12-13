From: =?iso-8859-1?Q?Sven-G=F6ran_Bergh?= <svengbergh-nilfs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: RE: Contributing to NILFS
Date: Thu, 13 Dec 2012 02:59:57 -0800 (PST)
Message-ID: <1355396397.55086.YahooMailNeo@web121806.mail.ne1.yahoo.com>
References: <1355169902.803.19.camel@terok>  <1355208388.2627.16.camel@slavad-ubuntu> <1355234065.803.61.camel@terok> <1355296112.2042.35.camel@slavad-ubuntu> <1355326242.67765.YahooMailNeo@web121802.mail.ne1.yahoo.com> <706EE260-E8A2-410A-9211-FB4859516478@dubeyko.com>
Reply-To: =?iso-8859-1?Q?Sven-G=F6ran_Bergh?= <svengbergh-nilfs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1355396397; bh=i1ppFhLZl/fcWkw7KEBHZVVIPcSkgQIlKt/YSJsAW2A=; h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding; b=JGvJ56TrHAl3YKNUxvvUN7Bmo4PNJkGwVXxJZWGKyGtWqFqr9gqiC6fyds3uK3K+UWdbYuBsXjV/y/VwY6NgKujTu4vvutRnp2CuGqE0Xd7qAXLxyLt+i6/UDGsF8sBlNHudkRjYkyP+Ps2vSFLkjIW6yJyTQHJPQ89/EXr5Uq8=
In-Reply-To: <706EE260-E8A2-410A-9211-FB4859516478-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Andreas Rohner <e0502196-oe7qfRrRQffzPE21tAIdciO7C/xPubJB@public.gmane.org>, "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>



2012-12-12 20:57, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>:

> Hi,
>=20
> On Dec 12, 2012, at 6:30 PM, Sven-G=F6ran Bergh wrote:
>=20
> [snip]
>>>=20
>>>  I think that this task hides many difficult questions. How does it
>>>  define what files fragmented or not? How does it measure the
>>>  fragmentation degree? What fragmentation degree should be a basis =
for
>>>  defragmentation activity? When does it need to detect fragmentatio=
n and
>>>  how to keep this knowledge? How does it make defragmentation witho=
ut
>>>  performance degradation?
>>=20
>>  These questions are of special interest if we through in the type o=
f
>>  media in the discussion. Fragmentation is not a big deal on NAND-ba=
sed
>>  media (SSD:s, memory cards, USB-sticks, etc). Defragmentation activ=
ity
>>  might even shorten the lifetime for such media due to the limited a=
mount
>>  write/erase cycles.
>>=20
>=20
> It is a good remark. Thank you.
>=20
> Yes, of course, it needs to remember about NAND wearing, especially, =
in the case=20
> of online defragmenting. But, as you know, NILFS2 makes garbage colle=
ction. As I=20
> understand, GC can copy some blocks from cleaning segments into new o=
nes. So,=20
> such copying also shorten NAND lifetime. Do you suggest not to make g=
arbage=20
> collection because of it?

No?, obviously not :-)

> We have as minimum two points for online defragmenting: (1) before fl=
ushing; (2)=20
> during garbage collection. Thereby, if you make defragmenting before =
any write=20
> then you don't shorten NAND lifetime. We need to make garbage collect=
ion=20
> anyway. As a result, it is possible to use this activity for defragme=
nting also.
>=20
> Yes, of course, NAND flash has good performance for the case of rando=
m reads.=20
> But the case of contiguous file's blocks is more better than fragment=
ed case=20
> anyway. First of all, during reading of fragmented file you need to g=
enerate=20
> block address before every not sibling block's data reading. So, you =
will=20
> spend more cycles for read fragmented file than for the case of=A0 co=
ntiguous=20
> file's blocks. Secondly, because of read disturbance the random read =
can=20
> force FTL to copy more erase blocks to a new ones and, as a result, t=
o lead to=20
> more shorter NAND lifetime. Thirdly, fragmented volume state leads to=
 more=20
> complex and unpredictable workloads with more intensive metadata oper=
ations. It=20
> can degrade filesystem performance. And, finally, GC has more harder =
work in the=20
> case of fragmented volume state, especially, for the case of presence=
 of deleted=20
> files.

Ok, seems like you misunderstood my previous statement. I do not argue =
against
defragmenting. However, there are many use cases and I just felt that N=
AND wearing
is of great importance as SSD:s are marching in. Thus, it should be par=
t of the
discussion, so defrag is implemented in a NAND-friendly way. Trying to =
minimize
NAND wear as well. As you pointed out above, there are many parameters =
in the
equation and NAND is yet another one that needs to be considered.

> Thereby, I think that it makes sense to implement online defragmentin=
g for the=20
> case of NILFS2. But, of course, it is a difficult and complex task be=
cause of=20
> probability to degrade performance and to shorten NAND lifetime.

Spot on! Totally agree.

Brgdrs
/S-G

> With the best regards,
> Vyacheslav Dubeyko.
>=20
>>  Brgds
>>  /S-G
>>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
"=20
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
