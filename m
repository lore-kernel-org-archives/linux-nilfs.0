Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4681C310652
	for <linux-nilfs@vger.kernel.org>; Fri,  9 Jan 2026 16:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767976468; cv=none; b=etwEUTiuwJFI9LfSotLDpsxD83JAXepWjsfM17qApvTF7VBiULqYBASSMd5SjaC7jE/qdYB89qlruWPws9Exk1LeJ6D4mUimM90Lh+NPaZApNJninbmz1vYmYJRvMjOoN4JDlorsixisI66gpX5AUFQ1rNkrHtSAS1GqSkid3K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767976468; c=relaxed/simple;
	bh=UkZ26WkfqVTC4lLDEYonh9FhirevPhkbjTejcdyVYJ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kHl57poxhC1kSgoKK9xl7OPeZ2axL23crO8sQmO9n1FVlfbZHDIaVheo9kowH6tPqvLfKYknBxvChmVlrpSikzND/qKZkQhi7jrD1EoPJ1yRW3TV+qshRQSX5weop7zFI/sKpveF9HtcGkeyArqaaVM+6fHTRDjNlmyYVDT7F7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XjYIb7MZ; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XjYIb7MZ"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-59b7b27ebf2so1590324e87.1
        for <linux-nilfs@vger.kernel.org>; Fri, 09 Jan 2026 08:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767976464; x=1768581264; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h2njXp0xlbydhK1NNbS9rl3mS5JVHu2pW2tOjQ8YNnk=;
        b=XjYIb7MZ7PDBCU6AbOUhNEqlZuTtUNM1oTvRGggTp0qSSPOoH2sM1SPo8qOkaCsQTH
         ZziLexKVyZXanE+DqQM6MQNKmjQW1A531YQJpncbmB5aebDYXsExml3ONDUkNiXJjv5Z
         YKichyp3Ul1RmbHHfykuoRRBgNTQUBB6doTR5c3xFLL7GNbSRd1Xw7RSJUqPDw54cX74
         eDkY+U7baWofQtGvcCESpoDjZNZZ+sgY5hbzzcoKBo2Go48eUVUUA5SQ9y+zNBQ4Ykta
         cgKcMgzQjtvtTJU7EPPcclF2V0fGTxMyD6ruGKh7q9tlkJQGYowL6u+YVz2Qt/8UJ0Yd
         EHhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767976464; x=1768581264;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h2njXp0xlbydhK1NNbS9rl3mS5JVHu2pW2tOjQ8YNnk=;
        b=ddiv3jzVV5PXw71dCLAHltk5xDo6QQGVKxSmzrCj3KFZPOuy1HiCfssjllA3HFmpby
         RIgLtP/RC0UxiAVrSuQS/OfTshy/sQq5z8I3cj6RLCktOddRxAcoImAcBG8b0dcmZ5ml
         /aCNBFB5lqApGeBqGAhBQfb5itJtY3TQY7wVYVSfH0yHjjBHdytR0F/+X3U9QuE5kA6c
         jLqwCl31YegF7GqJQFj1JnJpBi/1ffIh7byfeusmTjPpjnl8Or+LMdLVu0b79PcYYv00
         jPWUjHSqUzjiBb8Y4jcoERb4iNLQZllDzkdaKOJbP2rtGpAJofCaVKkr4f2EksK8wvRA
         MNQw==
X-Gm-Message-State: AOJu0Yxz1lmQyxoHhABDpXsL0hn8mGF2nikck0ApjlHr9TEXwyXs+Oer
	rXplf/UKf/RobCuOSA14Mj6QWekd70xOV/8aVF2D9rLkoueBxUZO2DQlnlYHxBjEDSv79Y2fvRf
	LEohh7vezM72IA89LKHIn/uQZDMoIXEw=
X-Gm-Gg: AY/fxX7CMsjRpT5oy6HjZRi1OhC3j4aKimoU1OO6G6rDti6gLTVgv6JQAmwIeXaqREh
	k8/k2IWXq37iI/YsgEUmcirXyDOG5oQo1NvK5FKMGHxdzi9wd6cDrxAW9iuhk70KJi+evEEPufA
	j0hFHut50lfVDoYi1xaNKnX7kUANUHVf1V+1sYpjqruKCCcKgfrCKSUYkhyNUamve+jyx9I48zY
	Aact3ZVc0N7l00IhYLzK537dGcC3wzf0AJgijdpJUeclbyvx0jQjgy+BeCtzslI1fhdKF5E
X-Google-Smtp-Source: AGHT+IFjQuvhK++Tc1o5gY8clv5g3m0F+ZhEfEhi8JEGrGrvDqRX0h8Wog9G8rRdvwk/5fCJ7SDTjDME+Xp5T/LPnr0=
X-Received: by 2002:ac2:4e01:0:b0:595:91dc:72a5 with SMTP id
 2adb3069b0e04-59b6f03b941mr3442856e87.40.1767976463911; Fri, 09 Jan 2026
 08:34:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <93c5c0a639a31958876739641fae9989afe8bb26.camel@ibm.com>
 <CAKFNMo=a+gB+SUhWGO+J_2t7TOgzfwYBsJLF61UGEfWej-yLrA@mail.gmail.com> <d7bb64793d0990cc4b441c7a55e30b87b13dd4aa.camel@ibm.com>
In-Reply-To: <d7bb64793d0990cc4b441c7a55e30b87b13dd4aa.camel@ibm.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sat, 10 Jan 2026 01:34:07 +0900
X-Gm-Features: AZwV_Qiumdq0LFVZbyit4mw_QPy0vMn01xsHKrjN7DlrA1Shu7FjDmHmSWr84As
Message-ID: <CAKFNMo=scKgYNobap44HQb+cuy7tquQUnNOSnzwGQB=W-gotpQ@mail.gmail.com>
Subject: Re: [RFC] generic/003 xfstests failure details
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, "slava@dubeyko.com" <slava@dubeyko.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Viacheslav,

On Fri, Jan 9, 2026 at 9:32=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> On Thu, 2026-01-08 at 14:46 +0900, Ryusuke Konishi wrote:
> > On Thu, Jan 8, 2026 at 1:04=E2=80=AFPM Viacheslav Dubeyko wrote:
> > >
> > > Hi Ryusuke,
> > >
> > > As far as I can see, this test is trying to check the access time (at=
ime) after
> > > every touch. And it expects to see the difference between atime and c=
time. But
> > > it cannot see the difference:
> > >
> > > sudo touch ./001.txt
> > > sudo stat ./001.txt
> > >   File: ./001.txt
> > >   Size: 0               Blocks: 0          IO Block: 4096   regular e=
mpty file
> > > Device: 7,50    Inode: 12          Links: 1
> > > Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    ro=
ot)
> > > Access: 2026-01-06 16:23:18.315637313 -0800
> > > Modify: 2026-01-06 16:23:18.315637313 -0800
> > > Change: 2026-01-06 16:23:18.315637313 -0800
> > >  Birth: -
> > >
> > > sudo touch ./001.txt
> > > sudo stat ./001.txt
> > >   File: ./001.txt
> > >   Size: 0               Blocks: 0          IO Block: 4096   regular e=
mpty file
> > > Device: 7,50    Inode: 12          Links: 1
> > > Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    ro=
ot)
> > > Access: 2026-01-06 16:23:44.535933843 -0800
> > > Modify: 2026-01-06 16:23:44.535933843 -0800
> > > Change: 2026-01-06 16:23:44.535933843 -0800
> > >  Birth: -
> > >
> > > Moreover, NILFS2 hasn't atime support in on-disk layout [1]:
> > >
> > > struct nilfs_inode {
> > >         __le64  i_blocks;
> > >         __le64  i_size;
> > >         __le64  i_ctime;
> > >         __le64  i_mtime;
> > >         __le32  i_ctime_nsec;
> > >         __le32  i_mtime_nsec;
> > >         __le32  i_uid;
> > >         __le32  i_gid;
> > >         __le16  i_mode;
> > >         __le16  i_links_count;
> > >         __le32  i_flags;
> > >         __le64  i_bmap[NILFS_INODE_BMAP_SIZE];
> > > #define i_device_code   i_bmap[0]
> > >         __le64  i_xattr;
> > >         __le32  i_generation;
> > >         __le32  i_pad;
> > > };
> > >
> > > Current implementation does such trick [2]:
> > >
> > > int nilfs_read_inode_common(struct inode *inode,
> > >                             struct nilfs_inode *raw_inode)
> > > {
> > > <skipped>
> > >         inode_set_atime(inode, le64_to_cpu(raw_inode->i_mtime),
> > >                         le32_to_cpu(raw_inode->i_mtime_nsec));
> > >         inode_set_ctime(inode, le64_to_cpu(raw_inode->i_ctime),
> > >                         le32_to_cpu(raw_inode->i_ctime_nsec));
> > >         inode_set_mtime(inode, le64_to_cpu(raw_inode->i_mtime),
> > >                         le32_to_cpu(raw_inode->i_mtime_nsec));
> > > <skipped>
> > > }
> > >
> > > I think we can use i_xattr and i_pad fields of struct nilfs_inode to =
implement
> > > atime support. NILFS2 hasn't xattrs support and, anyway, i_xattr is n=
ot enough
> > > to implement this support.
> > >
> > > What do you think?
> >
> > What do you think is the appropriate goal for atime support?
> >
> > The Linux kernel has multiple support levels for atime, including
> > lazytime, relatime, noatime, and nodiratime.
> > For an append-only filesystem like nilfs2, supporting strict atime
> > would likely result in a disk-full error due to inode writes.
> >
>
> The lazytime, relatime, noatime, and nodiratime are mount options and it =
is up
> to end-user which particular mount option(s) should be used. Frankly spea=
king, I
> don't see the problem with any atime support for the case of append-only
> filesystem. Because, GC subsystem should guarantee proper fraction of seg=
ments
> cleaning operations. It's another point how significant will be the write
> amplification for relatime mount option, for example. But users of LFS fi=
le
> systems usually know which atime related options should be used for their
> workloads.

Logically, in the case of standard LFS, I think it's correct that GC
reduces issues caused by atime update writes to workload issues rather
than disk usage issues.

However, NILFS also has the property of being a filesystem that stores
past data and metadata. For example, by default, updates (checkpoints)
within the last hour are protected.

Therefore, even with GC, there is a possibility of disk usage attacks
by performing path lookups and file accesses repeatedly within an
hour.
So, please be aware of this difference in assumptions.

When I said "atime support level," I wasn't referring to drastic
changes in implementation, but rather to differences in update
frequency from this perspective.

Having said that, on standard systems, relatime is the default, and I
agree that this should not be a problem by default, as it
significantly reduces atime updates for on-memory inodes.

If we allow strictatime (without specifying reduction options such as
relatime or noatime), it may be a good idea to issue a warning at
mount time.
This can be done on the tool side (mount.nilfs2 helper side) and does
not necessarily need to be implemented in the kernel.

As for lazytime, it may be better to do the same, considering that
atime updates triggered by inode evictions result in dirty blocks.

> > Therefore, regardless of the implementation method, some kind of
> > constraint must be imposed.
> >
> > Personally, I think the limit is two options: noatime, relatime, or
> > three options, including lazytime (where inode writes occur when
> > evictions occur).
>
> I believe it's up to end-users which mounts option they would like to use=
. But
> we need to support atime mechanism, anyway.

Yes, I agree that atime support is needed anyway.

> >
> > What level of atime support is required for this test and other tests?
> > (Is it simply a matter of decision?)
>
> As far as I know, it is possible to select any mount options. But I am us=
ing
> default ones.

In that case, I think the safest option, relatime, is chosen.

>
> >
> > Regarding the atime implementation, it was originally intended to be
> > stored in a separate metadata file called the atime file.  Because of
> > its limited fields, it is a trade-off with xattr support.
> > A decision must be made to either move it to another metadata file or
> > expand the inode size.
> >
> > Regarding this, I agree with you that it would be better to ignore
> > past assumptions, assign the remaining fields (i_xattr, i_pad) to
> > atime, and implement xattr so that the sweet spot of the xattr size
> > fits inline, by expanding the inode size to 256 bytes.
>
> I selected the i_xattr, i_pad fields because they can guarantee the backw=
ard
> compatibility of on-disk layout. These fields were never used before. Als=
o, we
> don't need to expend the inode size, currently, because such expansion co=
uld
> break the backward compatibility of the on-disk layout.

Yes, that's right.
Using these fields for atime minimizes compatibility issues.
However, strictly speaking, you need to be careful of the following points:

- Both mkfs.nilfs2 and the nilfs2 metadata file initialize these
fields to 0, so we may need to consider replacing 0 with the same
value as ctime/mtime or current_time() when detected.

- In the current implementation, these fields are not cleared on
deletion, so if an inode is deleted and reused on an older version,
and then mounted on a newer version that supports atime, the atime
value may inherit the value from the previous inode.

The inode size in nilfs2 is defined in the superblock, and although it
is possible to extend it, this requires more rigor than compatibility
control, and would be better done together with xattr support.

> >
> > In any case, the above fields cannot be consumed unless the
> > implementation policy for xattrs is decided.
> >
>
> If we are considering the inline xattrs, then inode should be extended. B=
ut it
> could not provide the enough space if xattr is big or we need to have mul=
tiple
> xattrs. Potentially, extents tree can contains different types of extents=
 (user
> data, xattr). And logical block is allocated for xattr should contain hea=
der
> with metadata explaining the all xattr details. Does it make sense?

I used getfattr to aggregate xattr sizes on a certain server with
ext4-based partitions, and created a histogram, and the distribution
was as follows:

---------------------------------------------------------------------------=
---
 SIZE RANGE : COUNT  | DISTRIBUTION
---------------------------------------------------------------------------=
---
  32 -   47 : 563265 | ##################################################
  48 -   63 : 249520 | ######################
  64 -   79 :   1986 |
  80 -   95 :  11158 |
  96 -  111 :     54 |
 112 -  127 :      2 |
 128 -  143 :      1 |
 144 -  159 :     67 |
 176 -  191 :     32 |
 192 -  207 :      3 |
 208 -  223 :      2 |
 240 -  255 :      1 |
 256 -  271 :      1 |
---------------------------------------------------------------------------=
---

On NAS servers, the percentage of files over 100 bytes was slightly
higher, at about 6%.

The tendency for duplicate xattr values varies depending on the system.
With only SELinux security labels, there are many duplicate values.
On the other hand, there are also cases where different values, such
as checksums and ID tags, are written for each file (e.g., on a NAS).

One possible implementation of xattr is to use free inodes (for
example, allocating contiguous inodes).
However, considering that inodes will eventually need to be expanded,
I recommend a hybrid configuration, assuming expansion to 256 bytes or
more, uses the latter portion for inline xattr, and pushes anything
that doesn't fit into that area to a reserved xattr metadata file
(NILFS_XATTR_INO inode).

Let's leave the discussion of xattr implementation as a separate issue.

When considering atime, I think the key is whether we determine that
the current 128-byte inode will be used up by atime.
My opinion is the same as yours: Yes.

Thanks,
Ryusuke Konishi

>
> Thanks,
> Slava.
>
>
> > >
> > > [1]
> > > https://elixir.bootlin.com/linux/v6.19-rc4/source/include/uapi/linux/=
nilfs2_ondisk.h#L37
> > > [2] https://elixir.bootlin.com/linux/v6.19-rc4/source/fs/nilfs2/inode=
.c#L413
> > >
