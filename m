Received: from mail-yx2-f41.google.com (mail-yx2-f41.google.com [74.125.224.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFA743D4FD
	for <linux-nilfs@vger.kernel.org>; Tue, 29 Sep 2026 23:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790725097; cv=none; b=KCuwDfl2m+jUWP5JyKzutpBkag4HsQEhUrTqa+TFxjdVjgsSf2nWKkmL3YPL8hG9YEEiqrIi8BnSPB/6WZzhN3PiBRDRfQW9zOKyfT9wl+tOyL1j8cEIF5leaBsu+nxdcvWG/FrqERj9P4kDjeMORhWqLLiGA30CK2ZwXKpGenM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790725097; c=relaxed/simple;
	bh=I10odQRrWnIIn1oMgCfshWxiTUJPuqRyQuPjXs1+oBw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dpqWSsAzrvv9GySFrvTaa1f7Js8nZJ3mViF41dNS1BSYM4+YmlIHjwCtB8bhxLENNcyQifvCLhFfY5xHNeSQ8owi/Jv48GMju4W/JN2FdEaBdnRkJQ6JGxgVRZER0NDhr0LOTnbrCqS3as2PG7eEts8Vt1OOBMWt+pgyjr+zIPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=Ymho02HO; arc=none smtp.client-ip=74.125.224.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="Ymho02HO"
Received: by mail-yx2-f41.google.com with SMTP id 956f58d0204a3-675bcac8ceeso603367d50.0
        for <linux-nilfs@vger.kernel.org>; Tue, 29 Sep 2026 16:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1790725094; x=1791329894; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZXqJLVCbZu2yjIdVQWm337W+r0cqf+6Xh9H+ELjQb10=;
        b=Ymho02HOM0IMUoQ9ne8LFI367zynZK57ydIabwAaLO+1+vrDlgZ01lEY1oq52aLL4i
         ZLFOisI774dSlXfuSRj+q2J4uig/voOu26DIVg6J+emWnfpNslZR9I6WOKEgNVAfodPQ
         njDui4pvqRrMdD5CPhJKpR04BVcIuoLmLiq7jrE2DiJwERHgvuGjr78Sbeq7jR/3YVam
         yVv2M99XYpUPx4eYWB8eG80OowzA5N9QxxxfTc4V97F5uf4FcgR/zcBct3VwSDvkCLQd
         8hd1saKKgc403W2sAsD5VsGmr//VEp8YgmVQ0yNC3Nj35lsyGCLTeN2GmiTsTS2cdFCw
         a7PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790725094; x=1791329894;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ZXqJLVCbZu2yjIdVQWm337W+r0cqf+6Xh9H+ELjQb10=;
        b=pDyAWJUQGNDaHZcC5ntbCm52TDdKSdRPkmszB2DoelMFhb/IuVXu5uaZXnSrA9VDlU
         xtItve/M+xBNJc7HSPJySWAn82oH7OR/F7rJ4xlCceXI/ux1evb2wI8ClhutHzkY1Fux
         CUBmJIYbUAnR3LH9VMzu7riRsP+SL6Dgo6OMYTDxbcEe0NhUdGjIFnzja73tRtk24IBJ
         ioi4YKHHu7klppy+QyiLtwckhxy1ovi3RhWZbT8rxh1BgMsUrAYmB73GvtFODYTxUpsr
         aU5XAInboO7F1UEodkEqNrxg9rRSTfysZfQOkXKdGGemugr9tl9EUoq2HvYZ+zXUKoT3
         XJsQ==
X-Gm-Message-State: AFq9FYKwxi5wX7wnyWeaElUAVwG5XQm88tMfwQV+MPJhRwR34EHnaHvk
	zYYZP1VKaV2wtCPzH57oQI2fHNURIKkq8u9Ob8QFS7UfSJcKwAyEjsCmEFGJFNhOw0Q=
X-Gm-Gg: AYBFou2pb3aQEfD+iJlxhNqY10FuAlKSO2p2jE0RUc/xr1GxuMTFQrgsznJWdKvvhjE
	vKFUv57slhDbRmDhFwwONpsxuRZb7adGKJa+EBd11FRBHtjWzAICMA6rqi89ulh3UApQM+OSYs8
	NtFc8azpqpq1LPV0Kzt4vsC+eXFYCiGArgBuQx+5ePE8Hirz3ALUbAm7duq0zSBHkJIn/zldN8v
	5Tg0AtpbWAr/kdYRUautfE4oyqQ9f/3psiaCFCIDfLYpCcrifrR2KPcwOQjLarwsHFdMf+O3EqC
	i2u1uso3XPn1UBo4VJ7SWfWEr1sofl83LurqTuFin0Qux+f3F/cotsKFolq0p5m5nPVqfWZf/ze
	yn+q8X5NIc53PEzM238ZvBW3BBcUhfnL7euvOlRg+5fGswLLFL58ktYBZn8uYaDMt1S2qKI0k0x
	Jpho6sIPnMY7SurQvMB9juM5NyXeK8/rJSlJxN/Lr223pK9g4lv0HPBeNOKLTdyxyVV50A6IrSU
	z9ZDyVO4xPVwC3aahHjVBqCqi6zyf1PgPhgBbdSrbn+a7k1t5brnAu52d19+7Z6GTyz5rG08jyS
	u57sDPm/2cPIM8P44l22WBvh0febp7Lg734wYmaL7N+VgSTAhjzClqhhK+OLJKdTzyTAxUxS
X-Received: by 2002:a05:690e:4807:b0:674:aae3:8527 with SMTP id 956f58d0204a3-6764407ab2amr143773d50.48.1790725094493;
        Tue, 29 Sep 2026 16:38:14 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:ace4:86e:1afc:3c4e? ([2600:1700:6476:1430:ace4:86e:1afc:3c4e])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6768082ec26sm53253d50.0.2026.09.29.16.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 16:38:13 -0700 (PDT)
Message-ID: <d95925d563cbee0e9916bbc8f41a7bcf808d1b14.camel@dubeyko.com>
Subject: Re: [PATCH] nilfs2: ignore non-fatal signals during synchronous log
 write wait
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML
	 <linux-kernel@vger.kernel.org>, Wang Jianjian <wangjianjian3@huawei.com>, 
	syzbot+f6c7e1f1809f235eeb90@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Date: Tue, 29 Sep 2026 16:38:08 -0700
In-Reply-To: <20260929182954.109470-1-konishi.ryusuke@gmail.com>
References: <20260929182954.109470-1-konishi.ryusuke@gmail.com>
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

On Wed, 2026-09-30 at 03:26 +0900, Ryusuke Konishi wrote:
> Based on a syzbot report, Wang Jianjian pointed out that following a
> successful directory operation in nilfs_rename(), a synchronous write
> requested within nilfs_transaction_commit(), triggered by a sync flag
> set by nilfs_commit_chunk(), could be interrupted by a user signal.
> This interruption leaves in-memory metadata updates intact while
> returning an error, causing inconsistency with the VFS dentry cache
> and
> ultimately triggering a kernel warning.
>=20
> According to "signal(7)", local disks are not classified as "slow
> devices" (such as terminals, FIFOs, or pipes) and their I/O
> operations
> on disk devices are not interrupted by signals.=C2=A0 In kernel space,
> waiting for such disk I/O should therefore not be aborted by ordinary
> (non-fatal) signals.
>=20
> Suppress this issue by modifying nilfs_segctor_sync(), which waits
> for
> the log writer thread to complete synchronous writes, to catch only
> fatal signals via fatal_signal_pending() and return -EINTR rather
> than
> -ERESTARTSYS.=C2=A0 To complement this change and prevent the wait loop
> from
> busy-looping when schedule() returns immediately due to a pending
> non-fatal signal, switch the wait state from TASK_INTERRUPTIBLE to
> TASK_KILLABLE.
>=20
> This serves as an effective interim stabilization measure without
> structural changes until a comprehensive fix for metadata consistency
> is implemented.
>=20
> Reported-by: syzbot+f6c7e1f1809f235eeb90@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Df6c7e1f1809f235eeb90
> Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
> Tested-by: syzbot+f6c7e1f1809f235eeb90@syzkaller.appspotmail.com
> Cc: Wang Jianjian <wangjianjian3@huawei.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> ---
> Hi Viacheslav,
>=20
> Please queue this for the next cycle.
>=20
> This is the first step toward addressing the state inconsistencies
> during directory operations reported by syzbot or on the mailing
> lists.
> It improves stability by preventing errors caused by user interrupts
> while waiting for log writes, which are triggered by synchronous
> write
> flags following operations such as rename().
>=20
> As this does not fully address the underlying issues in error
> handling,
> I intend to continue exploring changes that allow directory
> operations
> to be properly canceled or rolled back.
>=20
> Thanks,
> Ryusuke Konishi
>=20
> =C2=A0fs/nilfs2/ioctl.c=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0fs/nilfs2/recovery.c |=C2=A0 2 +-
> =C2=A0fs/nilfs2/segment.c=C2=A0 | 10 +++++-----
> =C2=A03 files changed, 7 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 01a04080ef70..b2b67d6a1f09 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -965,10 +965,10 @@ static int nilfs_ioctl_clean_segments(struct
> inode *inode, struct file *filp,
> =C2=A0 * Return: 0 on success, or one of the following negative error
> codes on
> =C2=A0 * failure:
> =C2=A0 * * %-EFAULT		- Failure during execution of requested
> operation.
> + * * %-EINTR		- Interrupted.
> =C2=A0 * * %-EIO		- I/O error.
> =C2=A0 * * %-ENOMEM		- Insufficient memory available.
> =C2=A0 * * %-ENOSPC		- No space left on device (only in a panic
> state).
> - * * %-ERESTARTSYS	- Interrupted.
> =C2=A0 * * %-EROFS		- Read only filesystem.
> =C2=A0 */
> =C2=A0static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
> diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
> index 9a70c28ec94c..abe4101f7550 100644
> --- a/fs/nilfs2/recovery.c
> +++ b/fs/nilfs2/recovery.c
> @@ -790,11 +790,11 @@ static void nilfs_abort_roll_forward(struct
> the_nilfs *nilfs)
> =C2=A0 *
> =C2=A0 * Return: 0 on success, or one of the following negative error
> codes on
> =C2=A0 * failure:
> + * * %-EINTR		- Interrupted.
> =C2=A0 * * %-EINVAL		- Inconsistent filesystem state.
> =C2=A0 * * %-EIO		- I/O error.
> =C2=A0 * * %-ENOMEM		- Insufficient memory available.
> =C2=A0 * * %-ENOSPC		- No space left on device (only in a panic
> state).
> - * * %-ERESTARTSYS	- Interrupted.
> =C2=A0 */
> =C2=A0int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct super_block *sb,
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 2f0e59847d02..af0c3560444f 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2259,7 +2259,7 @@ static int nilfs_segctor_sync(struct
> nilfs_sc_info *sci)
> =C2=A0	wake_up(&sci->sc_wait_daemon);
> =C2=A0
> =C2=A0	for (;;) {
> -		set_current_state(TASK_INTERRUPTIBLE);
> +		set_current_state(TASK_KILLABLE);
> =C2=A0
> =C2=A0		/*
> =C2=A0		 * Synchronize only while the log writer thread is
> alive.
> @@ -2273,11 +2273,11 @@ static int nilfs_segctor_sync(struct
> nilfs_sc_info *sci)
> =C2=A0			err =3D wait_req.err;
> =C2=A0			break;
> =C2=A0		}
> -		if (!signal_pending(current)) {
> +		if (!fatal_signal_pending(current)) {
> =C2=A0			schedule();
> =C2=A0			continue;
> =C2=A0		}
> -		err =3D -ERESTARTSYS;
> +		err =3D -EINTR;
> =C2=A0		break;
> =C2=A0	}
> =C2=A0	finish_wait(&sci->sc_wait_request, &wait_req.wq);
> @@ -2311,10 +2311,10 @@ static void nilfs_segctor_wakeup(struct
> nilfs_sc_info *sci, int err, bool force)
> =C2=A0 *
> =C2=A0 * Return: 0 on success, or one of the following negative error
> codes on
> =C2=A0 * failure:
> + * * %-EINTR		- Interrupted.
> =C2=A0 * * %-EIO		- I/O error (including metadata corruption).
> =C2=A0 * * %-ENOMEM		- Insufficient memory available.
> =C2=A0 * * %-ENOSPC		- No space left on device (only in a panic
> state).
> - * * %-ERESTARTSYS	- Interrupted.
> =C2=A0 * * %-EROFS		- Read only filesystem.
> =C2=A0 */
> =C2=A0int nilfs_construct_segment(struct super_block *sb)
> @@ -2341,10 +2341,10 @@ int nilfs_construct_segment(struct
> super_block *sb)
> =C2=A0 *
> =C2=A0 * Return: 0 on success, or one of the following negative error
> codes on
> =C2=A0 * failure:
> + * * %-EINTR		- Interrupted.
> =C2=A0 * * %-EIO		- I/O error (including metadata corruption).
> =C2=A0 * * %-ENOMEM		- Insufficient memory available.
> =C2=A0 * * %-ENOSPC		- No space left on device (only in a panic
> state).
> - * * %-ERESTARTSYS	- Interrupted.
> =C2=A0 * * %-EROFS		- Read only filesystem.
> =C2=A0 */
> =C2=A0int nilfs_construct_dsync_segment(struct super_block *sb, struct
> inode *inode,


Applied.

Thanks,
Slava.
