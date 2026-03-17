Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9983EB80A
	for <linux-nilfs@vger.kernel.org>; Tue, 17 Mar 2026 15:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773760396; cv=none; b=ebhQabPYKJOp2BvA/eba6EqBvy0GDvJ4TWTWQT+qRRTp9ALy99q3P4882rQ9Gqd6ITNR4Mes9MP4yebQNsrMQcjQpUO9JVc6NwxuUraHT5H7+Xx1NXRgnQJSRbvDsd0eP01XuMzlzw6eapi2wgpv1MTWdeTxU6jFVnRTg35pCLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773760396; c=relaxed/simple;
	bh=8YklYSi7boixcqDljMgUnEWgfe34j/K8BqVH3D+Dxvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkNIHI4+mFBCNDWCkulV3wmXGH9dr+chW3lUVshZhNUQCnr53voxXjpEwg9fYIOySCRLXkG/uT/fx8rsWHq3PVtN9+BPsWxA+N0AaPsK6oi6xns0nJ9X+iPMUZJY7I0RuVAA/ZkRUhuCJ4rj9pDJBu1bKRdUTh16NmYiNWQyGs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M3tgGhKe; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M3tgGhKe"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35a1d4a095bso588264a91.0
        for <linux-nilfs@vger.kernel.org>; Tue, 17 Mar 2026 08:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773760395; x=1774365195; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qYuUdzJOX8A/sSXW3PXSlPWbK+XwKgF5hx90nZXlOy4=;
        b=M3tgGhKel/AuanCD4mH8KQuSqMed+P67YM/xwmq9pKKUV3+d/A4eUE4tjMua6tynBj
         E/6u92BwCseuG6CFbgz6SThPT2pU5GE1elE6+ca45QXOdRJlj3aLhPU1Yy1SMZSkuu1Y
         ZfoelizH5XgklUDY87s4fiHLTgAEDewLQJaje6nS+z6hbZTiGc+aEuFgv5+Tyfj14xmA
         o2j4uj53lE/9WX/iG1LvOaeiU0voPRBHvcqJBdHtG/AYAt1NFGCfVZCuCrMJ7e6mbjqc
         +b8+s2XqJCljMiogUZTPkR8DOIxyBVUo/9UqIwQCemVXvY/d76EPiM/OUpuGnVJOV9zW
         tTFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773760395; x=1774365195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qYuUdzJOX8A/sSXW3PXSlPWbK+XwKgF5hx90nZXlOy4=;
        b=UHBg57aRRb60pmV82J40wpO/4mf/03/lni4c61fwJCLdpAO5hQBz2XNUV3Lkh+xH5s
         VZXypzdNXc0MhzmohuJ2tzZFZknzGZm3Y+2HiWDWq+3CdYy77cVAA4fjLXfvWNWJ8I6V
         R2YtQvc1LYj18N8jbwAZpsv8EpgZYTzPOx4dPtBCCrF4Pow7BxbVWZJzSoIM2+yQFM6t
         nNYy9+W/1hjRTQZhQgcdHJa+WuGaS1MIKusi/7UZatfNnSOYP0GuJAyUOrxupvCHciJP
         lBN8m+U1BMAIWWDEjh3XK+9Mjwt+uN9UlJvCj63Jp4hJhzTF22G/9dBcm66m4che3ucW
         K/Vw==
X-Forwarded-Encrypted: i=1; AJvYcCV1H35p7SJ7d4shYJj80jZ0mpueL0EnE+JzbfGm3fimIpKts7RY9gEMQXvuNSXpo66ZqaauLLFS79D56Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyY/5/4fJlJo80hHsN11jpGsVX9w8EBxV8Qh4EyRdy3uXd7r4aH
	XWEIyH2EzyQcv2OGofmuQ/UKUpLcZqGiK+ak4+QMseAcqwV8+FsVd5nf
X-Gm-Gg: ATEYQzwB1NoWDbtyTkgmkkumFObsHHIjYcZJXABthUFmNo/+6SF0302aM2tkNcqHuET
	o3SPaNpRDhJgTqGGE4KrmrbZLJUT7ZQQe8mmO5sR/UjUBHJR51OdjCwAxO76INf0qHgn3dKrod9
	elBaJz6NG5sC/QWv5eVSSK1aLkRKtaLowSdg5Rjcad/o5BVSgwj+JO61UYT3xuJGwZS/82/4AvV
	g1PulQLrcVsO//5JeNIaEWqdYjD9wRdfluEr+kzw30/IKZw62o8SJ4+ui5ZL/xccZrwrp/RCPcA
	l1VgNjS4EAs4k67rA9uYkNCOLKbYqWgNHRjG5ykEPlgM0HmAVJ87hvDS7SlbmBAoaPddyx9zaa8
	79RNdtIm9QHOoVKxtfRPf/qeqHQJiwSX3vvY8ON2Jtn7MOoyG/zEZEoNJfMn7pmzTrtuu16xdfd
	rkMAa/LVKBFwvtcFG9huNa7eRe/eUVMHiAikbPEv8LV5wP5Hda6T5VZD+IGVMhm0B7Q9iyT44rX
	yLmPkw=
X-Received: by 2002:a17:90b:554f:b0:359:8dfc:d39a with SMTP id 98e67ed59e1d1-35bada61fe8mr3126686a91.4.1773760395053;
        Tue, 17 Mar 2026 08:13:15 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:adc8:8291:13a9:ab52])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35b95822ca2sm2972831a91.4.2026.03.17.08.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 08:13:14 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: eadavis@qq.com
Cc: konishi.ryusuke@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-nilfs@vger.kernel.org,
	slava@dubeyko.com,
	syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] nilfs2: no longer save to shadow map if the num of members is too small
Date: Tue, 17 Mar 2026 20:43:06 +0530
Message-ID: <20260317151307.881198-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <tencent_5E9ECE1B9E4B941B182565BAC2BB48336408@qq.com>
References: <tencent_5E9ECE1B9E4B941B182565BAC2BB48336408@qq.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Edward,

On Mon, 17 Mar 2026, Edward Adam Davis wrote:

> The value of argv0.v_nmembs passed from userspace is 0. This prevents
> nilfs_iget_for_gc() from being called to initialize the gcinode during
> the execution of nilfs_ioctl_move_blocks(). Consequently, this triggers
> a null-ptr-deref involving ii->i_assoc_inode within the subsequent call
> sequence: nilfs_clean_segments()->nilfs_mdt_save_to_shadow_map() [1].

This analysis is incorrect. The null-ptr-deref is not caused by
nilfs_iget_for_gc() not being called. The real problem is that
ns_dat->i_assoc_inode (the DAT inode's btree node cache) is never
initialized at mount time.

> A check for argv[0].v_nmembs has been added to nilfs_clean_segments()
> to prevent this potential null-ptr-deref of ii->i_assoc_inode.

This fixes the symptom but not the root cause. Also note that in
the original syzkaller reproducer:

    argv[0].v_nmembs = 0xd = 13 > 0

Your check would NOT prevent the crash with the original reproducer.

The correct fix is to initialize the btnode cache eagerly in
nilfs_dat_read() at mount time, since i_assoc_inode is only
initialized lazily during btree operations. When
NILFS_IOCTL_CLEAN_SEGMENTS is called before any btree operation
has occurred, i_assoc_inode is NULL.

I have already submitted this fix and syzbot confirmed it as fixed:

https://lore.kernel.org/all/20260317090109.878401-1-kartikey406@gmail.com/T/

Regards,
Deepanshu Kartikey
