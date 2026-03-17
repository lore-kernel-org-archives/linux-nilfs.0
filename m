Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313233EAC8F
	for <linux-nilfs@vger.kernel.org>; Tue, 17 Mar 2026 15:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773760516; cv=none; b=cmJMmjmBccd7lUxzjZY4E+3AS8050H9sj6Pzg5f4AMcReOZyxR0EpxNnrdl3KMV+a06O+Pwd6PN8UfG9YfIxy5UMxvaIj+YO8lb1qmi8UZew1fEOc/S9JE9iY8h/+8xDPUMWd4iBgaMZe+CMO8f5hYrsSqbCIqvalz0mjfYKgAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773760516; c=relaxed/simple;
	bh=8YklYSi7boixcqDljMgUnEWgfe34j/K8BqVH3D+Dxvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6z+KxHMgqapU6U3cnmLXJLFoZclkBoL6dp3scvBmBwkX23eYCE9Nm2jiJt0XrgpJXJKEIQQBHjG9nK8OmkYoM70DuP22RsjDbxaVhZgG43/A0WLJC2T/duLi4MOTDw/5YbddGPhr4wHUDuWzIaFzvNZOTK9EsEnc0MBbvTITc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W3ukACBk; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W3ukACBk"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8298fad2063so3406082b3a.3
        for <linux-nilfs@vger.kernel.org>; Tue, 17 Mar 2026 08:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773760514; x=1774365314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qYuUdzJOX8A/sSXW3PXSlPWbK+XwKgF5hx90nZXlOy4=;
        b=W3ukACBkrMU9rAUKFBuqWCvKQW2RkO6MsouysChnXF91SG9UVWzdzrQg7qBmaxWqRQ
         OCtk3H+wMx1C7YH7g83zIQZtniyiaV1Q+7wy7++vQMFoPmV9S7VZrZGLzyDht/xB3Mmz
         1N4kHYzvuaaoRYj+2OdHVnu94fFyFa35wSS4ZGM/hFCHEJvPfHreIzSNhBfdDP3tP4vo
         weAPNgGMCB3sOqDHE0FS79IJ1+h3sAHmuaTyU5kTjo9NfMIViAFJ4kQLk6Sy+OC8nj7u
         fIlgGgbgZ8+Z+by59L8gXBQLOW/oyvaMMEObrkyPK2vuAa55YW0JboyJE54BOO3F4Ajg
         3bHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773760514; x=1774365314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qYuUdzJOX8A/sSXW3PXSlPWbK+XwKgF5hx90nZXlOy4=;
        b=V/O2zNASUj1vfiIA5E+OGCrRHqo0lfdWa2LsyYb2+Pkgal4hkPrnwLR1nVNTqtHWXm
         lpfCSKYUcaFtsYx7gkQSGM22W4oi01M6riGTS6SBo3eBv6zAskF5Kdw/SxqBWiheG3kF
         Yo6lrCH7r8MispCEqo+LmeM06fkacMFIs3zas8d+T4XdoXHGm0o03p2zTa0XG+hrbdaz
         EM2FFnoX2ar+1yYhBUtr6TR/swjSJOytvha8RmFB+c6FeVaRf4Pc65Sl9TPPob7kfxna
         A++YmIl7Motcb6Vz9yC1HSzq2K918dLTHdqpJxosgu7vI9AbRlluKiI4u8qL6n2kkS+B
         YV2g==
X-Forwarded-Encrypted: i=1; AJvYcCXNHtYsww2AqcUW6Gatfm/TRtriJbK3fBWN5JnRozqyqIFSj9niypQ02BCr9KPwZLLg8illcKo96K/1IA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxdsw+Ce3H77fBF6hl4SLbuaDVgtUK+6R0WEoRgtWCs4A6gj0Lb
	df8a0dACJ9Fs9y4HKlv50hVDvjgun+DTBujm/4U37mQizni4Lrlmfqds48sHhdcE
X-Gm-Gg: ATEYQzzk39HC6JbIeEpX3MtXHAC2ib9QPLDjDvSUdQ/KnbQ2/5AadXeW6UMUm0Q9xFO
	K50iA8ORm5/vwsMHLUIIHOax/DK3vgKqtdGCxieGgXxWk4aCe6+IcDBNQaQZiKGTlI7aWZ90DHs
	F/OyT4nHUqz9UVtXnktm1QDjARZ0q0FQdxC2nmoCV1ccEE3BEN0lMffW+vVECwsNmZN8RhsH70m
	4aZv7XpXATr3kSz5r0SBGSxIY6HlvRFzCyJ9TQMNdRhf9oeusWZ77G9vCWn4gb1Cu5Ij4OynZLk
	DTBeVC5DodkTsVQuJ2CNBuGea2FS7ilgcxwSAW9EoWKC0lVQfzWtc+/Pfs9/g2U+12r7Q/mYY+f
	XbhFdEVOH4NYf4/s3cpf8OKG5J9LGaZOv3lQylErqJCtFSMp9v6Dp4RiXg6cK9Man/b6Oy4UfZj
	hBC8RS7wfVyDGQ5FbguxT+DIMxfmNXsD5ZY3WlK1J9IOpGJFmXhzsRRT0ZHC5HQcOKWS1a+nSqy
	V4apRU=
X-Received: by 2002:a05:6a21:9146:b0:398:a33a:71b9 with SMTP id adf61e73a8af0-398ecd93939mr16456653637.48.1773760514305;
        Tue, 17 Mar 2026 08:15:14 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:adc8:8291:13a9:ab52])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c73ebb7f270sm12331911a12.28.2026.03.17.08.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 08:15:13 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: eadavis@qq.com
Cc: konishi.ryusuke@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-nilfs@vger.kernel.org,
	slava@dubeyko.com,
	syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] nilfs2: no longer save to shadow map if the num of members is too small
Date: Tue, 17 Mar 2026 20:45:06 +0530
Message-ID: <20260317151506.881298-1-kartikey406@gmail.com>
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
