Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B841540242C
	for <linux-nilfs@vger.kernel.org>; Thu, 30 Apr 2026 12:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777551215; cv=pass; b=I7QyxTVItSAoJQ0RSy2h/jYgiiTWqNo+48vqYUc4OR5gyD10c9VORwqDR/vlHuAWCvq4HBtMbzjRFYrLABDlzbvx4x8PRnEpG/hfliSU02z+2D0HoJ5fDlPxUlV6I/yoZtrS9r/fl4DATZWYzGQYDVXNixBtokqjsCB7qWxEaXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777551215; c=relaxed/simple;
	bh=TXDa7NSy3a1jhWRS3H4Tp3vEJQ8F5w1HWUyRgirZx6M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fs3zLwjUu9n7VXnrty8MI+KHwSE0nqxYYwiY4Y+NRadHsKcVmWH+p4LzLU8QcD0HcXedHgZhDuNWltcTUkbLH3ALHMA0sx+aY+nlCnd5iE4cld6vSy5sUGCbdjxze12f/mwXbO+vt0W+brTlKPFcFMWjmz16j6H/MW/pae0kKW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ci9Sy1pl; arc=pass smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ci9Sy1pl"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-38e800deae4so7726181fa.0
        for <linux-nilfs@vger.kernel.org>; Thu, 30 Apr 2026 05:13:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777551212; cv=none;
        d=google.com; s=arc-20240605;
        b=UT5y2CcY3xO1KAaOMt4tTAiYRnwszCpsoFigPA9TBG8cfJwgJt/ksPsi/B+9ermZLU
         Y/zGziPMI+yI08l71GWs8kJE+8MwHw2ClGt0jA8N2rChC+L+MfH6vv6a0zO7N8hVMLAL
         PiYsXHNFrDMpYdqjsRCg3V02MzFv8Ytn3m3FzZp57zkI3+pAr0p5zzs8D1L9e4HqdqhI
         ZUZDvYPnUWWQuF4WMROmnDCP4jv6asgZUNiDrlIdsGUEEUefjG4kwJqVd4p457lziIT7
         2W0s40cvtUfcY5bztNAmUVoxPz1nY8/TkKbRyA5htuF589o3trILg2R68960TaUQow1Q
         YN9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gYuaEj62f6abXXXknGHMgNIJHgrJvbt+knMI7MVBneE=;
        fh=I/c+HIofH3Gh9Hq3W6xHDM+7v1EBQen1gLaZdhwa1a8=;
        b=VJ1qLiUcptkkuzGWyzhdstRdDYliYgOSkJQc0p9UCHM0uvdIxo6kAzVXIca3maefo5
         EUfeodPO7w7J9e9Fz83j1zQTkEXRFl4fV6QnMVG+LgmNkCw8xC5qjq3eXYGpiBzi4JoO
         4dAfr2ipqjm6bQizQuV0FGFBzE3VkKkJcXPLXZsOwrOuvnsN3dH+X049RyPfchomRw7d
         f7C9E9MoWk567EXXDUqTFzHYDkSmPed+DxiIaSo3IOJfYnc/+pxZeeQSHrPb3T0iAUF8
         wErQvAcj0CsXpxf9JovQM9nLoC0AEuYicODp2g1Pbiv68vuUkArbN5ZcDwjmjuRKyttU
         0XiQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777551212; x=1778156012; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gYuaEj62f6abXXXknGHMgNIJHgrJvbt+knMI7MVBneE=;
        b=Ci9Sy1plPyQU4UoMlE0Hah7bQf63oXJiek5ZesbqNjgEH21rFGHD36u6T9Kf4v01Vn
         oOfWHQJvCp8pb7cARwTB7z+drZx5rl8eBxO7CFk3Km9LucjovE0Xj4s0ZiVkjWJ4ZS3I
         7qXAjMhucUwGYGkKzARdVpcZtK/d5t+Xm4pYQ8IGpjBM580Qe6ZUjp9eDLTw6uAyF4lO
         tEl7VH9DQ8/aUXlo2RCdItpMbZbWLYNdPHJkCMbgSyL+Zt+JZyHR0AMObSDjFfXuh7rR
         rq1o7KagK+cbxAbnWLTJec5pJ72lJpr0lHsZ4A0sB3u1xKLyOPcRZBOZhRaFSbjBUNoa
         ObeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777551212; x=1778156012;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gYuaEj62f6abXXXknGHMgNIJHgrJvbt+knMI7MVBneE=;
        b=akSevNFGaSqZlxRlY45dmKiyVSEqRl1t5lDtQFnIGHcA+jT8xpO2nKhMsLlMNySY87
         ucuZf5mZS4hVNIgqeOk25w+tLQD6SDdz5DVd0fl5VrsZbtaXEdkwLP5MRxWj6c0hltXa
         gfljSbadYLmw/mTanCDMKK0q8w8gCy8zmTaAzcQHDxRcylmfjoIXG48YDbbd9YGCqF6H
         1lP25r0lUD5MfgkeFuTVHhZXC5hgON15MWHpt4XoKG62Na+mjD/Ff7eYDgYsqnsZSHYm
         Vuo0sbQiGch0L9oy9cEgM95JV92UZlY7n92S7BE7Bo5wRjWI+Og/cfdk8MXtf6EO9C5J
         B8XA==
X-Forwarded-Encrypted: i=1; AFNElJ/qPCi6Gw7iDM9cvxR8hjLygcIxA+orOQT3oGgFTaODoAM12qaCF9vcSSMSIJJ4MX7LKPNUb93suWCTog==@vger.kernel.org
X-Gm-Message-State: AOJu0YyOldLhrzeSHo8z/b2JkSRbJ3F5+HZGl5fD53kOBFneef0o682s
	sURSZYcUhLdhXyipQ99XbfbGmwx6ECAAxm+Pwded5cLro/5MdCknSypTqRdb5y5bPJQmvG7i17P
	L18xfq3SL22MkWqdv1WlEXqFThIrujgs=
X-Gm-Gg: AeBDiesf4k2uob3XGYfX3edc92KIPuaeZZFrlwFcTi6sv/JHNXx+ubrBfZ3/nn6nESS
	FQwcqvWCI4LUnDLRQn13nIw5cEV9tSJ3LIyj/CD9kxmYeJkiPw9ska+yomwE8zu4J9UrpxfFzqh
	zMK+0oGV7W+o/1+zago/Lcvmkj7yxas7PE4ZpI/HhXQYrFhKg/jnXeZq1s7IeSnuD/w4t/zeTwV
	J0aniZRrjVntFOxLZLLTHH9fhm4JAujU1aYIwb4PQZIkut/UUpVYl954ppH4yRIlVi21xR1lpGx
	5GKne+c5+ZyQTHlY6rI=
X-Received: by 2002:a05:6512:3b28:b0:5a6:2a5f:11d with SMTP id
 2adb3069b0e04-5a8522d4b14mr982679e87.26.1777551211529; Thu, 30 Apr 2026
 05:13:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260430040704.113622-1-kartikey406@gmail.com>
In-Reply-To: <20260430040704.113622-1-kartikey406@gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 30 Apr 2026 21:13:15 +0900
X-Gm-Features: AVHnY4Iy8pyMuz7kCxFxo_q6faXjAqhfSG5inFa-dNzyMIHUZn4zGe-SBjClBdU
Message-ID: <CAKFNMo=_mkGn6OtXXcjhiYFQ2cvBVisPbSsRMz3XBqxHvByyMw@mail.gmail.com>
Subject: Re: [PATCH v3] nilfs2: reject CLEAN_SEGMENTS ioctl with out-of-range
 segment numbers
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: slava@dubeyko.com, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 30, 2026 at 1:07=E2=80=AFPM Deepanshu Kartikey wrote:
>
> Syzbot reported a hung task in nilfs_transaction_begin() where multiple
> tasks performing chmod() on a nilfs2 mount blocked for over 143 seconds
> waiting to acquire ns_segctor_sem for read:
>
>   INFO: task syz.0.17:5918 blocked for more than 143 seconds.
>   Call Trace:
>    schedule+0x164/0x360
>    rwsem_down_read_slowpath+0x6d9/0x940
>    down_read+0x99/0x2e0
>    nilfs_transaction_begin+0x364/0x710 fs/nilfs2/segment.c:221
>    nilfs_setattr+0x124/0x2c0 fs/nilfs2/inode.c:921
>    notify_change+0xc1a/0xf40
>    chmod_common+0x273/0x4a0
>    do_fchmodat+0x12d/0x230
>
> The writer holding ns_segctor_sem was a concurrent
> NILFS_IOCTL_CLEAN_SEGMENTS caller, stuck inside printk while emitting
> per-element warnings from nilfs_sufile_updatev():
>
>    __nilfs_msg+0x373/0x450 fs/nilfs2/super.c:78
>    nilfs_sufile_updatev+0x21c/0x6d0 fs/nilfs2/sufile.c:186
>    nilfs_sufile_freev fs/nilfs2/sufile.h:93 [inline]
>    nilfs_free_segments fs/nilfs2/segment.c:1140 [inline]
>    nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1261 [inline]
>    nilfs_segctor_do_construct+0x1f55/0x76c0
>    nilfs_clean_segments+0x3bd/0xa50
>    nilfs_ioctl_clean_segments fs/nilfs2/ioctl.c:922 [inline]
>    nilfs_ioctl+0x261f/0x2780
>
> The root cause is that user-supplied segment numbers are not validated
> before nilfs_clean_segments() begins doing work; the range check on
> each segnum is performed deep inside the call chain by
> nilfs_sufile_updatev(), which emits a nilfs_warn() per invalid entry
> while still holding the segctor lock and the sufile mi_sem.  Under load
> (repeated invocations across multiple mounts saturating the global
> printk path), the cumulative printk latency keeps ns_segctor_sem held
> long enough to trip the hung_task watchdog, blocking concurrent
> operations such as chmod() that need ns_segctor_sem for read.
>
> Fix by validating the contents of kbufs[4] in nilfs_clean_segments()
> immediately after acquiring ns_segctor_sem via nilfs_transaction_lock().
> Holding ns_segctor_sem serializes the check against
> nilfs_ioctl_resize(), which can modify ns_nsegments, so the validation
> uses a consistent value.  Out-of-range segment numbers are rejected
> with -EINVAL before any segment-cleaning work begins, so the bad
> entries never reach the per-element diagnostic path inside
> nilfs_sufile_updatev().
>
> Reported-by: syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D62f0f99d2f2bb8e3bbd7
> Tested-by: syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com
> Fixes: 4f6b828837b4 ("nilfs2: fix lock order reversal in nilfs_clean_segm=
ents ioctl")

The cause appears to be commit 071cb4b81987 ("nilfs2: eliminate
removal list of segments"), which removed the segment release logic
that used a list of segment information structures.
Prior to that, the validity check of segment numbers was performed
within nilfs_ioctl_prepare_clean_segments().

Everything else seems OK, so I'll fix only that tag myself, perform a
final check, and then send it upstream.

Thanks,
Ryusuke Konishi

> Cc: stable@vger.kernel.org
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
> Changes in v3:
>   - Move validation from nilfs_ioctl_clean_segments() into
>     nilfs_clean_segments(), under ns_segctor_sem held for write
>     by nilfs_transaction_lock(), to serialize against
>     nilfs_ioctl_resize() which can modify ns_nsegments
>     (Ryusuke Konishi)
>   - Introduce local variables segnumv and nfreesegs for readability,
>     rather than open-coding casts of kbufs[4] (Ryusuke Konishi)
>   - Emit nilfs_err() once on the first out-of-range segnum and bail
>     out, instead of nilfs_warn() per element (Ryusuke Konishi)
>   - Add bail_unlock label for the early-failure path, parallel to
>     the existing out_unlock structure (Ryusuke Konishi)
>
> Changes in v2:
>   - Reuse existing 'n' loop variable instead of introducing a new
>     one (Slava Dubeyko)
>   - Add dedicated out_free_segnums label so the validation-failure
>     path falls through the existing cleanup ladder rather than
>     duplicating kfree(kbufs[4]) inline (Slava Dubeyko)
> ---
>  fs/nilfs2/segment.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 1491a4d4b1e1..dc54643866ce 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2512,12 +2512,33 @@ int nilfs_clean_segments(struct super_block *sb, =
struct nilfs_argv *argv,
>         struct nilfs_sc_info *sci =3D nilfs->ns_writer;
>         struct nilfs_transaction_info ti;
>         int err;
> +       size_t i, nfreesegs =3D argv[4].v_nmembs;
> +       __u64 *segnumv =3D kbufs[4];
>
>         if (unlikely(!sci))
>                 return -EROFS;
>
>         nilfs_transaction_lock(sb, &ti, 1);
>
> +       /*
> +        * Validate segment numbers under ns_segctor_sem (held for write
> +        * by nilfs_transaction_lock above) so the check is serialized
> +        * against nilfs_ioctl_resize(), which can modify ns_nsegments.
> +        * Rejecting bad input here, before any segment-cleaning work
> +        * begins, avoids the per-element diagnostic path inside
> +        * nilfs_sufile_updatev() that would otherwise run under this
> +        * same lock and stall concurrent readers.
> +        */
> +       for (i =3D 0; i < nfreesegs; i++) {
> +               if (segnumv[i] >=3D nilfs->ns_nsegments) {
> +                       nilfs_err(sb,
> +                                "Segment number %llu to be freed is out =
of range",
> +                                (unsigned long long)segnumv[i]);
> +                       err =3D -EINVAL;
> +                       goto bail_unlock;
> +               }
> +       }
> +
>         err =3D nilfs_mdt_save_to_shadow_map(nilfs->ns_dat);
>         if (unlikely(err))
>                 goto out_unlock;
> @@ -2558,6 +2579,7 @@ int nilfs_clean_segments(struct super_block *sb, st=
ruct nilfs_argv *argv,
>         sci->sc_freesegs =3D NULL;
>         sci->sc_nfreesegs =3D 0;
>         nilfs_mdt_clear_shadow_map(nilfs->ns_dat);
> + bail_unlock:
>         nilfs_transaction_unlock(sb);
>         return err;
>  }
> --
> 2.43.0
>
>
