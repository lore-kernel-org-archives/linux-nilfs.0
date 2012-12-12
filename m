From: =?iso-8859-1?Q?Sven-G=F6ran_Bergh?= <svengbergh-nilfs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: RE: Contributing to NILFS
Date: Wed, 12 Dec 2012 07:30:42 -0800 (PST)
Message-ID: <1355326242.67765.YahooMailNeo@web121802.mail.ne1.yahoo.com>
References: <1355169902.803.19.camel@terok>  <1355208388.2627.16.camel@slavad-ubuntu> <1355234065.803.61.camel@terok> <1355296112.2042.35.camel@slavad-ubuntu>
Reply-To: =?iso-8859-1?Q?Sven-G=F6ran_Bergh?= <svengbergh-nilfs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1355326242; bh=eLtRdelOiWkaa40GNRpP810khLNMvca032zJz9BVD3c=; h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding; b=LoHLr4n+qJi86ld/0OwxMg9+3c7RY1G3uB9EX94gpQjthTb0BmT5ltvlaujjLCob/doIto527uPJsd+phTHG3R0sgKFfGLwY84a4TU6+tHRFjiJxZqJ1H1IMPH06ChBILWmmz4gwNkkocwwU0Q2YPbM1tAUi20zkV5OiJKj9on8=
In-Reply-To: <1355296112.2042.35.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, Andreas Rohner <e0502196-oe7qfRrRQffzPE21tAIdciO7C/xPubJB@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

2012-12-12 08:08, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>:

> Hi Andreas,
>=20
> On Tue, 2012-12-11 at 14:54 +0100, Andreas Rohner wrote:
>>  Hi Vyacheslav,
>>=20
>>  Thanks for your response.
>>=20
>>  > > 2. Is there some fundamental difficulty that makes it hard to=20
> implement
>>  > > for a log-structured fs?
>>  >=20
>>  > I think that the most fundamental possible issue can be a possibl=
e
>>  > performance degradation. But first of all, from my point of view,=
 it
>>  > needs to discuss what the online defrag is and how it is possible=
 to
>>  > implement it. What do you mean personally by online defrag? And h=
ow do
>>  > you imagine online defrag mechanism for NILFS2 in particular? Whe=
n you
>>  > describe your understanding then it will be possible to discuss a=
bout
>>  > difficulties, I think. :-)
>>=20
>>  One way would be to just write out heavily fragmented files sequent=
ially
>>  and atomically switch to the new blocks. But as you suggested this
>>  simple approach would probably result in performance degradation,
>>  because it would eat up free segments and the segments of the old b=
locks
>>  would contain more unusable free space, that has to be cleaned firs=
t.
>>  This could result in an undesirable situation where most of the seg=
ments
>>  are 60% full and for every clean segment the cleaner has to read in=
 4
>>  half full segments. I think the difficult part is to find a suitabl=
e
>>  heuristic to decide if it is beneficial to defragment a file or not=
=2E My
>>  aim would be to produce as many clean or nearly clean segments as
>>  possible in the process. I would try to implement and test differen=
t
>>  heuristics and algorithms with differently aged file systems and co=
mpare
>>  the results.
>>=20
>=20
> I think that this task hides many difficult questions. How does it
> define what files fragmented or not? How does it measure the
> fragmentation degree? What fragmentation degree should be a basis for
> defragmentation activity? When does it need to detect fragmentation a=
nd
> how to keep this knowledge? How does it make defragmentation without
> performance degradation?

These questions are of special interest if we through in the type of
media in the discussion. Fragmentation is not a big deal on NAND-based
media (SSD:s, memory cards, USB-sticks, etc). Defragmentation activity
might even shorten the lifetime for such media due to the limited amoun=
t
write/erase cycles.

Brgds
/S-G

> As I understand, when we are talking about defragmentation then we
> expect a performance enhancement as a result. But defragmenter activi=
ty
> can be a background reason of performance degradation. Not every
> workload or I/O pattern can be a reason of significant fragmentation.
>=20
> Also, it is a very important to choose a point of defragmentation. I
> mean that it is possible to try to prevent fragmentation or to correc=
t
> fragmentation after flushing on the volume. It is possible to have a
> some hybrid technique, I think. An I/O pattern or file type can be a
> basis for such decision, I think.
>=20
> As I understand, F2FS [1] has some defragmenting approaches. I think
> that it needs to discuss more deeply about technique of detecting
> fragmented files and fragmentation degree. But maybe hot data trackin=
g
> patch [2,3] will be a basis for such discussion.
>=20
> I think that it can be a useful some materials about NILFS2. I began =
a
> design document for NILFS2 [4] but unfortunately it is not ended yet.=
 It
> was published a review of NILFS2 [5] not so recently.
>=20
> It exists some defragmentation-related papers but I haven't
> comprehensive list. I can mention about "The Effects of Filesystem
> Fragmentation" [6]. Maybe it can be useful "A Five-Year Study of
> File-System Metadata" [7] and "A File Is Not a File: Understanding th=
e
> I/O Behavior of Apple Desktop Applications" [8] papers.
>=20
> So, I feel necessity to think more deeply about online defragment tas=
k
> and about what you said. But, anyway, it is a beginning of
> discussion. :-)=20
>=20
> [1] http://lwn.net/Articles/518988/
> [2] http://lwn.net/Articles/525425/
> [3] http://lwn.net/Articles/400029/
> [4] http://dubeyko.com/development/FileSystems/NILFS/nilfs2-design.pd=
f
> [5] http://lwn.net/Articles/522507/
> [6]=20
> http://www.google.ru/url?sa=3Dt&rct=3Dj&q=3Dthe%20effects%20of%20file=
system%20fragmentation&source=3Dweb&cd=3D2&ved=3D0CD0QFjAB&url=3Dhttp%3=
A%2F%2Fwww.kernel.org%2Fdoc%2Fols%2F2006%2Fols2006v1-pages-193-208.pdf&=
ei=3D6CnIUJeHHYqB4gS6l4GoCQ&usg=3DAFQjCNFLhxtq89VLzE_fLuX7CDDpk_1Krw&bv=
m=3Dbv.1355272958,d.bGE&cad=3Drjt
> [7]=20
> http://www.google.ru/url?sa=3Dt&rct=3Dj&q=3Da%20five-year%20study%20o=
f%20file-system%20metadata&source=3Dweb&cd=3D1&ved=3D0CC0QFjAA&url=3Dht=
tp%3A%2F%2Fresearch.microsoft.com%2Fpubs%2F72896%2Ffast07-final.pdf&ei=3D=
syvIULepFoWE4ASDmYDIBA&usg=3DAFQjCNE5mFDPqgEvGYe32RkNyVa2oxVxkw&bvm=3Db=
v.1355272958,d.bGE&cad=3Drjt
> [8]=20
> http://www.google.ru/url?sa=3Dt&rct=3Dj&q=3Da%20file%20is%20not%20a%2=
0file%3A%20understanding%20the%20i%2Fo%20behavior%20of%20apple%20deskto=
p%20applications&source=3Dweb&cd=3D1&ved=3D0CC0QFjAA&url=3Dhttp%3A%2F%2=
=46research.cs.wisc.edu%2Fwind%2FPublications%2Fibench-1c-sosp11.pdf&ei=
=3DNSzIUP3zCKqK4ASU5oCACw&usg=3DAFQjCNEFr-bw1Ke382_rQBYGQwI88MPkKg&bvm=3D=
bv.1355272958,d.bGE&cad=3Drjt
>=20
> With the best regards,
> Vyacheslav Dubeyko.
>=20
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
