Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9EB18FC80
	for <linux-nilfs@vger.kernel.org>; Tue, 13 Jan 2026 01:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768267904; cv=none; b=ph1iNeVCPI+Y0I+RX85DihoL1VTxB/gAyXzPUq96ENECK61erm43wDRXxebGZ5OkfL+mTYOVa18OZLGgZeR7n+JQfidc47TVUlIiAKaj/j2MhrAvRnRcCr5rVuOcIkkFXVtFK11SHJdfNdv/BxPXcomOE8MiCQRzG+D5XpuM4p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768267904; c=relaxed/simple;
	bh=n7UWN+KqmnrFw9UtmqTif3SSWS47gvp2WwDx1go8+sA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gRZA5oPqJDyOQwGQJGkXzOqs6I1huCO0pvN9BFYMsuYJg5lmwSKUmd/kV4DMWjlDMOpq3rH7R5QocT3eSaUWaSQVtgKuk3pRjgKJhwKTzUKqIUV6D087Yryhb5dTWmXPxV5ptw9DnII+42rlfMKMPa4R46/alYhWqFZ/djTS3rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JnFuZWeu; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JnFuZWeu"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-59b6df3d6b4so7089047e87.0
        for <linux-nilfs@vger.kernel.org>; Mon, 12 Jan 2026 17:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768267900; x=1768872700; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2X+XpBTAaBenXXZPooJkNunaNNFLF/l+efpCeAcf9m0=;
        b=JnFuZWeueePuBxBHhnnsJYWXrNzp6XGjg7ASu2Nfd0WMIQyiH0o+O6WZByrI3+ccPI
         Wlu5+EwEehDpbwTyo6ysu6I5Jq/8uV8lRaSsFgXQEoHPWv86d3udaThpcIq3vtymwUSB
         MHs+CytPRjUij1Ekc6LukI3CyPJxxkixM+NO/VCo3zGnx87kwnEnqBNewQg/D8eKHHzW
         1oJMvsqhouV4tJ0qyoqgFugSZrdVWLkCKZM6PARXleipLAQflSvV3LIZeaetbiI3QED4
         Sa/U0m0Jzld4tY7pOz70yK+X9e//EXjGDO8pZdkVSgKnak1gb86BFHdISWnFHt2KtiOi
         1JzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768267900; x=1768872700;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2X+XpBTAaBenXXZPooJkNunaNNFLF/l+efpCeAcf9m0=;
        b=QQuPbTWwjtoFRqb9vQ8+c2Y2xOzdyZyfDB1TmebwzCNDf4v1aGlQVAiEqlAVF02vLJ
         S0joyVt0Z3TyUKI723szpGm+op/n0fMW9mxMP8Ad5pL+U2fNAmYUaBq3JT7SSmwUcj3c
         8spboy1tZ7gC+y8XCm4Ed65UYV/tNaYqTYaby1aZTYI3J0SmQYMEi/6NT0xIOFQ+99jY
         6jcNRVN9zYE0thioMXASDrgLDW2Iun7T6kI5cdwftGhm+H9g4Cp3WuipnXZMhJxdXLmM
         yOWVmb2/WwZJj5iC8PyZNjmU6iSz2GM+YPjcvoTf+H7YsID7dznsD3gFC+9AdrjFGnIN
         DpBg==
X-Gm-Message-State: AOJu0YwbIe++X2dvY6a21fXNxOPc6Lmo+3xfvL4t8+/On29S/eTJx6/2
	29HUxrBERkVykaVIWJfs6Ja/PQO2FHkWUDTClY1guYwzQGh81lNO8yNP+EFkZpq61VduEaxJrsJ
	eZeT245BRb0v+O6+mNNXBhBGDYiaXeO4=
X-Gm-Gg: AY/fxX7OXWEeVPHaQNhoMLxeOiZ1JXjjpHhC+aXJx3C4iWhZuGK9pNjUjGq4z3cgCQQ
	1RwpAKyw/4oPHUUMizROfbZwUydeTeOpAaYGHfEAGimg5Dk18Y8CCtOBf+p1E7EuYfoMTtfqxdb
	6/TKT2y0tNGJ5r+buaIT7E9hWiT+EdZ4aqXanWuJH7+6LVyTp8Bi7EEoYl5SkCcEQlVLQoKlBIk
	qOM/TOD3OGV11DHBl3yrpQEvQkcehx5JoQa4zUoJ1ENzdc4G/ybChHE/zaVizk+z6hcFiVj4poq
	wNOl7dQ=
X-Google-Smtp-Source: AGHT+IFSYZ1vv1I/44nyGiVPpzv192vC3U3x3yNj3JwdRt4REcNnO/HlnBIq13d9TYFKhSJUfVShoIJR9vvQgmIN8QM=
X-Received: by 2002:a05:6512:3c88:b0:59b:7d3a:2a26 with SMTP id
 2adb3069b0e04-59b7d3a2c31mr3735059e87.44.1768267899748; Mon, 12 Jan 2026
 17:31:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <93c5c0a639a31958876739641fae9989afe8bb26.camel@ibm.com>
 <CAKFNMo=a+gB+SUhWGO+J_2t7TOgzfwYBsJLF61UGEfWej-yLrA@mail.gmail.com>
 <d7bb64793d0990cc4b441c7a55e30b87b13dd4aa.camel@ibm.com> <CAKFNMo=scKgYNobap44HQb+cuy7tquQUnNOSnzwGQB=W-gotpQ@mail.gmail.com>
 <4f1af0d0b9d867e8baf964d033452f86ccc27c08.camel@ibm.com>
In-Reply-To: <4f1af0d0b9d867e8baf964d033452f86ccc27c08.camel@ibm.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Tue, 13 Jan 2026 10:31:23 +0900
X-Gm-Features: AZwV_Qib_cFlFazJMJOZcvFAk5AohfMkGCtpXDpqx2R43Wk7pljqW_5qplhRIro
Message-ID: <CAKFNMokM7=3wdqdcWWLgBkDK-H=mgfHyd3z61TYT8WxBUC_X9g@mail.gmail.com>
Subject: Re: [RFC] generic/003 xfstests failure details
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, "slava@dubeyko.com" <slava@dubeyko.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2026 at 9:20=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> Hi Ryusuke,
>
> On Sat, 2026-01-10 at 01:34 +0900, Ryusuke Konishi wrote:
> > Hi Viacheslav,
> >
> > On Fri, Jan 9, 2026 at 9:32=E2=80=AFAM Viacheslav Dubeyko wrote:
> > >
> > > On Thu, 2026-01-08 at 14:46 +0900, Ryusuke Konishi wrote:
> > > > On Thu, Jan 8, 2026 at 1:04=E2=80=AFPM Viacheslav Dubeyko wrote:
> > > > >
> > > > > Hi Ryusuke,
> > > > >
> > > > > As far as I can see, this test is trying to check the access time=
 (atime) after
> > > > > every touch. And it expects to see the difference between atime a=
nd ctime. But
> > > > > it cannot see the difference:
> > > > >
> > > > > sudo touch ./001.txt
> > > > > sudo stat ./001.txt
> > > > >   File: ./001.txt
> > > > >   Size: 0               Blocks: 0          IO Block: 4096   regul=
ar empty file
> > > > > Device: 7,50    Inode: 12          Links: 1
> > > > > Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/  =
  root)
> > > > > Access: 2026-01-06 16:23:18.315637313 -0800
> > > > > Modify: 2026-01-06 16:23:18.315637313 -0800
> > > > > Change: 2026-01-06 16:23:18.315637313 -0800
> > > > >  Birth: -
> > > > >
> > > > > sudo touch ./001.txt
> > > > > sudo stat ./001.txt
> > > > >   File: ./001.txt
> > > > >   Size: 0               Blocks: 0          IO Block: 4096   regul=
ar empty file
> > > > > Device: 7,50    Inode: 12          Links: 1
> > > > > Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/  =
  root)
> > > > > Access: 2026-01-06 16:23:44.535933843 -0800
> > > > > Modify: 2026-01-06 16:23:44.535933843 -0800
> > > > > Change: 2026-01-06 16:23:44.535933843 -0800
> > > > >  Birth: -
> > > > >
> > > > > Moreover, NILFS2 hasn't atime support in on-disk layout [1]:
> > > > >
> > > > > struct nilfs_inode {
> > > > >         __le64  i_blocks;
> > > > >         __le64  i_size;
> > > > >         __le64  i_ctime;
> > > > >         __le64  i_mtime;
> > > > >         __le32  i_ctime_nsec;
> > > > >         __le32  i_mtime_nsec;
> > > > >         __le32  i_uid;
> > > > >         __le32  i_gid;
> > > > >         __le16  i_mode;
> > > > >         __le16  i_links_count;
> > > > >         __le32  i_flags;
> > > > >         __le64  i_bmap[NILFS_INODE_BMAP_SIZE];
> > > > > #define i_device_code   i_bmap[0]
> > > > >         __le64  i_xattr;
> > > > >         __le32  i_generation;
> > > > >         __le32  i_pad;
> > > > > };
> > > > >
> > > > > Current implementation does such trick [2]:
> > > > >
> > > > > int nilfs_read_inode_common(struct inode *inode,
> > > > >                             struct nilfs_inode *raw_inode)
> > > > > {
> > > > > <skipped>
> > > > >         inode_set_atime(inode, le64_to_cpu(raw_inode->i_mtime),
> > > > >                         le32_to_cpu(raw_inode->i_mtime_nsec));
> > > > >         inode_set_ctime(inode, le64_to_cpu(raw_inode->i_ctime),
> > > > >                         le32_to_cpu(raw_inode->i_ctime_nsec));
> > > > >         inode_set_mtime(inode, le64_to_cpu(raw_inode->i_mtime),
> > > > >                         le32_to_cpu(raw_inode->i_mtime_nsec));
> > > > > <skipped>
> > > > > }
> > > > >
> > > > > I think we can use i_xattr and i_pad fields of struct nilfs_inode=
 to implement
> > > > > atime support. NILFS2 hasn't xattrs support and, anyway, i_xattr =
is not enough
> > > > > to implement this support.
> > > > >
> > > > > What do you think?
> > > >
> > > > What do you think is the appropriate goal for atime support?
> > > >
> > > > The Linux kernel has multiple support levels for atime, including
> > > > lazytime, relatime, noatime, and nodiratime.
> > > > For an append-only filesystem like nilfs2, supporting strict atime
> > > > would likely result in a disk-full error due to inode writes.
> > > >
> > >
> > > The lazytime, relatime, noatime, and nodiratime are mount options and=
 it is up
> > > to end-user which particular mount option(s) should be used. Frankly =
speaking, I
> > > don't see the problem with any atime support for the case of append-o=
nly
> > > filesystem. Because, GC subsystem should guarantee proper fraction of=
 segments
> > > cleaning operations. It's another point how significant will be the w=
rite
> > > amplification for relatime mount option, for example. But users of LF=
S file
> > > systems usually know which atime related options should be used for t=
heir
> > > workloads.
> >
> > Logically, in the case of standard LFS, I think it's correct that GC
> > reduces issues caused by atime update writes to workload issues rather
> > than disk usage issues.
> >
> > However, NILFS also has the property of being a filesystem that stores
> > past data and metadata. For example, by default, updates (checkpoints)
> > within the last hour are protected.
> >
> > Therefore, even with GC, there is a possibility of disk usage attacks
> > by performing path lookups and file accesses repeatedly within an
> > hour.
> > So, please be aware of this difference in assumptions.
> >
> > When I said "atime support level," I wasn't referring to drastic
> > changes in implementation, but rather to differences in update
> > frequency from this perspective.
> >
> > Having said that, on standard systems, relatime is the default, and I
> > agree that this should not be a problem by default, as it
> > significantly reduces atime updates for on-memory inodes.
> >
> > If we allow strictatime (without specifying reduction options such as
> > relatime or noatime), it may be a good idea to issue a warning at
> > mount time.
> > This can be done on the tool side (mount.nilfs2 helper side) and does
> > not necessarily need to be implemented in the kernel.
> >
> > As for lazytime, it may be better to do the same, considering that
> > atime updates triggered by inode evictions result in dirty blocks.
> >
> > > > Therefore, regardless of the implementation method, some kind of
> > > > constraint must be imposed.
> > > >
> > > > Personally, I think the limit is two options: noatime, relatime, or
> > > > three options, including lazytime (where inode writes occur when
> > > > evictions occur).
> > >
> > > I believe it's up to end-users which mounts option they would like to=
 use. But
> > > we need to support atime mechanism, anyway.
> >
> > Yes, I agree that atime support is needed anyway.
> >
> > > >
> > > > What level of atime support is required for this test and other tes=
ts?
> > > > (Is it simply a matter of decision?)
> > >
> > > As far as I know, it is possible to select any mount options. But I a=
m using
> > > default ones.
> >
> > In that case, I think the safest option, relatime, is chosen.
> >
> > >
> > > >
> > > > Regarding the atime implementation, it was originally intended to b=
e
> > > > stored in a separate metadata file called the atime file.  Because =
of
> > > > its limited fields, it is a trade-off with xattr support.
> > > > A decision must be made to either move it to another metadata file =
or
> > > > expand the inode size.
> > > >
> > > > Regarding this, I agree with you that it would be better to ignore
> > > > past assumptions, assign the remaining fields (i_xattr, i_pad) to
> > > > atime, and implement xattr so that the sweet spot of the xattr size
> > > > fits inline, by expanding the inode size to 256 bytes.
> > >
> > > I selected the i_xattr, i_pad fields because they can guarantee the b=
ackward
> > > compatibility of on-disk layout. These fields were never used before.=
 Also, we
> > > don't need to expend the inode size, currently, because such expansio=
n could
> > > break the backward compatibility of the on-disk layout.
> >
> > Yes, that's right.
> > Using these fields for atime minimizes compatibility issues.
> > However, strictly speaking, you need to be careful of the following poi=
nts:
> >
> > - Both mkfs.nilfs2 and the nilfs2 metadata file initialize these
> > fields to 0, so we may need to consider replacing 0 with the same
> > value as ctime/mtime or current_time() when detected.
> >
> > - In the current implementation, these fields are not cleared on
> > deletion, so if an inode is deleted and reused on an older version,
> > and then mounted on a newer version that supports atime, the atime
> > value may inherit the value from the previous inode.
> >
> > The inode size in nilfs2 is defined in the superblock, and although it
> > is possible to extend it, this requires more rigor than compatibility
> > control, and would be better done together with xattr support.
> >
> > > >
> > > > In any case, the above fields cannot be consumed unless the
> > > > implementation policy for xattrs is decided.
> > > >
> > >
> > > If we are considering the inline xattrs, then inode should be extende=
d. But it
> > > could not provide the enough space if xattr is big or we need to have=
 multiple
> > > xattrs. Potentially, extents tree can contains different types of ext=
ents (user
> > > data, xattr). And logical block is allocated for xattr should contain=
 header
> > > with metadata explaining the all xattr details. Does it make sense?
> >
> > I used getfattr to aggregate xattr sizes on a certain server with
> > ext4-based partitions, and created a histogram, and the distribution
> > was as follows:
> >
> > -----------------------------------------------------------------------=
-------
> >  SIZE RANGE : COUNT  | DISTRIBUTION
> > -----------------------------------------------------------------------=
-------
> >   32 -   47 : 563265 | ################################################=
##
> >   48 -   63 : 249520 | ######################
> >   64 -   79 :   1986 |
> >   80 -   95 :  11158 |
> >   96 -  111 :     54 |
> >  112 -  127 :      2 |
> >  128 -  143 :      1 |
> >  144 -  159 :     67 |
> >  176 -  191 :     32 |
> >  192 -  207 :      3 |
> >  208 -  223 :      2 |
> >  240 -  255 :      1 |
> >  256 -  271 :      1 |
> > -----------------------------------------------------------------------=
-------
> >
> > On NAS servers, the percentage of files over 100 bytes was slightly
> > higher, at about 6%.
> >
> > The tendency for duplicate xattr values varies depending on the system.
> > With only SELinux security labels, there are many duplicate values.
> > On the other hand, there are also cases where different values, such
> > as checksums and ID tags, are written for each file (e.g., on a NAS).
> >
> > One possible implementation of xattr is to use free inodes (for
> > example, allocating contiguous inodes).
> > However, considering that inodes will eventually need to be expanded,
> > I recommend a hybrid configuration, assuming expansion to 256 bytes or
> > more, uses the latter portion for inline xattr, and pushes anything
> > that doesn't fit into that area to a reserved xattr metadata file
> > (NILFS_XATTR_INO inode).
> >
> > Let's leave the discussion of xattr implementation as a separate issue.
> >
> > When considering atime, I think the key is whether we determine that
> > the current 128-byte inode will be used up by atime.
> > My opinion is the same as yours: Yes.
> >
>
> So, I believe that we are on the same page. :)
>
> To summarize... Currently, we can leave the size of raw inode as it is (1=
28
> bytes) for atime support implementation. We can re-use the i_xattr, i_pad=
 fields
> for this implementation on kernel side. The mount.nilfs2 should reject or=
 issue
> the warning relating to using the aggressive atime mount options.
>
> Am I correct? If we have the similar vision, then I can start the atime s=
upport
> implementation and we can continue discussion when I'll share the patch.
>

Yes, that's generally my understanding.

Just one thing: as long as issuing warnings for strictatime and
lazytime, I think handling them in the mount.nilfs2 helper is fine.
But if we find that the filesystem gets stuck due to atime updates
(e.g., unable to recover from a disk-full state), then the kernel
should enforce the rejection to prevent the unsafe state.

> Related to xattr support... I believe that we need to fix the all detecte=
d
> xfstests issues first. Then, it will make sense to have the discussion re=
lated
> to definition of xattr architecture in NILFS2. Do you agree?

Yes, I agree.


Thanks,
Ryusuke Konishi

>
> Thanks,
> Slava.
