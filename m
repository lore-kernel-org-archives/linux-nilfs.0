Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614DE328B5E
	for <linux-nilfs@vger.kernel.org>; Fri,  8 May 2026 18:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778263724; cv=none; b=Pr/rZMk+PQ0KkpXNPhVa9VneGNyaame3+1wjdsRoqMpyndd9dnuORfci7GvYAiMYXBfVjcog/10c81kvFflo8G91dgmiXGvTz94EhOFt1NJYdVIPWq0SmGLzjhL4TEKMIm5Ha93usGXbPzsAAP573pqqvzeMZ5jWbtkhQnlv5Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778263724; c=relaxed/simple;
	bh=6Pl86tXT92Er0RfFT3K0Z8dBBl2dijXzq/pVqogOWX8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EMxnNxvdFpQJ4XrEgFXAWQJLxxNuqIL2qnybcvbcq4VX9RGudmp7+rbwHqQTzrbB2f0fKjPm5CzKrjeqAA7rBH5eArTegDwklh+D3rP5gBgvbq1KdlMYMo3IViSXkPts+h3U27kbUMrW/kdAQA0QAnzBDBstznadBAkW7phhaVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JjTghZpp; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=V2WUylW0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JjTghZpp";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="V2WUylW0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778263722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZB2AN7WFWE7lBaJ7lcZVxXeo6nItoJqZYFWVy1xfbR8=;
	b=JjTghZppGBsDLFChhYzx86UO6WjdVmpU9NjMBzT71faKrYysQtu5UubkQuMIu3VnWg6HF3
	BD1nrhE5Y3LS2mlYqrN54RdpdIPX1Wg5sLzYe1IBruMnqLy7YmZ4kz4InDsoCFSqD7m8yh
	bOy7qrgWErFhLHMlvkJW+PciKs/JnUM=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-Q36USo0fMjm3w7HGBUTxpg-1; Fri, 08 May 2026 14:08:41 -0400
X-MC-Unique: Q36USo0fMjm3w7HGBUTxpg-1
X-Mimecast-MFC-AGG-ID: Q36USo0fMjm3w7HGBUTxpg_1778263720
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-65c7091141aso2477787d50.1
        for <linux-nilfs@vger.kernel.org>; Fri, 08 May 2026 11:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1778263720; x=1778868520; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZB2AN7WFWE7lBaJ7lcZVxXeo6nItoJqZYFWVy1xfbR8=;
        b=V2WUylW0p6cGvTBwWPkqLu8gYT4/00ZH5heUPM9xYRozMUVZ9gIkkDNcmKtvNHdQ69
         ntyxUwWRq6KzJ/WVizS56DNuLUnH9nErApmqhynv/lURqXPREw+FuzU6gBZEzBY9HVoo
         bDWdeUdjWUDUisc3gr4ygKRMTYBJfdVkqtFep9Z/NrKuzj3XVJWikDRYLNAU6WhcYuK1
         +KGMtEdDKrA0MZs210djfgoLKWyWY3P9j/E9T8l3Rk2PP5dhXrPIqLvwU64gOXwraEJL
         fXjKFDjeQ4x++x2S7rBMWAfkeEYKZ8ueXbu99x5TBy5HMxpSlWt22GFqE0ZeJ/kfIfsR
         2PdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778263720; x=1778868520;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZB2AN7WFWE7lBaJ7lcZVxXeo6nItoJqZYFWVy1xfbR8=;
        b=iprhnEgBdPVcg1JFafjaGR0ONSY3irFl9dp56ilxnal8v4xhixbs1q8pE8Us+dsJAU
         dSTqhGF5wAXXXYNage4uaU66Zx1a72kuz9sHtvlPRwsnfqUIV722m9iW6ezRVDbHB/HH
         s6X8gcmoi17gF+OLVrNDeudhrqWGgAkf+1azLBosEZmIM3Dwp8PW3bSi8mqhD+LWRPBS
         SI4ZxDOsbCWetFH2pK8D1z+cdNLPGJh+C3Mjfm/bjTxwwACgjiobd+otwFPkWjL8IcyI
         cVg9N+JnobpQHISbClbzHICYXe8Wj6bnTCDbD0xeZqwjl0lE5HLEBlt7zZNHmyUBy4rM
         3odQ==
X-Forwarded-Encrypted: i=1; AFNElJ/tuioeRjrAKiJm1HXkhRsmsXnLf6XbrkUL5gjVlPzbtq1cKY/Qdfk/VtoiNKqDx0PIM9uMZEz0Z51/8Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxTZMbW3rjZ09JSsRy4uTHnSFKW2GGAcN1Ekmd3dzBI2sfVGQLA
	czlEapJlUCKgQ/2n5F2r6s5Tm8YLePTjyChaOJqi55QGENve0uR2p4xGUuPCt520mqRhncAqcs0
	s2XAQX6Cv/LBl6KtSD/BYmUHMY3On5TigXQOH2aXlozY5qRpRxgcjpmYLRoLFwtEX
X-Gm-Gg: Acq92OGCZm7StZfGMuNyLbdYjpvz/fdPwm1ZclcNtAwc2neZfknvy1+6Ta7dKWQmcoE
	B/p5XgGoq3DXE+QTc3hTxgvqBjmD4fFSqnvyizf7iMOtpBFgWH4kOOIPFbIdlyWZLxN+0P488GM
	VOKoHjXLmFyDwCZSAG9V3rgB/+5oVqwhnKcTEGXWusth+1ORwCChDIZqaHPKXjm8FdwcpOQZJWQ
	dDtYMVRYrp8mBpXH30M/9DOus8GICBcreMsXgGPJH3DfNDFlOlAG2KwAUoi63FUIHNZlPodN+5s
	yE/sGKXssYHBLJGbCp3Ne5kDoJ5/euvm7lKoewbPq4Fj6fnV9Ds+8oAxezIEJ0JcV0/lUhe14kL
	8gLJ3O+sA29rmIKBMJ+25hucilwrgZDfdHH5eYSPFMqB4zlNoyqex
X-Received: by 2002:a05:690e:4849:b0:652:f423:47e5 with SMTP id 956f58d0204a3-65c799bbb96mr9223432d50.42.1778263720500;
        Fri, 08 May 2026 11:08:40 -0700 (PDT)
X-Received: by 2002:a05:690e:4849:b0:652:f423:47e5 with SMTP id 956f58d0204a3-65c799bbb96mr9223395d50.42.1778263719979;
        Fri, 08 May 2026 11:08:39 -0700 (PDT)
Received: from li-4c4c4544-0032-4210-804c-c3c04f423534.ibm.com ([2600:1700:6476:1430::29])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65d969fb40dsm1155285d50.4.2026.05.08.11.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 11:08:39 -0700 (PDT)
Message-ID: <cd793972d323b63f90b486512e220fe2a21b1946.camel@redhat.com>
Subject: Re: [PATCH] nilfs2: fix backing_dev_info reference leak
From: Viacheslav Dubeyko <vdubeyko@redhat.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Shuangpeng Bai <shuangpeng.kernel@gmail.com>, Viacheslav Dubeyko
	 <slava@dubeyko.com>, Christian Brauner <brauner@kernel.org>, 
	linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 08 May 2026 11:08:38 -0700
In-Reply-To: <CAKFNMo=57tDvSecrxGETJYLr2JNZAZ5HYSJqNwFV5dywJ7L5ng@mail.gmail.com>
References: <20260507155021.941895-1-shuangpeng.kernel@gmail.com>
	 <bdc4f9e52d007cc4fc4ab6832906f7381d22013f.camel@redhat.com>
	 <CAKFNMo=57tDvSecrxGETJYLr2JNZAZ5HYSJqNwFV5dywJ7L5ng@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.0 (3.60.0-1.fc44app2) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-05-08 at 11:05 +0900, Ryusuke Konishi wrote:
> On Fri, May 8, 2026 at 6:41=E2=80=AFAM Viacheslav Dubeyko wrote:
> >=20
> > On Thu, 2026-05-07 at 11:50 -0400, Shuangpeng Bai wrote:
> > > setup_bdev_super() already initializes sb->s_bdev and takes a
> > > reference on the block device backing_dev_info when assigning sb->s_b=
di.
> > >=20
> > > nilfs_fill_super() takes another reference to the same
> > > backing_dev_info and stores it in sb->s_bdi again. The extra
> > > reference is not paired with a matching bdi_put(), since
> > > generic_shutdown_super() releases sb->s_bdi only once.
> > >=20
> > > Drop the redundant bdi_get() in nilfs_fill_super(). The single
> > > reference taken by setup_bdev_super() is enough and is released
> > > during superblock shutdown.
> > >=20
> > > Fixes: c1e012ea9e83 ("nilfs2: use setup_bdev_super to de-duplicate th=
e mount code")
> > > Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
> > > ---
> > >  fs/nilfs2/super.c | 2 --
> > >  1 file changed, 2 deletions(-)
>=20
> Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
>=20
> Viacheslav,
>=20
> Could you please apply this directly?
> I have also verified the fix and confirmed that the Fixes tag
> correctly identifies the origin of the leak for backporting.
>=20

Applied.

Thanks,
Slava.

