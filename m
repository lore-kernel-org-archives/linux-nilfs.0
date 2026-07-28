Received: from mail-pj2-f10.google.com (mail-pj2-f10.google.com [74.125.227.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF5040A937
	for <linux-nilfs@vger.kernel.org>; Tue, 28 Jul 2026 23:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785282207; cv=none; b=KhX9IVjxqrvqndrvp5MBb7dn78JtFbRrQGcwykvkYPMfcOHf2rHB1RFTMmtGe3vBUaTnlwtTyzUttIJd3dLuCIJ6eL8VPwXcxPxqw5E/bA1Yjdg+CE7RmdKyGZ3DJ3kDnqWrxFjf7dBSnkcmbE/SdqSCiS0QeeRNZpAy74gT0Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785282207; c=relaxed/simple;
	bh=jsvdoBFORi/uh/Ufc1oNSmr5vWAoZP/Rmkso6sk9LbE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fYpxdQOojtFP4klo+PxWuKBAXzFJQPWf3F5dqEDNrlldGWQrcyT23vzWpX8XNRdMl9RAqT0jq7/aRZ3cYP+e0jWGGM+KVsKscF4p0vWXrDy85+/LDtLRO1ubeK2vqsOvLdbxACEfklcezwBWS/sCQbCV3rAwy2l+H9bsCQy8CyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=DOKv677w; arc=none smtp.client-ip=74.125.227.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="DOKv677w"
Received: by mail-pj2-f10.google.com with SMTP id 98e67ed59e1d1-38dc4f9462cso118016a91.0
        for <linux-nilfs@vger.kernel.org>; Tue, 28 Jul 2026 16:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1785282205; x=1785887005; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jsvdoBFORi/uh/Ufc1oNSmr5vWAoZP/Rmkso6sk9LbE=;
        b=DOKv677wRHHDuClF03HtX17GXm57DwB4UJ89j3BagkPBc0XZyoFzgvGnJr+WatVrTG
         nfJPr0wRKEBJ1KhnwIMno/zRfJQRMeWK2eoEldaxbxYemtjYAOn2F7hS/YFuAoeVuC3q
         DEmqMblSF9rV5qwkvdV25yNkPY05/pUmTqvjdBvr94kWdPC/718uMMzQBB30BWT8kiEf
         W2KcA2aDsYXpBGgR43wU6GOcur7CBGA0g0L04wr0GLU+Lg0fW0rv6A1VFIyeW71XmNcz
         7IqqAARLdaLwDgS10amMaHt2SrZd1EgOXFXH35OwE31YA+4xGCAM6kN3tZUTbb5A7+pl
         3OpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785282205; x=1785887005;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jsvdoBFORi/uh/Ufc1oNSmr5vWAoZP/Rmkso6sk9LbE=;
        b=i1d5w+wdZUvUILU6p7uqwd4FMnLgxDPfuKC9oXw0FoxdJj6q8DkkDIfKPkWbyOHMX6
         /GjLBk+phSJ8PjxivcmfhtBbT7PzSJ+CZKHdEPsQZkNucOFzVHMxEmTACpngUFUNoXae
         ZQ2NlK+DmZt2ONpTLgdxPFc0IR+77HddgEWYzSn0WZ40TOswjwEfdFDJdo6YlGg45Xpk
         XESN3bOjF1HpSTw08iJkFd2IktkDAe9hxsT079oRYQdCGYcDeQqNb06ZGieeQA2FM/Tz
         Jjv0dhQOztb5IJqwIh9iic9NhNYwi+XCYfIhSbkORbZGE2/gjxh9Cu4Prj7syo3J+SYz
         3liQ==
X-Gm-Message-State: AOJu0YxVN2q7WDUzpkVQzvpFx5UhQOI4wZ7szMqfDJydTZs2c9XV8GLg
	N66OeoYBh126Fn1tHizjmmewyCtch7gEkjIE32YryyaPO0fre5Asby3WVWMEqzn2B6tPXuU9zU/
	JIc4D3RFQBEwMGGM=
X-Gm-Gg: AR+sD11zD8KIKkU5m6VaKd1mo3cbTZQJkXsd98S1HpGsY7Qrx7v9FXBtz660dc4upyL
	oo7Cmoisnx3ZUEcUIdoR4auH5HzjgCa5+q3lj2HsZnYJOwNzQNIG4KONNbB9k5JsoJ6rBHs5fKI
	6DfKdQrgdwdsYzg6v7dpwOxbgSOJ4b7G2v1PzOlLRo5x2DIqxu1BfxK8BE3f3cD0JvroAAWb5Yh
	ppubCSyaKcccDfFsU2OwxvvxSXdWkHxcThW6Y/eTOnDPuRZb7MxFpSn+7w0YsgOzdCdylMqhTn/
	XJh5Ibv4+z08UazQbM8HE/IEqBeDdvANgmE/ZqhEKx79SmnjtHiAJn66urlUnx5qVN5jAfI+qpn
	MmQS6wmPEVOS3/ezoBGOScghUvklZz6/k3UAZRgltzdPMZ1Jk01kPeMPzDvDC+hZXuMwyjW2Kpj
	gRKo8QmaWgbOS7pL9chpXgSikweCQfmbJx4tGoOvs1fCYJ7oln7w9ZEcBRubnSMkPad7kZfIh4f
	xuD5WnRdQ1ECdV+esmTXodkK0hyU6NQXj4f7aE3yPwj4mvisXP/ZfonIBYU4BG1ZUXC+TIOmwC5
	qdJDD7QM4thWmehTj/d/+QqSD9TQ+pP0qAZlQNO+YwiyV3xepMs7aRs=
X-Received: by 2002:a17:90b:4c42:b0:38e:a555:8fc3 with SMTP id 98e67ed59e1d1-38f6a484cf7mr4711418a91.41.1785282204809;
        Tue, 28 Jul 2026 16:43:24 -0700 (PDT)
Received: from [10.0.0.3] (162-197-212-70.lightspeed.sntcca.sbcglobal.net. [162.197.212.70])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504b88e12sm3034148eec.11.2026.07.28.16.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 16:43:24 -0700 (PDT)
Message-ID: <cec4c380ffb60c6bbb3ee2a49394d53bab8ee5cc.camel@dubeyko.com>
Subject: Re: [PATCH v2] nilfs2: fix infinite loop in nilfs_clean_segments()
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>, Joshua Crofts
	 <joshua.crofts1@gmail.com>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+cae54346a70bbceeff2c@syzkaller.appspotmail.com
Date: Tue, 28 Jul 2026 16:43:22 -0700
In-Reply-To: <CAKFNMome_9P59vdiP0=kS33H3qKJCNVL--SE7tR1rsUJajBETw@mail.gmail.com>
References: <20260717105854.1380-1-joshua.crofts1@gmail.com>
	 <CAKFNMome_9P59vdiP0=kS33H3qKJCNVL--SE7tR1rsUJajBETw@mail.gmail.com>
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

On Fri, 2026-07-17 at 22:30 +0900, Ryusuke Konishi wrote:
> On Fri, Jul 17, 2026 at 7:59=E2=80=AFPM Joshua Crofts wrote:
> >=20
> > syzbot reported a hung task in nilfs_transaction_begin(). This
> > occurs
> > because the cleaner ioctl falls into an infinite loop if
> > nilfs_segctor_construct() repeatedly returns -EROFS (e.g. the
> > device
> > is remounted as read-only after an I/O error).
> >=20
> > Currently in nilfs_clean_segments(), if err is non-zero, it logs
> > the
> > error and sleeps but doesn't abort when it encounters a terminal
> > error
> > like -EROFS. This causes the thread to loop forever.
> >=20
> > Fix this by breaking out of the loop if nilfs_segctor_construct()
> > returns -EROFS. This matches the behaviour in
> > nilfs_segctor_write_out(), which also handles -EROFS.
> >=20
> > Reported-by: syzbot+cae54346a70bbceeff2c@syzkaller.appspotmail.com
> > Closes:
> > https://syzkaller.appspot.com/bug?extid=3Dcae54346a70bbceeff2c
> > Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
> > Assisted-by: gemini:gemini-3.1-pro
> > Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
> > ---
> > Changes in v2:
> > - use `goto out_unlock` instead of break to prevent discard
> > commands
> > =C2=A0 from being sent
> >=20
> > As much as I've tried, syzbot is unable to test this and always
> > fails
> > with "FATAL: Kernel too old". Nevertheless, I've tested the patch
> > with
> > the same reproducer in QEMU and the system didn't hang.
> > ---
> > =C2=A0fs/nilfs2/segment.c | 4 ++++
> > =C2=A01 file changed, 4 insertions(+)
> >=20
> > diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> > index 9332f5ac6..218926789 100644
> > --- a/fs/nilfs2/segment.c
> > +++ b/fs/nilfs2/segment.c
> > @@ -2561,6 +2561,10 @@ int nilfs_clean_segments(struct super_block
> > *sb, struct nilfs_argv *argv,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break=
;
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 nilfs_warn(sb, "error %d cleaning segments", err);
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (unlikely(err =3D=3D -EROFS))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_un=
lock;
> > +
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 set_current_state(TASK_INTERRUPTIBLE);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 schedule_timeout(sci->sc_interval);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> > --
> > 2.47.3
>=20
> Looks good.
>=20
> Viacheslav, could you please pick this up for your queue?
>=20
> Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
>=20
>=20

Applied.

Thanks,
Slava.
