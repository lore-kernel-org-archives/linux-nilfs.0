Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D52C30567F
	for <linux-nilfs@vger.kernel.org>; Sun,  6 Sep 2026 20:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788728130; cv=none; b=Zen8HHNovUOj3KvjFpg1T16WrWqlXpe/ixtRqMBpR4Q1fRGDlPJIqhp5DvPl+klZeVx1DgTb08dbCjub1UA3ToeNpz4P0tqKesT+nYqN383TxjHYZeQzd40qdr3Hul8Ew/nwhEV2RKKDg/oWQmMxQM19+7maVLVYAZcz9v4HOk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788728130; c=relaxed/simple;
	bh=UmTnoTVu0uHk5ty8IRYct/UGRDry/oe29M2HASDGF6g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=foj95nKiF1nna6AJH+/XfOmQtSV/JfzvGvqtj/kiAnlyDWqelq6WwIgINQP2TOn6aJS4PJ6f70mqwfbBbWeUjx+O/cf4rd9FJq0vvbPu7MQsJ218dB1HiN+U+UR7b8BiyPI0MkhMvra34ISshehBYWpk0F/ccJQJPGZAtmGphwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c0F1sp7d; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c0F1sp7d"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-47fe89fb333so1716260f8f.3
        for <linux-nilfs@vger.kernel.org>; Sun, 06 Sep 2026 13:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788728127; x=1789332927; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KApqmYJmHvPUcT9v/KGmQBynW1X598SQBtzRKCAwt84=;
        b=c0F1sp7dnLqwtjm5XAFNbkHQ+bxKOx2LGyeHnWyw6qKh0mfiQ1jiiKgBpl3hRkXu+0
         TOlSIP3XBmzokKZyBGMXk0sV/Nd8UWKLaGyNafmAlmI+IS+pSmTfaKdbHMu7Mg4gvtG9
         Kc1E0+Sws+C22iWE4pBdu/Lkd1gdX4Yrw9KW3RP2kicXxSdccc9MeFEuJ6h84PZwgCJm
         MULyZiTiG9cjtFNAxleZILfmwElVrO7e1GL+vHaEgvde7Qta9xx1Rtjk9hnjy26h1goD
         +3s+pgok/TEAjsthzfzbFwTmswajL34c4iJ9aWYFRry49aHPRtvsbh/n3DqsPcZ29RG5
         P1nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788728127; x=1789332927;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KApqmYJmHvPUcT9v/KGmQBynW1X598SQBtzRKCAwt84=;
        b=PmxPKNkXfywza/VJ0O/QRQBnHHOZvI9CRHJg/D6euW/tY0/Tl9gySKXqz7Lo83nari
         VSqRIh8WhrnY5Xu8oqqtLV0uKOdiX2dxq2vwlZu9Zt4crVXGD6a8GWs4vHAgD/msljdI
         tvuhmPEPOpkTGFfL9mMpUa5UuKN/J0hCRJ2CWdCjyabSKG2cF0Rx1ViCaFZ7Tt3IYySy
         GqDvq29r+bv2K/XId8CLuUN6m+0jbsZXjn18GbVE1FDEpftGC6BCmSZ/j7R7SCuzDphi
         aPYBCiHrOcWEzijOyFc7RxLid4r923+v1WRhS7LMMXCXXqqpayhWSKveBBjlXw3upo+B
         K/0g==
X-Forwarded-Encrypted: i=1; AKwUvBwbz3dztU5zl5MNGGWtGVRxaGVBFOH+8DFOMpP+B0rQmlka/pvnSGLt3j8RkQzoFkVjzEZ2OPEFc04DCQ==@vger.kernel.org
X-Gm-Message-State: AFuF++mH+Z978fdnF3CqgRs72oPZ0FIJLFZFjke57jGgxMWzzxQ/TrkV
	edTtYzqSQWDrMgIBGguw5I7spuXxEOpqzT1QR3nnm/40evydgbwRS/xJ
X-Gm-Gg: AYBFou3PES4sUDWgZrIePwYtPTKnWEyTZHMWR+uEpdPsjnJqk1UIR7+uLTDevl66SNN
	yF7LW4tND1yAYymuvc0ytOsw6wyd3ArwvMfn5OdvntNiYa0a0SsN3HxNHZfmtMGlqk9n2oYuKVf
	w7kyqslm5/UWAU+b+Na7QIv7rRN643Kgi8QAWSFcl8k4JcSY7817+KEFhypQGGcBoCqgagZrvcR
	c10OuPAcEifDhjXVlpm9oPTM5He1N6jtHLuwU0aY9HcigBItOzYXv1E+Bg8nmRZfwXluMqNlZEZ
	y14ia5DE0oAEjYH7zaYIlX4vDHpOGrR7FN2dICq90h5dmmENWvG+HZPhh0AU9MuebkeYFs2TM77
	HPz5zMVglPRpdBQq+KkjEtBHtGOuJjzkvvTYTmDxBGMJkVWCj2DMFq0yOYO8Oc8dOGt6EkuYRra
	BZatBFERIkQxFG78aS7PcL8/xRM+Y4iNmQzKuZnthpcR5KgXjMF6990kqYzn+DTXXHfoXIOOcHN
	izdrjq+z3gRJrBuwzboOEL+cSbL37qxmSPfOrrmMk9yLwJvRMaKKs4CmT7Eqq2pH3x+okWR0HA0
	3ECLnb4BtKUi3sd4LTJFHs45CcSdgBpFhwB1iT+ue0EXq97OpoGzLXU/ASgmiEO/N/tfDM0rfHU
	SUriJBp6w0qKRinOdlksN
X-Received: by 2002:a05:600c:1986:b0:49c:fa21:e744 with SMTP id 5b1f17b1804b1-49cfa21e906mr154347705e9.26.1788728127106;
        Sun, 06 Sep 2026 13:55:27 -0700 (PDT)
Received: from systembl0wer ([2a02:8308:4092:11f0::f9f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d0af538d0sm97914485e9.8.2026.09.06.13.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 13:55:27 -0700 (PDT)
Date: Sun, 6 Sep 2026 22:55:25 +0200
From: Joshua Crofts <joshua.crofts1@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, linux-nilfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nilfs2: remove '#if 0' code blocks
Message-ID: <20260906225525.6d8b509e@systembl0wer>
In-Reply-To: <CAKFNMo=4VdyB2OovP5hsQejFd-zf=5BMvvMMBTRjQCYPPtzdYA@mail.gmail.com>
References: <20260905-nilfs2-dead-code-cleanup-v1-1-348ed97b2443@gmail.com>
	<CAKFNMo=4VdyB2OovP5hsQejFd-zf=5BMvvMMBTRjQCYPPtzdYA@mail.gmail.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 7 Sep 2026 01:47:35 +0900
Ryusuke Konishi <konishi.ryusuke@gmail.com> wrote:

> On Sat, Sep 5, 2026 at 1:49=E2=80=AFPM Joshua Crofts wrote:
> >
> > There are two instances of '#if 0' code blocks that are dead code.
> > Remove these code blocks.
> >
> > Additionally, remove unnecessary brackets around a single-statement
> > if per checkpatch rules.
> >
> > Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
> > ---
> > Stumbled upon these blocks when grepping the kernel for #if 0. Not sure
> > if they are actually used for debugging; if so, I have no issues with
> > the patch being dropped.
> >
> > Thanks! =20
>=20
> Joshua Crofts, thank you for proposing this patch.
>=20
> I agree that it is appropriate to remove the dead code in both locations.
>=20
> These sections are not for debugging purposes; rather, they both
> relate to features that were never implemented.
>=20
> Regarding the ACL-related dead code, it can be properly implemented
> when the feature is actually added; therefore, removing it is fine
> (and indeed preferable, as it reduces the tree-wide maintenance burden
> in the interim).
>=20
> The dead code related to mount counts stems from a legacy feature
> designed for periodic full checks upon mounting.
> However, mandating a heavy, full-filesystem check simply because a
> certain number of mounts has been reached is outdated; in an era where
> large-capacity storage is the norm, such a process compromises
> availability.
> While fsck itself remains necessary, periodic health checks should be
> handled via alternative online methods.
>=20
> I have just one point regarding the ACL dead code removal: in
> nilfs_new_inode() within "inode.c", there are lines that are merely
> commented out rather than being enclosed in "#if 0" (shown below).
>=20
>         /* ii->i_file_acl =3D 0; */
>         /* ii->i_dir_acl =3D 0; */
>=20
> Could you please revise your patch to remove these lines as well?
>=20
> Once you have made these changes, I will accept the patch.
>=20

Hi Ryusuke,

Thanks for the explanation!=20

I'll implement the change you proposed in v2.

--=20
Kind regards,
Joshua Crofts
