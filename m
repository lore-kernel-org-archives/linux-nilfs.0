Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E8B3E0096
	for <linux-nilfs@vger.kernel.org>; Fri, 17 Jul 2026 10:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784284483; cv=pass; b=lhxsCE3Os1BQlXNwpC5UXEJq1nUlFcC3zv+DcjOEFdgdMKH4+6nlDxQOrr1s3FXVq7ykGhIIlFeA3TVgUsS7CIPIZuRXcUw2zL/bZt+70gkw+eFf9x2gb3BNMdwdFYACa2wqujb3VbEw6TZobDg0YUKQQES2EHWPQdmDfae52vg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784284483; c=relaxed/simple;
	bh=CqC6BgaCBsXvXVLlnSTrQh75V1tbdo/W+cginwK8mMM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hi1YvaYiFv2XSRyD8g+Kpl0hnaGUmkXg4cRp4t6Iufdc6vILF4g237CTEbbIwDaHKBfUDVQiwMJ0wZVsLzqLF1vaZRYHIrEh79Vxyo6IpKoj7mjo2AG1Im4BrY0zQ7CsOAiW2R08pwtR5i75Ij5Tuw3DkiIItvIulfqM8fY74pM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c1iRJiBB; arc=pass smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c1iRJiBB"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-39669bcaadfso47397861fa.0
        for <linux-nilfs@vger.kernel.org>; Fri, 17 Jul 2026 03:34:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784284478; cv=none;
        d=google.com; s=arc-20260327;
        b=Ev413tYo0m2E7TCpH/S7u501Gw5Re8UhNNviyZ0J9BPzEgKU7HLXD1aS7YvubtAaT2
         4YUTsao84ZgiBrx4ruzT9ty8FG/+q/5KNU+W4nBZdRG2KWpDzkkI5c/7NYevos+l1+sy
         vBzrKZlDT10S7r+EeRp0tYphEKQnzV2l8EK9yqD0fbUrDWAxxgcY4mUwWj3ytwqj1OwH
         /vJkAxxDSdIFTO61sP23LC5Cx6Zk2VZsagm8DKXOoePF710G7P4hDZ8JEjxwSny+XZLG
         4YKEo1DLkMSCVeDr25jOfBPG4CN5DmDQCo00IOvGQSYDxBYtDjYS8SJITGcag4w506im
         h0qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6y84wQhgGe5MTq0MqTyUCKtknybumOshz62ut5X3qQY=;
        fh=bHs1Otxyrwx3PmK4lEyyug0oPUCLBqkXPI903V0w5E4=;
        b=nbZLdybkbiF+mfMdriDqEY7Db3zfxrYngNyC7o3uoGIuDyZotss8g+0bonTpcJjX9Q
         7L8cjIGZPvOcBgxihOCY93ui9gTI9qarL/MZheC106Q2xAQoI+KaF7uTWfHSHAfcU47D
         YBytr1y6DwOODL4Z4QULy9iS/43A5+vMkE8MgmjguGqc3iTGkH0TUW3OKj9G9YJVKbZw
         a54SjjbJ0drVEfT10x4pQ97nBnfObaKUOWIN8cpUcWNisgrNWUtgmpxyK0xdTo5qfjJn
         BV1L602IfAcuBWtcWJNFz/sTanrUsPEjRGyEgo9f6Jzk2JoUQAqhhbpat8Th92N59WBB
         jAAw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784284478; x=1784889278; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6y84wQhgGe5MTq0MqTyUCKtknybumOshz62ut5X3qQY=;
        b=c1iRJiBBbeTqGw2HdTBusyhsW/ASjldDBoWtJ1YX2ySX6dN93iZzMRFVMN+Ac3WUhV
         +btKcoek8LptlsbeM9SIO+ocERwYYqdEZYZSI3Vnjw9CUFWrdnas8cNoT+3rUmLmmCr6
         npHVvXj1mxtToYFDT5hz3qZneQJQLWYvEXB2oNboUEgD+Cwi5dkAa/6ArBYF4O55BNXm
         80D6MmOkCuGHPbfoLK+OKgUrjHbJlIGjuHhEWdCauJR2e3t68MJ4dwQ6LirR9MUQLPGm
         Rm57gsEJeFg7ZGT7VeINZGj178O286/gdkBQtJy5HUgQMSFvqWtac1gbrhN4zhCSltyD
         J+jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784284478; x=1784889278;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6y84wQhgGe5MTq0MqTyUCKtknybumOshz62ut5X3qQY=;
        b=BTEt8Hn1LHLjFfqnIbouiY0eWEo7YSoeFl+1ZnRr7cM7AQj9mNWsUpa8gncASkif0d
         Tm9xmQIc8CcW5WVWJhb++lEoWfvwBDiV+ym/beYyNed1RUMIH9bsGWq1JcNYl6qUlQuw
         KboyFb3oFFSflSj7GQKP20nfByn65jDxamsjEy46fCgeE5glALUBZoCLsnNiu/g9iJip
         DD3Rwuv7PZi1/g5JZ01wjEHITVq9WZ0t8hJ7VLXtLtzFMv54xzzOvRmeCJBPsStp72qT
         gedkxHXdieeXG5zymNxdFAUYs3chdWcKEH5moKKneZzBpHn9a8zm9Ir+DeuXxFZeM9uB
         l4XQ==
X-Forwarded-Encrypted: i=1; AHgh+RruKLj3uXeiPyxKDNA2naFkAeImb4/D1Xo/C0+RMyYC+JhrvkwlciwcVCUjLZ0XgWOkuoLUQqc3yiO6Sw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyRidzuDb+8Fb7hQwnA1LSyPiqCP89XW9Z1ul9XkBvxAGwq7zYy
	ZGFtRYrGl6fR0RYPexjOKyEfz33XM/8HdkjMRXfCkhlYbjG1DczrospAepAd2DoZ/bX9arhqk3B
	xCHo2JyUp9ZuKglbZwcp9BxtrSKrxbOSErTu7
X-Gm-Gg: AfdE7clCcsLrNrZeD6thEnp3dsNnO4p3RlNzn1r9Au8TguDCEJ72tcxaj3apYPAGT1E
	H7iJXRi8KFFjU1cWM7WLpr3D7Lp/1wHs4UxLe7htRNv1Lt4P7ZvjKlUDEUlSrOWw8otc3rvnZUV
	uWTlD4tRFGekrDFozkwwYfXWbG0iCgyaydEA+Nr/BX4zFesDlxhsQo1xDLg0ivf9V5m/gTKw3SP
	g3IuKSb/lrRY4ZL/FsiYL493zw03eWyIuct8sTfyKnfJMC75Vxoyvw4UF5BNrM=
X-Received: by 2002:a05:651c:441a:20b0:39c:a346:8a45 with SMTP id
 38308e7fff4ca-39eb287aafcmr3403941fa.39.1784284478168; Fri, 17 Jul 2026
 03:34:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260717074710.1397-1-joshua.crofts1@gmail.com>
In-Reply-To: <20260717074710.1397-1-joshua.crofts1@gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 17 Jul 2026 19:34:21 +0900
X-Gm-Features: AUfX_my8K8Czkir4-VZkGQMsjj8_7kSuhI7dr9nFY4Syg36FRjqs6tT-gfP1obY
Message-ID: <CAKFNMo=L6fQa54Nd+u4ySOeTAuWF36cgymYwdjKJpD_FLeXKfw@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: fix infinite loop in nilfs_clean_segments()
To: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+cae54346a70bbceeff2c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 17, 2026 at 4:49=E2=80=AFPM Joshua Crofts wrote:
>
> syzbot reported a hung task in nilfs_transaction_begin(). This occurs
> because the cleaner ioctl falls into an infinite loop if
> nilfs_segctor_construct() repeatedly returns -EROFS (e.g. the device
> is remounted as read-only after an I/O error).
>
> Currently in nilfs_clean_segments(), if err is non-zero, it logs the
> error and sleeps but doesn't abort when it encounters a terminal error
> like -EROFS. This causes the thread to loop forever.
>
> Fix this by breaking out of the loop if nilfs_segctor_construct()
> returns -EROFS. This matches the behaviour in
> nilfs_segctor_write_out(), which also handles -EROFS.
>
> Reported-by: syzbot+cae54346a70bbceeff2c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dcae54346a70bbceeff2c
> Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
> Assisted-by: gemini:gemini-3.1-pro
> Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
> ---
> As much as I've tried, syzbot is unable to test this and always fails
> with "FATAL: Kernel too old". Nevertheless, I've tested the patch with
> the same reproducer in QEMU and the system didn't hang.

Thanks for the patch, Joshua!
This fix correctly addresses the issue reported by syzbot.

I have one request regarding the loop exit:
Could you modify the patch to jump to the out_unlock label instead of
using break?
This is to prevent discard commands from being sent to the underlying
block device when the operation has failed and the filesystem state
has degraded to read-only.

Thanks,
Ryusuke Konishi

> ---
>  fs/nilfs2/segment.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 9332f5ac6..91d3bb314 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2561,6 +2561,9 @@ int nilfs_clean_segments(struct super_block *sb, st=
ruct nilfs_argv *argv,
>                         break;
>
>                 nilfs_warn(sb, "error %d cleaning segments", err);
> +               if (unlikely(err =3D=3D -EROFS))
> +                       break;
> +
>                 set_current_state(TASK_INTERRUPTIBLE);
>                 schedule_timeout(sci->sc_interval);
>         }
> --
> 2.47.3
>
