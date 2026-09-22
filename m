Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F348C4F4CFC
	for <linux-nilfs@vger.kernel.org>; Tue, 22 Sep 2026 21:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790113950; cv=none; b=U5fyqcenr/WbZ1JPG/FH6AwZ4aZ0iTNlQTXrjhpNQ7/jhOnNvqiDbZQCZxOyYQJbs4/XCLDKfMPOl2OCVEmzGry2fK43cQT+Dx4kv0V6hKx+UbO1XJwCAZKdnD2cMSO8CoMLDbFfkfubRVh+GTJnlixMHZRm/o0vpxkkbQ+b7b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790113950; c=relaxed/simple;
	bh=urTZ69sfotSRNr3yRQFdTcNB1ixPj2XhlGVls350Uuk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iCscpYk2crejVYu0U+npmQ94a4fkOE/wyhN0RKs3VU3Dfqp2jwLUmMnIhUC63SJCMqSCnCCpivvNHtFfpxrpyVKBNAwksi6lXg+YmnP6E5zmghu3CVtSfW0B9ZVhRuw96xyDLdXiujGwvto9i5Mh03p4g9i9bgoUkSPiRXS/pFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=a8/d5e5c; arc=none smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="a8/d5e5c"
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66e4aae3149so265829d50.2
        for <linux-nilfs@vger.kernel.org>; Tue, 22 Sep 2026 14:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1790113940; x=1790718740; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=urTZ69sfotSRNr3yRQFdTcNB1ixPj2XhlGVls350Uuk=;
        b=a8/d5e5cEazayFRyZAHttB78mHtesi5LKviqIj9GKGOXr8s0+valbhsVtOzwRpr2lv
         HEooO9c07SCcbm5KzQP8EuGjABemJbP2QtJcjoRO0MO1XoXe3kPZ+7Zl+b/sKlhZaPXR
         N/l1cBBXcZwPxsC2JgIGvwlF1wEfRiaUtIr4bYUhBPoioStAZZZagQJ+Kk70UjJdp4o3
         rC5FNg5CTu0reQ+aM0mLIIIo8oOvoCqLs7YS0nM1fMJu3UYPj9gl3R14N3C+hXqbc5Ls
         Scp8U/H861cF5xJGeaEykkKndzbuvTT6PHbF+NA0ELzdPTjBmwxIho3/sTDDs98fbGbS
         axKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790113940; x=1790718740;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=urTZ69sfotSRNr3yRQFdTcNB1ixPj2XhlGVls350Uuk=;
        b=Jc0YCVDX/hi3BYDeVsjawXNXg6B75RPsYi9dtQT6N8v8zEYSJea8UO2rqVWxBPOrtf
         T/V2wUXqHewTvQTEZk31yy3MQ5ASjdnfBep4iKwIShJCSPNR7Ue2SsMZ8EIt/pmV8to8
         qdfyWPUoNW/VLMZGE/qdmYE5rczuIv8bcVO9KAabdTGE1WfgmZAF6YeW2cHVWeNT9onp
         +a/M5/DA8N/ZKr1bSm8OVyrZ7XHlV8HTlGj4HQQPd2vYuFpkXk3uHXvAV1VLrgrt8Irz
         isyWwdclbFdcHNA7QDVaiaMKODJ9GgFRuN1CHMzoFZ76dx5GHUI6V4E3K09mL1RSgWs+
         VQ2A==
X-Forwarded-Encrypted: i=1; AKwUvBzrM7pxO34f64duhwahjMROQDJQ3dF2gRiMkvOpkvNoR6uZppMNt957A6hGPhXB/KAfgab+VFOOyx6ZGw==@vger.kernel.org
X-Gm-Message-State: AFuF++lqWBlCwvZ7Zcs9IZZbFJcbJx/VreenwQQmFKhnFG4rcDFOSU5v
	368bD7MrcQZ2gkIX4RMIvIU3OwxnKtALthebnd/JQjwRtnr2WJk0Pl3y4WBjLMEHOug=
X-Gm-Gg: AYBFou1B93eKXbu2lCywyCJQ8USIzCmp/7+LkTCg1W5bXkJOtWs3vI4Pp4gHIk6Sl/R
	lKCmwTFQV+8WypfKghRhuBml4C+Z3JT9Sfk1SoxheGUNGjQIysEuNX0ygRYuUmwJr6aiA5dH62W
	hhlSv4HBI/BG6g2kvpygjXxD7Iomns/h4mKfGdpsqaZbfoeFRmdF4MkYgQafoCRAtN95C4P6npw
	XotyLznKtN4FGA+b0kc3KZXH622H7/5KBarIIHUIYxctwncH/bDiR3uFrwJ6MwmYz8bkejw65CL
	Hk1MwvY6JCeysY4t+QhTJLy7L4rA40LN0Urx66VSqlvi1NecQu8GZ2O2/P9Xhxj4DcwQqHVmwky
	yEahCoPVsR90ElbNMLXW647N2D4ovM2PMfvr+Pplc57y9HGVZQvLTgRQFtPIF9VckzVS0kBxUHo
	mBJw68DQ831/178WBgcmeU0QbYK/zpYQLP1k9WGgm5ieLiDORVccErVisIZCTeymr1rPQQIS2/K
	PtF24grC+sUVVxW/BJL/Id3j9Gk1iSZjFSJIbyQAypZM/1obLbkQzHDuQ5f4IiztJL5028S22GX
	WCr+Soybrk90sAl4oRFgx56zav93s7kzUCCRO0IInpGZZkvp4JvHNkKBvAneKu2w/lsHoC8xIfo
	=
X-Received: by 2002:a05:690e:151c:b0:671:70d1:d6c8 with SMTP id 956f58d0204a3-672d58c288amr447516d50.58.1790113939894;
        Tue, 22 Sep 2026 14:52:19 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:af0a:8535:f1b1:7cb0? ([2600:1700:6476:1430:af0a:8535:f1b1:7cb0])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-672d81e102asm188929d50.19.2026.09.22.14.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 14:52:19 -0700 (PDT)
Message-ID: <abb39d97b90401669f7d6ba24d35747a676fded0.camel@dubeyko.com>
Subject: Re: [PATCH v4] nilfs2: fix checkpoint root lifetime on sysfs errors
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>, dubeyko@comp.asu.ru
Cc: Aldo Ariel Panzardo <qwe.aldo@gmail.com>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Tue, 22 Sep 2026 14:52:16 -0700
In-Reply-To: <CAKFNMokXBG6C2gHfM+PnhjhJK7BbT84Oou3Gnr+4StR6XTb1Aw@mail.gmail.com>
References: 
	<CAKFNMonYVUbzjYm343Aw-=xjUk78x4EdUwGBfNRwE6zfmRVhvA@mail.gmail.com>
	 <20260921152144.3983736-1-qwe.aldo@gmail.com>
	 <20260921152144.3983736-2-qwe.aldo@gmail.com>
	 <CAKFNMokXBG6C2gHfM+PnhjhJK7BbT84Oou3Gnr+4StR6XTb1Aw@mail.gmail.com>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-09-22 at 08:55 +0900, Ryusuke Konishi wrote:
> On Tue, Sep 22, 2026 at 12:22=E2=80=AFAM Aldo Ariel Panzardo wrote:
> >=20
> > nilfs_find_or_create_root() links a new checkpoint root into the
> > checkpoint tree and drops ns_cptree_lock before creating the root's
> > sysfs group.=C2=A0 If nilfs_sysfs_create_snapshot_group() then fails,
> > the
> > root is freed while it is still reachable from ns_cptree, so a
> > concurrent nilfs_lookup_root() can dereference freed memory.
> >=20
> > nilfs_sysfs_create_snapshot_group() allocates memory and creates
> > sysfs
> > nodes and may sleep, so it cannot run under the ns_cptree_lock
> > spinlock.
> > Reorder the creation path so that the sysfs group is set up before
> > the
> > root is published: initialize the root, create its sysfs group
> > outside
> > the lock, and only then take ns_cptree_lock to link it into the
> > tree.
> > On sysfs failure the root was never visible and is freed directly;
> > in
> > the unlikely case a root with the same checkpoint number is already
> > present, the sysfs group of the new root is removed before it is
> > freed.
> > Concurrent insertions are already serialized by
> > ns_snapshot_mount_mutex,
> > so only the race against nilfs_lookup_root() needs to be closed.
> >=20
> > Because kobject_put() does not guarantee that the embedded
> > kobject's
> > release callback has run by the time it returns
> > (CONFIG_DEBUG_KOBJECT_RELEASE defers it), the container must not be
> > freed until the release completes.=C2=A0 Keep that wait_for_completion(=
)
> > of
> > snapshot_kobj_unregister inside the sysfs helpers, so both the
> > creation
> > error path and nilfs_sysfs_delete_snapshot_group() wait for the
> > release
> > before their callers free the root.
> >=20
> > Fixes: dd70edbde262 ("nilfs2: integrate sysfs support into driver")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
> > ---
> > Changes in v4:
> > =C2=A0 - Keep ns_cptree_lock as a spinlock instead of converting it to =
a
> > =C2=A0=C2=A0=C2=A0 mutex, and create the sysfs group before taking the =
lock, as
> > =C2=A0=C2=A0=C2=A0 suggested by Ryusuke Konishi. Concurrent insertions =
are already
> > =C2=A0=C2=A0=C2=A0 serialized by ns_snapshot_mount_mutex; only the race=
 against
> > =C2=A0=C2=A0=C2=A0 nilfs_lookup_root() needs to be closed.
> > =C2=A0 - Move the wait_for_completion() of snapshot_kobj_unregister int=
o
> > the
> > =C2=A0=C2=A0=C2=A0 sysfs helpers (create error path and delete), so the=
 checkpoint
> > =C2=A0=C2=A0=C2=A0 tree functions no longer manage the kobject completi=
on state,
> > as
> > =C2=A0=C2=A0=C2=A0 suggested by Ryusuke Konishi.
> >=20
> > Changes in v3:
> > =C2=A0 - Move wait_for_completion() out of the locked section in
> > =C2=A0=C2=A0=C2=A0 nilfs_put_root() (the mutex-based v2/v3 approach; dr=
opped in
> > v4).
> >=20
> > Changes in v2:
> > =C2=A0 - Serialize the sysfs registration against the tree instead of
> > adding
> > =C2=A0=C2=A0=C2=A0 a second lock, as suggested by Viacheslav Dubeyko.
>=20
> Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
>=20
> Looks good to me.
>=20
> Viacheslav, could you please apply this v4 patch directly?
> (Please keep the 'Cc: stable' tag this time, since this fixes a
> Use-After-Free bug.)
>=20
> One note regarding this change: if a sysfs directory corresponding to
> the checkpoint already exists, nilfs_sysfs_create_snapshot_group()
> will not only return an error, but kobject_init_and_add() will also
> output an
> error message.
>=20
> However, nilfs_find_or_create_root() checks for an existing entry at
> the beginning using nilfs_lookup_root(), and
> nilfs_attach_checkpoint(), which calls this function, is always
> invoked exclusively =E2=80=94 either under 'ns_snapshot_mount_mutex' or
> during
> the serialized initial mount path.
> Therefore, this side effect is avoided.
>=20
> Thanks,
> Ryusuke Konishi
>=20
> >=20
> > =C2=A0fs/nilfs2/sysfs.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 5 ++++-
> > =C2=A0fs/nilfs2/the_nilfs.c | 34 +++++++++++++++++++++-------------
> > =C2=A02 files changed, 25 insertions(+), 14 deletions(-)
> >=20
> > diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
> > index bc52afbfc5c7..5bb74a45ad1e 100644
> > --- a/fs/nilfs2/sysfs.c
> > +++ b/fs/nilfs2/sysfs.c
> > @@ -195,8 +195,10 @@ int nilfs_sysfs_create_snapshot_group(struct
> > nilfs_root *root)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "%llu", root->cno);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >=20
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (err)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (err) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 kobject_put(&root->snapshot_kobj);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 wait_for_completion(&root-
> > >snapshot_kobj_unregister);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return err;
> > =C2=A0}
> > @@ -204,6 +206,7 @@ int nilfs_sysfs_create_snapshot_group(struct
> > nilfs_root *root)
> > =C2=A0void nilfs_sysfs_delete_snapshot_group(struct nilfs_root *root)
> > =C2=A0{
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kobject_put(&root->snapshot_=
kobj);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 wait_for_completion(&root->snapsh=
ot_kobj_unregister);
> > =C2=A0}
> >=20
> > =C2=A0/****************************************************************=
*
> > *******
> > diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
> > index ecd71c190885..1d5d2293c9c7 100644
> > --- a/fs/nilfs2/the_nilfs.c
> > +++ b/fs/nilfs2/the_nilfs.c
> > @@ -869,6 +869,26 @@ nilfs_find_or_create_root(struct the_nilfs
> > *nilfs, __u64 cno)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!new)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return NULL;
> >=20
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 new->cno =3D cno;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 new->ifile =3D NULL;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 new->nilfs =3D nilfs;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 refcount_set(&new->count, 1);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atomic64_set(&new->inodes_count, =
0);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atomic64_set(&new->blocks_count, =
0);
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Register the sysfs group =
before publishing the root in
> > the
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * checkpoint tree.=C2=A0 ni=
lfs_sysfs_create_snapshot_group()
> > can sleep,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * so it must run outside ns=
_cptree_lock; creating it first
> > also
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * ensures a concurrent nilf=
s_lookup_root() can never
> > observe a root
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * whose sysfs registration =
later fails and gets freed.
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D nilfs_sysfs_create_snapsh=
ot_group(new);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (err) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 kfree(new);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 return NULL;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> > +
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock(&nilfs->ns_cptree_=
lock);
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 p =3D &nilfs->ns_cptree.rb_n=
ode;
> > @@ -885,29 +905,17 @@ nilfs_find_or_create_root(struct the_nilfs
> > *nilfs, __u64 cno)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 } else {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 refco=
unt_inc(&root->count);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_=
unlock(&nilfs->ns_cptree_lock);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nilfs_sysfs=
_delete_snapshot_group(new);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree=
(new);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 retur=
n root;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 }
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >=20
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 new->cno =3D cno;
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 new->ifile =3D NULL;
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 new->nilfs =3D nilfs;
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 refcount_set(&new->count, 1);
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atomic64_set(&new->inodes_count, =
0);
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atomic64_set(&new->blocks_count, =
0);
> > -
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rb_link_node(&new->rb_node, =
parent, p);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rb_insert_color(&new->rb_nod=
e, &nilfs->ns_cptree);
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock(&nilfs->ns_cptre=
e_lock);
> >=20
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D nilfs_sysfs_create_snapsh=
ot_group(new);
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (err) {
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 kfree(new);
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 new =3D NULL;
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> > -
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return new;
> > =C2=A0}
> >=20
> > --
> > 2.43.0
> >=20

Applied.

Thanks,
Slava.
