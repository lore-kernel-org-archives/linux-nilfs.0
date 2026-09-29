Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5021654855B
	for <linux-nilfs@vger.kernel.org>; Tue, 29 Sep 2026 17:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790704293; cv=none; b=tj1SlblL1Iv124ritMOQiTuWpVgRDltdBgcKvySXaageZWX62vAFAsSEuNVAJQATjzj80LjYu747CBWJCIp3zvu+DQo3eFigzn0w45Few5ZihDgdUsMyGlkzWLeOIODO5En+P3EzqezuXI7lJHwkHOYMO06BUjXQ3V4/YRJP02M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790704293; c=relaxed/simple;
	bh=09Z+uTdHfchfL4xuufQr94ZP8PzrYoCa8k2iVK5RaJM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HFP/sksijBKq6DBiWe9XOOnVEo+b39wJ4v0UVfuiBIH9ov2woCL1QvUyOjCEUHPTIRgYF6EZCqz8CQXwLcqvb9+jB9zTnN41xVx8mMW6quf8yLAHNi0SLIHcOBhY/cFiwTzQGdo/qGOicBl98n95aF2FjhoIOyvp3LzgUh5hcj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=QTb2sAp9; arc=none smtp.client-ip=74.125.224.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="QTb2sAp9"
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-66c9995ca60so800414d50.1
        for <linux-nilfs@vger.kernel.org>; Tue, 29 Sep 2026 10:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1790704290; x=1791309090; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MlVSbPAEtcbAsb28VdXRdcpAlGUVjZXNvGC4S7YBHhc=;
        b=QTb2sAp9HByaCmhld2xtkn06qXCnmhnKJs96Cdkk4shnGmA/QXwrSovkzaCQt6IEY5
         eW+URgSm3+EJUFNQL+4SfoeUzha8FVq4iqz95xqM3T+MqCdPILh1hJ3Grx1vM7XjAVf8
         kdeFLvCbwkkEZJ/R5xPGam9TTiZSuNeW5xfZZFuCGS9zGHCuUMZ2u/P1JQN6s2EJtfSo
         pZnJoVwIRzWZz4d1RTgF2VLpZcOayOGLSp34Og43AYCsl8dN3tRvQ/4HFRz95sojJ1gm
         KkO9qe8r/DuX3QbcOVhOUdXpvLPHohYG7A+qSaBxi2B4NV4w0jPZ5EEQMSyDfeZwnZlI
         K8LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790704290; x=1791309090;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=MlVSbPAEtcbAsb28VdXRdcpAlGUVjZXNvGC4S7YBHhc=;
        b=dylQpwnznHNS07xBOA++FeSwHqA0VPEiwa/n6XeTQvENSxhQo1a35dRPsHpdfTjtRy
         9lUZWKVisOzX/Y1Zlw72UR241EdjogYjZJD/ppUIREXU69rNTVoymWCJhH0M89uswi9e
         yQDsj1w/nGE1ZAJU+Kw0DJh/vy+c7KfjHPyo04jg3RPsJOB5Xv8cy2rrEjoLiZP0k1a/
         vxTWX+l9kIuVGIrDbCcbJ1OG07RYKeMaXSVGopmWgFQ2y68ltUbwG07ev5WfqPg5Fxng
         KGz/3XNRUFk6hjXYD2m/0YhG6SwivivXvlu+jKMViwuVKErDnE4VWFkjzhjaH8BKMmsw
         WvHA==
X-Gm-Message-State: AFq9FYL3c+iLKR53ReQsGFaPo8SJYS1knFZFKJYpcE6WBR93esuet65x
	rt1WBsCox27zr1VNAX8dSCOJA39fJ7FpfTLQQ4wrJpvL1FjEY1x3vtJMeMm7WVy81CsOTUfsPXD
	maGADKOc=
X-Gm-Gg: AYBFou0WzIXYPA2K3H2y6wI6H07yYUSfXLauWrYv0G+CBnF1oLfmlYEGSTLQwkdtA06
	63UdJfdEB6Qemhxt7RH5Bh3cRTZHBARvXHrOH7xijWO40yaRW7WQTCwM9jNK+vv8sTJ4JJffez/
	T8W2RtESamHM81ASPS15qVIxUo1ZO4PTq5cQu3DWt3vG+Bp0jwYYk12zv/4ZBGo86qgYOHrJJ+h
	pYv63HDIjpgUsiTmMeyBk1U0IaNwvDt01Uj2YsTvWx+8gOVYLPCe4/ulRQmv/CDw1JbECvgooSg
	1y554WJsUxQ5D4DSD2RVTY2xlAeDe+Ir3j4RRjRLFyuWZiEOoFGqpO/fObzyfIbHfho8OaldIYh
	lNI4b2h8gKP7cNHyt4CjGdPgFH6wvQTL8Ki18AM06/x2vGCrPYl/isfJYiGT47ytFt9n+vYRJRP
	6oryEcjKfI/iKYGxentFAjqhH0FFdOARsWPrIUbDHI8Ci1AP/u88lhuzjkT2UeQu9iG48eyEDxN
	pYt9e34mPw8v7+Xx480p5hdXGunGme1fYd/h/WSUTHAqJyWplLeqF4K7TTFiOz6x7E1A0Xvrn5+
	mx1t/jZXI8hvZDSIOSHnH2SXZ7s=
X-Received: by 2002:a53:d019:0:b0:675:300c:3938 with SMTP id 956f58d0204a3-67560b590aamr1051413d50.14.1790704290177;
        Tue, 29 Sep 2026 10:51:30 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:6476:1430:ace4:86e:1afc:3c4e])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8abcea200f2sm1644747b3.39.2026.09.29.10.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 10:51:29 -0700 (PDT)
Message-ID: <6d6806e28eb00bee6a3e895fd73b7c67270f014f.camel@dubeyko.com>
Subject: Re: [PATCH] nilfs2: clear dirty flag on bdev buffers on log write
 failure
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML
	 <linux-kernel@vger.kernel.org>
Date: Tue, 29 Sep 2026 10:51:27 -0700
In-Reply-To: <20260929064001.94261-1-konishi.ryusuke@gmail.com>
References: <20260929064001.94261-1-konishi.ryusuke@gmail.com>
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

On Tue, 2026-09-29 at 15:38 +0900, Ryusuke Konishi wrote:
> Since the commit referenced in the Fixes tag stopped directly calling
> inode_attach_wb(), a dirty flag is set on buffers (with
> mark_buffer_dirty()) allocated to the backing device for segment
> summaries and the super root block during log writes.
>=20
> While this dirty flag is cleared upon a successful log write, it
> remains
> uncleared if the log write fails.
>=20
> Consequently, when a log write fails, these backing device buffers
> are
> left in an inconsistent state where their uptodate flag and the dirty
> flag of the containing page/folio are cleared, but the buffer's dirty
> flag remains as stale garbage.
>=20
> Particularly when the block size is smaller than the page size, if
> other
> buffers on the same page/folio become dirty, this buffer unexpectedly
> becomes a target for writeback again.=C2=A0 As a result, if the block is
> later reused for other data or metadata, that contents risks being
> corrupted.
>=20
> Fix this issue by calling clear_buffer_dirty() for the backing device
> buffers when aborting log writes in nilfs_abort_logs().
>=20
> Fixes: 68142cb628f7 ("nilfs2: do not call inode_attach_wb()
> directly")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> ---
> Hi Viacheslav,
>=20
> Please apply this bug fix.
>=20
> This fixes an omitted clear of the dirty flag on backing device
> buffers,
> which could cause an abnormal buffer state and potential block
> overwriting data corruption.
>=20
> Thanks,
> Ryusuke Konishi
>=20
> =C2=A0fs/nilfs2/segment.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 829573cb6131..2f0e59847d02 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -1829,6 +1829,7 @@ static void nilfs_abort_logs(struct list_head
> *logs, int err)
> =C2=A0	list_for_each_entry(segbuf, logs, sb_list) {
> =C2=A0		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
> =C2=A0				=C2=A0=C2=A0=C2=A0 b_assoc_buffers) {
> +			clear_buffer_dirty(bh);
> =C2=A0			clear_buffer_uptodate(bh);
> =C2=A0			if (bh->b_folio !=3D bd_folio) {
> =C2=A0				if (bd_folio)
> @@ -1840,6 +1841,7 @@ static void nilfs_abort_logs(struct list_head
> *logs, int err)
> =C2=A0		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
> =C2=A0				=C2=A0=C2=A0=C2=A0 b_assoc_buffers) {
> =C2=A0			if (bh =3D=3D segbuf->sb_super_root) {
> +				clear_buffer_dirty(bh);
> =C2=A0				clear_buffer_uptodate(bh);
> =C2=A0				if (bh->b_folio !=3D bd_folio) {
> =C2=A0					folio_end_writeback(bd_folio
> );

Applied.

Thanks,
Slava.
