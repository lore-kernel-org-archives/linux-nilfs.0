Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB2E10785;
	Wed, 25 Jun 2025 02:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750818455; cv=none; b=OyiDWLgg8UEIVfeBE9CkLKpbksBHDZnpJSj/oALHTFYbSvtoW0xnVblwCO1TSNfMapg99VpHn5Ixe1xBw/729dKt3WBtGBk+AfEUogtE3dGWOOvkwDiQVm85VFpc0zDc+/3N68suQ8MLM5NnGEOYv2eU4Q3/dXC8uniZpGtbEfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750818455; c=relaxed/simple;
	bh=xfLOCkWUstnGQK8VoH4yc1HuwRPQ8panlIf+Bwae70A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RC7VavMlZr9+daVeuv+xAZZH7rusdVUV336ScpnXqWq1/PuSkkJHUgzQ6fDl5OlXm2mZX6R4/gzcejXUkJbuyA/Ny5AMOyLvoxJN7xuvEEWUMStVDdmND9Xwru+E0aSx5JDzNZzG4q3jnJYGlROvoexeECSBuAAaIfSW4BBH+ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l22Z6Yyq; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l22Z6Yyq"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5532a30ac45so435325e87.0;
        Tue, 24 Jun 2025 19:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750818452; x=1751423252; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KMlWAo+QiozFk6BjxvZWUwjnbzKWgh6dn4hJEaOwCS0=;
        b=l22Z6YyqA9AC5YpLDYrA3OuC32XX2wL7uGzerNjvqlZoHYfD8y7+MTYIV5VhjfqD69
         vKAgw4R4OsfIrjgI2G6WKwk+RpHX31gBcPpIf7++iu4DHQr80fGaMGdkDrdGpdr1sghZ
         bgAUXWCB282QAMqHYjg8OY64TVXL7cqpf65KK7nIRpEtr3JwPV6suddA9y8nIacOvvWj
         LeJ6Q5bXynvgiu9X63tkik7gBM3qQeY52gsQupK75gOI5oCePlIGg6IehwOEzwMn2ToA
         PvRrBR5bWfkS7p8srwmxBBcr4txJmC8+tO+qa7NgwOiNqqdm0dTewHlsIPOMnPasPd22
         7WKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750818452; x=1751423252;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KMlWAo+QiozFk6BjxvZWUwjnbzKWgh6dn4hJEaOwCS0=;
        b=aQod1grwzGCdqkYsL5PahJ6SdNXF+P4rO15Y+Ng6ygKdYAfupvNEKmLVxDPrRAPCnZ
         NRCI6gc6DxyHutTblKC4cG5IwAsoW1IeKC64Tu6AA5qPIHIfJfloZJexIvHyu728k9ZR
         lHpr7zDc5cysrCMhx1G1fsyoFDoNv/cyKXjT36Jtbq0YTtjja3EIx4MBe+yOi9ZdAUZp
         C0MxURFX/MXqL2c8Th/XRKLWv6Wq/wni1Fs1Jpy73nA8TDc+5WUFtcWd5xeMLYJ4OSJ3
         hTs9e7hZcWVg7JEvZfcyZBM9Sadpgfdvh4dVeMdV3gBw6TeZxtHtDrSndOkc0tPez98C
         VtKg==
X-Forwarded-Encrypted: i=1; AJvYcCVJdgHgQJmqg4bfnPc4FDR5xSHVQEa9qWQdGR9AKcaLtuCrReOfe+t8fPy5v+zncA/u/LZCa6mM0LFBM7E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ3/CrgbcZI0izowhLuHTxHJEJe6mDbWD8hkEnqbjPjnLK3n0H
	tEYKQl+oF6hUCKede7+aSPRofY/dWCkewrv3R2pXxu0EEA/YJ9wLhlS+VlD9HZJvgxpIkRiO+cV
	JXJOI9xRUjVE8xOAIqTfIuMswYFn262Go3pH0seM=
X-Gm-Gg: ASbGncuqmfnJ70Tdm0/x3ZpqrBXXpwxzAxaA5rHcKkSJxQJpNPNCs2mebVwSZKlDoAC
	Iyotkcao6cahzpdG7fwDoGimnpbwYOmRzu0g4mUEQVm0rEonJ9/Y3H2T7iFpIiLGOJzkPkDaqvn
	Os9WNA6sYcPEA2ONJTn5FpA6mUM3SXzYffieZviAJMRlHTc/dt9iPnIEp+PpQuutgymiEA//Glg
	fGRfw==
X-Google-Smtp-Source: AGHT+IHQc9/3iRv84jBYu+4kDSgCmEMuTsv+ZR1GYPSGZ8fNJa7ljtXss3KlGI3erKzQzKYyi146RThaGD8FY3QYty0=
X-Received: by 2002:a05:6512:1281:b0:553:51a2:440a with SMTP id
 2adb3069b0e04-554fdce6a6bmr278253e87.23.1750818451419; Tue, 24 Jun 2025
 19:27:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <87tt44lwbd.fsf@logand.com>
In-Reply-To: <87tt44lwbd.fsf@logand.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 25 Jun 2025 11:27:14 +0900
X-Gm-Features: Ac12FXyLfVYWAh_viBBHxCiUECUGP-Z82USg5Upqm_KDTBhATvsMlKd_d7i4tc8
Message-ID: <CAKFNMo=GXQzR=19JxPvHaV2v_K7f2LiXr8h6Qx2GzjssC6tvLA@mail.gmail.com>
Subject: Re: BUG: NILFS error (device dm-0): nilfs_bmap_lookup_contig: broken
 bmap (inode number=4023271)
To: Tomas Hlavaty <tom@logand.com>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 25, 2025 at 5:27=E2=80=AFAM Tomas Hlavaty wrote:
>
> Hi Ryusuke,
>
> I get the following error:
>
>    NILFS error (device dm-0): nilfs_bmap_lookup_contig:
>    broken bmap (inode number=3D4023271)
>
> and the filesystem gets mounted read-only.
>
> I can remount the filesystem read-write again manually, but after an
> operation which touches the broken part of the filesystem, it gets
> remounted read-only again.
>
> I have identified the file of the inode:
> sudo find / -inum 4023271
> as
> /root/.cache/mesa_shader_cache_db/index
> but remounting rw and trying to
> rm -r /root/.cache
> puts the filesystem to ro mode again.
> (not sure why there is .cache dir and mesa_shader_cache_db dir in the
> /root dir, I never use root account for GUI)
>
> I am in the process of upgrading the system from nixos24.11 to
> nixos25.05 but this issue is preventing me from doing so.  Is there a
> way to fix the filesystem so that it stays read-write?  Or do I have to
> discard the whole filesystem?
>
> Also I have noticed since long time ago, that reboot or shutdown says
> something about nilfs discarding stuff, which seems strange and those
> messages were not there a year or more ago.  Not sure if this is
> related, but it should not be discarding anything I guess.  I see these
> messages on many machines so it is not related to a particular hardware.
>
> Log and stacktrace are bellow.
> Please let me know if I can provide more info about the problem.
>
> Any help would be appreciated.
>
> Thank you,

Sorry for the inconvenience, and thank you for reporting the details
of the problem.

The log suggests that the b-tree, which is the metadata of the file or
directory with inode 4023271, is corrupted, making it impossible to
read and, as a result, impossible to write.

The /root/.cache/... directory is not created by nilfs, so it is
probably an application directory.

If the problem is only partial, first mount it read-only,

and then try copying it to another device while excluding the
directory from access, for example, by specifying the option
"--exclude /root/.cache" in rsync.

As for in-place repair, the conclusion is that there is currently no
way to do it. The only thing we can do is mount the filesystem
read-only and salvage as much data as possible (without touching the
damage). If you have a backup, it may be quicker to retrieve important
data from there (in any case, nilfs is powerless against block device
corruption, so please make backups as frequently as necessary).

syzbot started reporting a large number of automatically detected bugs
a few years ago, so we have been fixing a lot of serious bugs over the
past few years, and have also strengthened the detection of abnormal
file system states.

That is probably why the abnormal message from a few years ago
(probably a message about dropping to read-only and discarding dirty
data) has become a problem now.

If there were no messages with the old kernel and there were no
problems, you could use it to rescue your data, but since there is a
high possibility that there is some abnormality that was not detected
in the past, this method is generally not recommended.

I hope this helps a little.

Regards,
Ryusuke Konishi

>
> Tomas
>
> $ uname -a
> Linux buta 6.6.87 #1-NixOS SMP PREEMPT_DYNAMIC Thu Apr 10 12:37:44 UTC 20=
25 x86_64 GNU/Linux
>
> $ sudo dmesg | grep nilfs
> [    1.087780] stage-1-init: [Tue Jun 24 19:32:16 UTC 2025] loading modul=
e nilfs2...
> [   35.318251] NILFS error (device dm-0): nilfs_bmap_lookup_contig: broke=
n bmap (inode number=3D4023271)
> [   35.319235] NILFS error (device dm-0): nilfs_bmap_lookup_contig: broke=
n bmap (inode number=3D4023271)
> [...]
> [   35.347872] NILFS error (device dm-0): nilfs_bmap_lookup_contig:
> broken bmap (inode number=3D4023271)
> [ 1733.401421]  nilfs_segctor_do_construct+0xdd/0x2630 [nilfs2]
> [ 1733.401747]  ? nilfs_mdt_fetch_dirty+0x19/0x50 [nilfs2]
> [ 1733.401899]  ? nilfs_test_metadata_dirty.isra.0+0x50/0xb0 [nilfs2]
> [ 1733.402059]  nilfs_segctor_construct+0x170/0x2b0 [nilfs2]
> [ 1733.402220]  nilfs_segctor_thread+0x155/0x3f0 [nilfs2]
> [ 1733.402385]  ? __pfx_nilfs_segctor_thread+0x10/0x10 [nilfs2]
> [ 1738.068626] NILFS error (device dm-0): nilfs_bmap_last_key: broken
> bmap (inode number=3D4023271)
