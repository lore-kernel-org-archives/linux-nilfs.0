Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0AC2EFD86
	for <linux-nilfs@vger.kernel.org>; Wed, 29 Oct 2025 10:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761733074; cv=none; b=CZ4gr3hGIboamYy59yhUrBBp1qKLzUFYB7VIYxHEIqdoLT+CtOBvufq+WV3vxH/WrFmpYiubmGGz7wDkFPekzdQZYNCk/sn5Hsy56sAvu3w8iBejv6J6/AZK3AWWxGC8urqxFDBaAPdwycxyJara44qBKjdqHQzkW3oc+miNbbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761733074; c=relaxed/simple;
	bh=ov5NJpcX/h29FHXKaENmqawt8Y42Vn6kL+Y2zog4UiY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X95eHWsnpsEIHFqPgqdKiyqnZBIHUCpfgYoWFPAL5ToiL9yxM+iO3a3HHGdp80WgvhtGNfOl7wQbLeJ7XSpw9+g39YMJo2O5S7S5pJK5TJsRoWfMlhAHhHr7+r/SSEezEDWrYuMdwkoKMSkM+Ad3j+w4y379vf21KP9ZNBEBz5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BWY2zrVg; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BWY2zrVg"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5941567218eso311704e87.1
        for <linux-nilfs@vger.kernel.org>; Wed, 29 Oct 2025 03:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761733070; x=1762337870; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mc3RYtne9Z34wcTqrxcL7TmWeAfRrTLykobfWAAkb1c=;
        b=BWY2zrVgcyW+d/2HV8Wd4C6pyD+8IWszEsK3onZYZ0mpHo/hCO6pYTpua4T+2kpMLn
         VRe6Mw/kxbcNQEgbM+XiY12ztOsqLP2MJSeyqhM5hfboSgp79R8+Eesy/qGSFZXSbBxL
         MiOprPUzEy7qIMmBEgIZ+THrtF0C3chQOflumHTZsS78rO3rddKen5ZNY6pElsAZC8XI
         CfsT7lGQbgHEamiefrC4tVx1yFrIjScFOYE4FXYixSrw1XH0kuK6228rjSU2r3W128o5
         UxiCrT0UKX/Xa1bHIoITIJG0JM9mqMC03477G2o8TT8OpD+NRrwUlP+MuOhQISvU5uZm
         RuuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761733070; x=1762337870;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mc3RYtne9Z34wcTqrxcL7TmWeAfRrTLykobfWAAkb1c=;
        b=GTvnXDMDuSSZ1m2UjWcC8IH6n90qQcUzgCc5/qxBEscG4a0ioUu847WnYP5NP1/czE
         im+peq/BtGsAPzhgZg0LYFSMn7bFH+srC7iJgk8cpQNG7WvGpqtRS2PPTxJfiXWtFCa5
         zFaLn8enr4+4kerQn+kXitLFIq6T021vPt88rZRqz9tBRZtz44w2ZyMWMCAFaNn/LL9T
         eZ4aPDPfSeEK5wcPUgbmG3BWCWTon3uMXcOVAtctJz1uXzAvbUvh3scZqxVFTtJJwN2A
         MT0y0PtoKEpfSFdbnQI04g9cEJ5+sQfDCvS6lTjlJr4UydjXJXPC3O5GPCcaG1CYT7Nv
         adsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyLBCvAlFDZxofsCzO2k/uB6dHmATmelDp/QJRH0wUixZTxUsUlhxROqXRD4GFSBpmn2y6VSL/5FcEIw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyK/l9VQ4zLuv+csN78x35Xp+D9Fg/+KEvQNAPr6WBq9EfgTVSM
	VpKkAQ2pcqmQiiXLt7SWWkh9D7QJHz12xHYnz8o6HTne6nQB71cZRunizuiJmeSNJse4b/eRKTj
	o4QVr7INpx8nt+QK5Eu+jjR4ELU99BVw=
X-Gm-Gg: ASbGncuv6fyu9WyiKBFOA8Zi5oKSDL/il3LXFvOJjM9HGuEGzUVlL2h+C8LidRlnzmb
	nPFtn8NAJzorMev4OOoRxNDh2yES7Z6ecF9P7oPe8rTa2cE0heHFS/UWEPYgQPpFmYe5MVut1+L
	LpYyNioMusWeyIPnnMSwO/+Drt6LXdbEO2fPEqvlhkN4PLM2Fj+oX2veru6ejwXM/rxLbFTfELk
	t/o/UPlKSBSxxQKPCuEaInQdE/rvQWxIEmaR4Bhz+YhVuweW9EjzCT3gf2l0w==
X-Google-Smtp-Source: AGHT+IEvI5JuVV5RWgfOrOAC6kBe8O5q4mrdOfSpswRH4ipD8TC7Z1SGaqw7Uns4/VDNUnSfc7pjUV/4aQ5RmYJZ5pQ=
X-Received: by 2002:a05:6512:2383:b0:591:ebc3:a688 with SMTP id
 2adb3069b0e04-59412901d27mr651390e87.56.1761733070111; Wed, 29 Oct 2025
 03:17:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <68ffe1a8.050a0220.3344a1.03a1.GAE@google.com> <tencent_B12C968C36824B2C74BD76FD66763DB13709@qq.com>
In-Reply-To: <tencent_B12C968C36824B2C74BD76FD66763DB13709@qq.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 29 Oct 2025 19:17:33 +0900
X-Gm-Features: AWmQ_bkW9Pkz3OeMwgBofVdiFJT9IUbkXlDHAnX75mvx4X_fAd3pLTi84SnYAz8
Message-ID: <CAKFNMo=+PiCPcq1M35mQxVP0OrNRw7ZYehbUhEXFOfbnyZb_vQ@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: Avoid having an active sc_timer before freeing sci
To: Edward Adam Davis <eadavis@qq.com>
Cc: syzbot+24d8b70f039151f65590@syzkaller.appspotmail.com, 
	linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 29, 2025 at 2:23=E2=80=AFPM Edward Adam Davis wrote:
>
> Because kthread_stop did not stop sc_task properly and returned -EINTR,
> the sc_timer was not properly closed, ultimately causing the problem [1]
> reported by syzbot when freeing sci due to the sc_timer not being closed.
>
> Because the thread sc_task main function nilfs_segctor_thread() returns 0
> when it succeeds, when the return value of kthread_stop() is not 0 in
> nilfs_segctor_destroy(), we believe that it has not properly closed sc_ti=
mer.
> We use timer_shutdown_sync() to sync wait for sc_timer to shutdown, and s=
et
> the value of sc_task to NULL under the protection of lock sc_state_lock,
> so as to avoid the issue caused by sc_timer not being properly shutdowned=
.
>
> [1]
> ODEBUG: free active (active state 0) object: 00000000dacb411a object type=
: timer_list hint: nilfs_construction_timeout
> Call trace:
>  nilfs_segctor_destroy fs/nilfs2/segment.c:2811 [inline]
>  nilfs_detach_log_writer+0x668/0x8cc fs/nilfs2/segment.c:2877
>  nilfs_put_super+0x4c/0x12c fs/nilfs2/super.c:509
>
> Reported-by: syzbot+24d8b70f039151f65590@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D24d8b70f039151f65590
> Tested-by: syzbot+24d8b70f039151f65590@syzkaller.appspotmail.com
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
>  fs/nilfs2/segment.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index f15ca6fc400d..deee16bc9d4e 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2768,7 +2768,12 @@ static void nilfs_segctor_destroy(struct nilfs_sc_=
info *sci)
>
>         if (sci->sc_task) {
>                 wake_up(&sci->sc_wait_daemon);
> -               kthread_stop(sci->sc_task);
> +               if (kthread_stop(sci->sc_task)) {
> +                       spin_lock(&sci->sc_state_lock);
> +                       sci->sc_task =3D NULL;
> +                       timer_shutdown_sync(&sci->sc_timer);
> +                       spin_unlock(&sci->sc_state_lock);
> +               }
>         }
>
>         spin_lock(&sci->sc_state_lock);
> --
> 2.43.0

Thanks, Edward!

I spent a little while wondering if kthread_stop() could actually
return a non-zero value (such as -EINTR), but then I realized you'd
actually tested it with syzbot and confirmed that it could happen and
that this was causing the problem.

I'll send this fix upstream.

Thanks,
Ryusuke Konishi
