Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E22844369
	for <linux-nilfs@vger.kernel.org>; Sun, 17 Dec 2023 15:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l1B2YTWj"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3ba3cf9aa13so1669178b6e.2
        for <linux-nilfs@vger.kernel.org>; Sun, 17 Dec 2023 07:50:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702828215; x=1703433015; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dHcfv8YdTqbMLgYUwmvYG6+EnhMbu8ou47ebve5llYg=;
        b=l1B2YTWj1XuXz1LQJXel6Ub6XGgw2NE04J5YSzhtbYWHeiaygvUJ5l6Gj1m2AbFWko
         mkHN4/fmLqoT9gDdJGQapxcrgYGbAPgWkOBw9gHAOri/3tQVsB954Nc9+5n2BNkUABKz
         NYlYvFfFWoPr9sT1SPtUEif6iIdKSXSv/OroOzXfjXwRMShWWDhFbaqs66WtrbwWxRdJ
         u4ktU2AZLCw8O/vwvVK7TNVb1TL8MKImROGjcmYbVqn8bcujxLl3uK3Oztg2ozV2Ncyl
         iVRKA8mdf6S+X8WZQJ8IoyOv9DhwLuAbEsO6MgzpfrILpCh+4s0QyiAuh7q66ypEItoc
         LqtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702828215; x=1703433015;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dHcfv8YdTqbMLgYUwmvYG6+EnhMbu8ou47ebve5llYg=;
        b=m+aFn9tt1fe6cdXQeqCZJziGDZvLWjV+2Oy5vRNa5sUHRAl0FB7J6w+jbz2bq6LdsU
         5HyoWgN+Y3Ug7Xxy4llK0QVzy/QsGX3Goft4B5uej6S6Czz5F6pkjj/dhZfRH+fJaLuW
         fMIjJ4+oSaOsJq6arohsn8W/Vsebyy4/D9VTRdztP2qmICUx/bCCOaFCh4GeSrrkj/o0
         jacw4tr3uwRKgG1oy4Hra2gumXPyHTXFZ82El6rLlX3mmx5Tip1HLIQKDuHdcM8rQ4op
         ZwTsEeKob3IK+x5IJoTgttGnM4GR0FuvltCCvkiHC9j3gK0SDoLx8Nh9iX4cTOZLubDQ
         sV/w==
X-Gm-Message-State: AOJu0YzYplRLDw9bmlfQ/Ruf64NprWiQhrjeisbZQ1BJcxAF0+FMXW/A
	ZbngsAkPw6XbwNQBXl6WdyeN8xxPLk9z2W0tTzq2zi84n/I=
X-Google-Smtp-Source: AGHT+IEoY7MtWl2zz1XQFfE4OZFHpMz5DOqnGCJCAXDxDIPrI0K3ELuaxF+c/kFhYqaXvFsPkXoTUVYpnKlq2AACiOQ=
X-Received: by 2002:a05:6808:6544:b0:3ba:d5d:2086 with SMTP id
 fn4-20020a056808654400b003ba0d5d2086mr13980078oib.63.1702828215055; Sun, 17
 Dec 2023 07:50:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231217135024.3116955-1-haokexin@gmail.com>
In-Reply-To: <20231217135024.3116955-1-haokexin@gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Mon, 18 Dec 2023 00:49:58 +0900
Message-ID: <CAKFNMonsfd1wm2EtWJAQi0o5deBB_2U3US=yVOZVU9oMXH0ixA@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: Add missing set_freezable() for freezable kthread
To: Kevin Hao <haokexin@gmail.com>
Cc: linux-nilfs@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 17, 2023 at 10:50=E2=80=AFPM Kevin Hao wrote:
>
> The kernel thread function nilfs_segctor_thread() invokes
> the try_to_freeze() in its loop. But all the kernel threads are
> non-freezable by default. So if we want to make a kernel thread to be
> freezable, we have to invoke set_freezable() explicitly.
>
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
> ---
>  fs/nilfs2/segment.c | 1 +
>  1 file changed, 1 insertion(+)

Thank you!
I'll grab this and send it upstream.

Ryusuke Konishi

>
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 52995838f2de..2590a0860eab 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2588,6 +2588,7 @@ static int nilfs_segctor_thread(void *arg)
>                    "segctord starting. Construction interval =3D %lu seco=
nds, CP frequency < %lu seconds",
>                    sci->sc_interval / HZ, sci->sc_mjcp_freq / HZ);
>
> +       set_freezable();
>         spin_lock(&sci->sc_state_lock);
>   loop:
>         for (;;) {
> --
> 2.39.2
>
