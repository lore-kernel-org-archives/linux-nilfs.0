Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1AA4C8C60
	for <linux-nilfs@vger.kernel.org>; Tue, 15 Sep 2026 18:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789498170; cv=none; b=rQxe/lXvadhNeYRDmfSLsgPq38lvqtXoWF/lr/AcWZAthbkWP/EqK36phbEkDzayDXJQFOhk3F91xnRU3L6AsYRxk45nx4Q/77oD+wJ3oZvR2ukjDmSnXgSBxGr+HBx3R8Jy01U+IhrbXcXRh/ZuNyaQJP0CCeT8T/c8czFUDCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789498170; c=relaxed/simple;
	bh=dn0nYsAAmXuOK3R+wRJqX7TPcEmhQYGi/QPpsB0ZaEQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T9qu62SJwF5AZnCrCpRQ9GvXqdpRtZ72L89GBD5ColUE8sLd005lYQMbWz/EMe7EF2kMh4qaXvPWabxS2Xxg3yNC9o0CREf7iifOqld5ocyqjelPnRT3b/ns0PuJzOOd4lLZA5g70lN7b/kcoeSGo3Lte0/gO6z4KyN/s5s7n+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=MSrt+0bs; arc=none smtp.client-ip=74.125.224.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="MSrt+0bs"
Received: by mail-yx2-f43.google.com with SMTP id 956f58d0204a3-671017a4b55so100233d50.2
        for <linux-nilfs@vger.kernel.org>; Tue, 15 Sep 2026 11:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1789498167; x=1790102967; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8sOdqh+xMVjOPfQTmb4GlIFWW+djME37k9ELcXIHIfs=;
        b=MSrt+0bsGkmYdM+x4/yC1LLmriZQ3N7OkDhwkkO+SHphTgw41hTRGswJvMaprNluLh
         w1LoN3rEiv87JPHt4pUfbaPBIm9UabC/Q7p+2ep2YJ+AFXqhBvXDXTSZBmc/tu+4azkw
         M1YzAagkIyFNMtfplLR5vfXDA2ejRqM7X/JTVD1b4ZbBh9bB9CSZDlLRzSoPm97xi2AQ
         7MW0VS4Ooo3H9YzTp9ozdD6jLR0/N5wvOzJ/2HhVpnHVcb7Te88lgc8ZcMW+GWIybDqr
         bvdQiFkYKxNlD+YkTuzWF+amwWcQLA9WSsjAcz1uvV7KMi60Z06O538GfOnBSyhA19Ml
         7aCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789498167; x=1790102967;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8sOdqh+xMVjOPfQTmb4GlIFWW+djME37k9ELcXIHIfs=;
        b=KO5xxrQJoxfU2VYzqYgg3YUfIoqhim8Rgc0C48n2ptzknp7MjWIcK1tV2kzO/qzqzz
         xupZeKRdkByKoq1qWfn5Qe6Q/5UOKo9uZF//R2CmnNqjkYtuQKHVPb4T8r6JuVYXI2Rj
         ZYTxbqmA6mYdMmZ2wHXdJxYrstOCxo9/B2p/L//MF4YAcgrQABcmxL96jtAyIwKKyzjv
         U0Ly0DfFYnuGC9H3BvOMg/faYvPJFf4UGEovHWeaRo7AFHVdvdAKa8hL0KMUDG3a2dp5
         3E52j2z7SXRwBRxqUdGnbFNdQFWIp595h4aW74vpmKEBr2a8Ms9BRExSkkOIbIftxHsu
         mKcQ==
X-Gm-Message-State: AFuF++m8VF+dgwCtxAesqTHOid5xSfPZ6W+YW6FRH0G6Oy0X5gDRuSBU
	yKbOZu4TtoMJqf0m6rqw8Mq7EOOuXfmr5LQvUM5RdrSvI1F/viwWqhrV4wuVNk6g8k1APNDCFb9
	pUW9l9XV7wQ==
X-Gm-Gg: AYBFou3xU5AzQcAAkmm4faQVYM6okKfRHmpichliDlcrExi9q0jyXRGuzDWU6urSHcM
	wMBqEoPCyf88bXg0XxkMMmNi6+Qy3xzobddwsjUv/UDf3GjNxK3TyZESDg7OI/HWMWGQjaRJ/gp
	KFNSoYDTR9aT4A5htTiUwW+WhqRPToqYlgGpU4nl4K0RAtp6TDRQkPn06Vg7UC2ZndQGnGy9jfD
	AoEba/287WOmfq658GpTEk1pgb5FrXfnA3I3mPNko3Y+96KJiZ70SxYfwaNeEK2PBQ3WxbP6+Iv
	5ag+mZyeCguBr5FQC79s9dldixFWAV5cro7H9kme3wRNIdzf4RQkqI5fKsZC68PBxRiBXq3SL+b
	Apq4l9xoFMJsj2y01Sgm/wMACtViK1moivV8iX3oeFd05AxKQUXiVSlRUiR7ukjJSIyakFGKe5Q
	ie+GhYd3z++1EmbA+xlXcrqZgE4OnGUAaGJ1sJKD7vY6ZaXxN7xw+aj90A4wPAmjJHifzebjVWY
	73F8haHyMETlJ/zAClRvTRrR58ySjHgl8uL0lWV+UY+f8OJVSpLYA2m4gGJfExVCN1HfWjFBgyH
	9DuG2/5gg1AEDoJPiy5EEmS29SgWS80B2PHmPNkq9QCdkBkx35k2X/ZX26cZMXmu
X-Received: by 2002:a05:690e:1208:b0:671:2d6e:b7ec with SMTP id 956f58d0204a3-6715c93e52cmr1270970d50.0.1789498167258;
        Tue, 15 Sep 2026 11:49:27 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:e9c6:4a77:70a9:9f1d? ([2600:1700:6476:1430:e9c6:4a77:70a9:9f1d])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-891ee4a536asm509227b3.10.2026.09.15.11.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 11:49:26 -0700 (PDT)
Message-ID: <e4f31d1ee16d537368a65c916597cdc1f28e32c1.camel@dubeyko.com>
Subject: Re: [PATCH] nilfs2: fix checkpoint root lifetime on sysfs errors
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Aldo Ariel Panzardo <qwe.aldo@gmail.com>, Ryusuke Konishi
	 <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Date: Tue, 15 Sep 2026 11:49:25 -0700
In-Reply-To: <20260915041206.2430937-1-qwe.aldo@gmail.com>
References: <20260915041206.2430937-1-qwe.aldo@gmail.com>
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

On Tue, 2026-09-15 at 01:12 -0300, Aldo Ariel Panzardo wrote:
> nilfs_find_or_create_root() publishes a new root in the checkpoint
> tree before creating its sysfs object.=C2=A0 If sysfs registration fails,
> the root is freed while it is still reachable from the tree.=C2=A0 Merely
> erasing it in the error path is insufficient because a concurrent
> lookup may already hold a reference.
>=20
> Serialize root creation and removal, finish sysfs registration before
> publishing the root, and wait for the embedded kobject release before
> freeing its container.=C2=A0 The wait also makes normal root removal safe
> when kobject release is delayed.
>=20
> Fixes: dd70edbde262 ("nilfs2: integrate sysfs support into driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
> ---
> =C2=A0fs/nilfs2/the_nilfs.c | 38 +++++++++++++++++++++++++-------------
> =C2=A0fs/nilfs2/the_nilfs.h |=C2=A0 3 +++
> =C2=A02 files changed, 28 insertions(+), 13 deletions(-)
>=20
> diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
> index 7b23e373a..01389dba2 100644
> --- a/fs/nilfs2/the_nilfs.c
> +++ b/fs/nilfs2/the_nilfs.c
> @@ -71,6 +71,7 @@ struct the_nilfs *alloc_nilfs(struct super_block
> *sb)
> =C2=A0	spin_lock_init(&nilfs->ns_last_segment_lock);
> =C2=A0	nilfs->ns_cptree =3D RB_ROOT;
> =C2=A0	spin_lock_init(&nilfs->ns_cptree_lock);
> +	mutex_init(&nilfs->ns_cptree_mutex);
> =C2=A0	init_rwsem(&nilfs->ns_segctor_sem);
> =C2=A0	nilfs->ns_sb_update_freq =3D NILFS_SB_FREQ;
> =C2=A0
> @@ -881,8 +882,15 @@ nilfs_find_or_create_root(struct the_nilfs
> *nilfs, __u64 cno)
> =C2=A0	if (!new)
> =C2=A0		return NULL;
> =C2=A0
> -	spin_lock(&nilfs->ns_cptree_lock);
> +	new->cno =3D cno;
> +	new->ifile =3D NULL;
> +	new->nilfs =3D nilfs;
> +	refcount_set(&new->count, 1);
> +	atomic64_set(&new->inodes_count, 0);
> +	atomic64_set(&new->blocks_count, 0);
> =C2=A0
> +	mutex_lock(&nilfs->ns_cptree_mutex);
> +	spin_lock(&nilfs->ns_cptree_lock);
> =C2=A0	p =3D &nilfs->ns_cptree.rb_node;
> =C2=A0	parent =3D NULL;
> =C2=A0
> @@ -897,29 +905,28 @@ nilfs_find_or_create_root(struct the_nilfs
> *nilfs, __u64 cno)
> =C2=A0		} else {
> =C2=A0			refcount_inc(&root->count);
> =C2=A0			spin_unlock(&nilfs->ns_cptree_lock);
> +			mutex_unlock(&nilfs->ns_cptree_mutex);
> =C2=A0			kfree(new);
> =C2=A0			return root;
> =C2=A0		}
> =C2=A0	}
> -
> -	new->cno =3D cno;
> -	new->ifile =3D NULL;
> -	new->nilfs =3D nilfs;
> -	refcount_set(&new->count, 1);
> -	atomic64_set(&new->inodes_count, 0);
> -	atomic64_set(&new->blocks_count, 0);
> -
> -	rb_link_node(&new->rb_node, parent, p);
> -	rb_insert_color(&new->rb_node, &nilfs->ns_cptree);
> -
> =C2=A0	spin_unlock(&nilfs->ns_cptree_lock);
> =C2=A0
> =C2=A0	err =3D nilfs_sysfs_create_snapshot_group(new);
> =C2=A0	if (err) {
> +		mutex_unlock(&nilfs->ns_cptree_mutex);
> +		wait_for_completion(&new->snapshot_kobj_unregister);
> =C2=A0		kfree(new);
> -		new =3D NULL;
> +		return NULL;
> =C2=A0	}
> =C2=A0
> +	spin_lock(&nilfs->ns_cptree_lock);
> +	rb_link_node(&new->rb_node, parent, p);
> +	rb_insert_color(&new->rb_node, &nilfs->ns_cptree);
> +
> +	spin_unlock(&nilfs->ns_cptree_lock);
> +	mutex_unlock(&nilfs->ns_cptree_mutex);
> +
> =C2=A0	return new;
> =C2=A0}
> =C2=A0
> @@ -927,13 +934,18 @@ void nilfs_put_root(struct nilfs_root *root)
> =C2=A0{
> =C2=A0	struct the_nilfs *nilfs =3D root->nilfs;
> =C2=A0
> +	mutex_lock(&nilfs->ns_cptree_mutex);
> =C2=A0	if (refcount_dec_and_lock(&root->count, &nilfs-
> >ns_cptree_lock)) {
> =C2=A0		rb_erase(&root->rb_node, &nilfs->ns_cptree);
> =C2=A0		spin_unlock(&nilfs->ns_cptree_lock);
> =C2=A0
> =C2=A0		nilfs_sysfs_delete_snapshot_group(root);
> +		mutex_unlock(&nilfs->ns_cptree_mutex);
> +		wait_for_completion(&root-
> >snapshot_kobj_unregister);
> =C2=A0		iput(root->ifile);
> =C2=A0
> =C2=A0		kfree(root);
> +	} else {
> +		mutex_unlock(&nilfs->ns_cptree_mutex);
> =C2=A0	}
> =C2=A0}
> diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
> index 4776a70f0..72affad9e 100644
> --- a/fs/nilfs2/the_nilfs.h
> +++ b/fs/nilfs2/the_nilfs.h
> @@ -68,6 +68,7 @@ enum {
> =C2=A0 * @ns_sufile: segusage file inode
> =C2=A0 * @ns_cptree: rb-tree of all mounted checkpoints (nilfs_root)
> =C2=A0 * @ns_cptree_lock: lock protecting @ns_cptree
> + * @ns_cptree_mutex: mutex serializing checkpoint root creation and
> removal
> =C2=A0 * @ns_dirty_files: list of dirty files
> =C2=A0 * @ns_inode_lock: lock protecting @ns_dirty_files
> =C2=A0 * @ns_gc_inodes: dummy inodes to keep live blocks
> @@ -151,6 +152,8 @@ struct the_nilfs {
> =C2=A0	/* Checkpoint tree */
> =C2=A0	struct rb_root		ns_cptree;
> =C2=A0	spinlock_t		ns_cptree_lock;
> +	/* Serialize root creation and removal. */
> +	struct mutex		ns_cptree_mutex;

Do we really need another lock here? If the ns_cptree_lock is not good
enough, then, maybe, we need to change the lock type? But adding the
another lock for ns_cptree looks strange for my taste.

Thanks,
Slava.

> =C2=A0
> =C2=A0	/* Dirty inode list */
> =C2=A0	struct list_head	ns_dirty_files;
