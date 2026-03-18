Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805F320B810
	for <linux-nilfs@vger.kernel.org>; Wed, 18 Mar 2026 00:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773795272; cv=pass; b=iv1x19UN3UokMVBo9EhdoH+pi2FB6kL5llE4lhGR8ue6fuKc102V2Pg/vug/OXFxR3fGVDJyTjeEBO9tP0uTk8V4ocKMMp+dMaTtJfaksbfvTh6cdun9S8UX+27A26tkgAQg6r5TneQNIqnD3DetB9RrxTAB3wtLBxdMssrePV8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773795272; c=relaxed/simple;
	bh=tRudtIwxZWMclOIMf+pjG90Dq6LGmVdgqwsjiqaYPdk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p+WJdaVgXVIfY3r96tqAoAyw/7W5S4vy2uJTRRnWSST6GM8PFBsVoxiFwopjKfc/V6xcgLblt8JguZBW+6XG/344NhtPJ/vqbii1Xg/0c5ZqQLllRJ5P3Crprtiminu5zRovTz8rDz88Ie/3hq1To+S2S44FmClqO7PcebtUk8U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mggl4Xy5; arc=pass smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mggl4Xy5"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5a1362c9a3cso6841708e87.2
        for <linux-nilfs@vger.kernel.org>; Tue, 17 Mar 2026 17:54:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773795270; cv=none;
        d=google.com; s=arc-20240605;
        b=Jgu79G2vyHRuAAffEi/goLrK4yGGHXo3bRk0Ts5I1ryauf6GwpjrI57wYdwBcYvSYj
         vg6+anos9mBWgCZ5yUzUAmHrgjobOzDEiN8ID1ENs8o/ENYKglQhWHTS7ZdD8AMpS0Su
         cE2/9WVMDCL+VK0rBV8DYkv/YX51i0EjWMbaiHuSq34ws+A5TpcK/26a4a76PQG1RA46
         bJ+E6FYTOwDlDMxmHWlIw+eBLf7vqo3YjOl+uBl4BWl5/T+yv9HjDdRBAI0weWUlCJdN
         HZHkIK8DwqURhaIzNVMzZz7uNcldsyxzuJTWhfHxdpo2mMsk0e0e5PaMhDFB5IB9EsnP
         oAig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Yw9l0aedvmKKSLaXzeaoeNAPaVX9A4V63AUCKJYoKN4=;
        fh=yq2yxYr2IHOUGqXh0MK+xEUnDRk1no3ZMRJF4qsRvBo=;
        b=Ge8nqWIhQ6BibRKwpRZFmpCv/bOrEWfGC2Y4ZlGgcvsK2e/Ggu4DHL6yeHdG+YpnMp
         qvp8yCVEk+WcYQX+RxqrwT7UfyS00Vby9zLfkFRGdH7zzY9M1fp5qh/Vh757BbH/u07l
         gRiGUl6wvotJJD+YC6eYDv+5bnMKhI4vGM0bg6fKNx1kc6Dp2KJ5DFtMJWSlDvS12wn3
         0goiE4oVmboi1SIiF4t1EVSbXPYVVNlGxqRZOwKUqB6fAOSYsNoVBKQhwV3G0YxeCVOI
         cgVI7whOiEg8LmU2rsQB2TdRrHP2Wcz3Ar1pPFCs31ytoubhzCo0izQE9dsVORcQUpfI
         ZP1w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773795270; x=1774400070; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yw9l0aedvmKKSLaXzeaoeNAPaVX9A4V63AUCKJYoKN4=;
        b=Mggl4Xy5rtcx4xaOgEh66CUrX8PMxiylxYY8K9GVTxhQzUnSBgLzuXaB4+HRKepU1m
         LeQt7n1YgEf22OoEzeyF2NFIeQAucfKeVBpBF6w2+1XuNeRIgC5AiZYglffKJYPwKHZQ
         3z5JkJXC2bkQI9ye9p4ZM2KPdwzfvBDtW6rNeQpw2rWoE73BUub4NfvCYRF42/XgI069
         ZfooKGMEJ6gJXct6mAHXZzLSnDZPFBYALWekJk0N0eUc2r7VxlQ0cukhydMccN5V5GXj
         vqlcdxU9HrXZh50YwIWWvQQkDdU84WXr1ArER6ocU3G1B9MFgmfSOLdQ8nTx6kumwLpa
         NHpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773795270; x=1774400070;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Yw9l0aedvmKKSLaXzeaoeNAPaVX9A4V63AUCKJYoKN4=;
        b=qteZTsnG2qAkJGcIAjzwJhe3cCPEXcqWeAz/xuBunSmpyDQkUhPaUlgYnw8Xoq3cRR
         h/CDBALHAlVNa3WINg3872rjy+KOr9Ax1hOmsQ4IRPRbADENVPEoTtZaaXx/GVgKUk27
         /0zjHGyMxJox2BrApMENXVd1WYaAnrwsdIfmDnHR910QcXHeb8BCSZSV/P6Bg9TSmUlo
         KlC7ebwXMlySu8xqnrq0VSCDx4V4WBOCwL07fK2loXNlLqlj8QZcnYggaNuZ2AQ3IWNz
         T/+lNpK0nnuvwLajvUv9SpRlpmi44bUMBVZaQnrrsIuYdb3j8XufUH8MXa1dQjMsjedv
         5qIA==
X-Forwarded-Encrypted: i=1; AJvYcCVH6htdm0iG+/IltDgQ4li7pdLos89UCn10bUPmfa6R85MpJoCDMOhSxNnJdkf47YO8EbkxagsgI8Qq5g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxVAqgMJC6lTW6IxZWbwIQVBbECqKUx5UxHxd8P6kmvlhlqss73
	Ml6E4ahMjFQPIrk2fVdFepvJncnsvtpYKgI+fbdWtb/4733Ap//IKt0eTi37RwrSHDiw0NWeqMs
	sMGA0hgYOaV5wRzb22h4r9AmHv32Zzyw=
X-Gm-Gg: ATEYQzzN8CYp7m50sqApBiciIGLHVp22UYNMgG5BrtegtFHbaOyUJ9V4TdUkcDJU0UD
	SnNdBS9MrfbbeERntWAnLjrofGFoA221kD4jJABiBDDCP4J1aChpkJTdd8RGvBIogPGr5bzwSu0
	hpY2puuqucDb7O1XXNwQZkDuyUSKCJ4HJaNdwEWz0l9z6tw8ZOAxgrbC1GVnc8AotZKqhIHfZnP
	qRdGmoD3GYkPQVeiy2THIitUFiAicuVom4MN4T/JPkM/dEcS69Ly1YeEGX4bSNlU4smJgGhbZya
	Q3M3KX3siepaYYNihyQ=
X-Received: by 2002:ac2:4f14:0:b0:5a1:448b:317b with SMTP id
 2adb3069b0e04-5a2796c83f9mr530189e87.42.1773795269278; Tue, 17 Mar 2026
 17:54:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKFNMomDpMC7VrWzoLEm_5wGzjV5v82tQCWtRy3oif1Q-=9dPg@mail.gmail.com>
 <tencent_AA7BBBBA338F9ECD1B794B4A1BBE2523BA08@qq.com>
In-Reply-To: <tencent_AA7BBBBA338F9ECD1B794B4A1BBE2523BA08@qq.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 18 Mar 2026 09:54:12 +0900
X-Gm-Features: AaiRm52SRNXjGwpK9TTQzvzZm1Vn7e8d-tVXk7jP79WehgQ4TxMFHgTDJpgWp90
Message-ID: <CAKFNMo=NgRCP2nbgvDQyyy2ik1Qr7XQLrY-aUSUnGYiAu=yWwA@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: no longer save to shadow map if the num of
 members is too small
To: Edward Adam Davis <eadavis@qq.com>
Cc: kartikey406@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, slava@dubeyko.com, 
	syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Edward, thank you as always.

On Wed, Mar 18, 2026 at 9:08=E2=80=AFAM Edward Adam Davis wrote:
>
> Have you been following the path below? If the argv0.v_nmembs value
> passed from userspace is greater than 0, everything will function normall=
y.
>
> nilfs_ioctl_clean_segments()->
>   nilfs_ioctl_move_blocks()->
>     nilfs_iget_for_gc()->
>       nilfs_init_gcinode()->
>         nilfs_attach_btree_node_cache()
>
> Causing the mount to fail solely because the dat B-tree wasn't initialize=
d
> is an excessive fix.
>
> BR,
> Edward

Are you perhaps confusing the regular inode's GC cache (gc inode) with
the DAT's shadow mapping inode?

Calling nilfs_attach_btree_node_cache() from nilfs_init_gcinode() does
not allocate the b-tree node cache for the DAT inode where the problem
is occurring in nilfs_mdt_save_to_shadow_map().
Therefore, it does not fix the root cause of the issue.

As can be seen from the call trace below, the issue arises when the
i_assoc_inode of the DAT inode (or potentially its shadow mapping
inode) in nilfs_mdt_save_to_shadow_map() is dereferenced.

  RIP: 0010:nilfs_mdt_save_to_shadow_map+0x141/0x1c0 fs/nilfs2/mdt.c:559

Your fix eliminates the reproducibility conditions for the reproducer,
so it might pass the tests, but it doesn't fix the original problem,
does it?

The essential flaw is that it attempts to copy dirty pages from the
b-tree node cache to the shadow mapping, even though the DAT might not
have a btree node cache while remaining in direct mapping mode.

As I mentioned earlier, DAT usually grows quickly and switches to
btree mapping, so I don't think it's excessive to pre-allocate a btree
node cache as Deepanshu proposed.

Regards,
Ryusuke Konishi
