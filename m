Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=170.10.133.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793225391;
	b=2El7wnSmUiSCumJVAqdUd1izr6XpG6rJ4FvzS3e6JGLhxau8m8yKoGunN+3jk9VKzvBs
	 SuI6MJK6FsiYoBijA3ajpJCZ/qvM4MsosVCD84e08G7Pq8YcS2LndchGpLoII1EAcRJbm
	 NnOG5NTt3/VlKdSIgrlOoRbcqIzOHjHnm8lIv/cF0rYv2vzLBzevXMwnuDLlr7yW1Rij9
	 12a+LjMiiXz8ly6sDYDPEQzIv8d069JxyVYa7GT5nVua3Rwmq/KO7or91mCD/kGWNyhR8
	 EkYRHWxG+vfAHPCSZmhNlr3hqBG1paXyrWVM+zIRbnEce5h7/jZUATosxzFEi1kfZ5A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793225391;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
	b=Xd6hf7dIDBWWkAFyO1uobujRvWcDWSuwysXb8YiEgbpAbPopD6nA9T1IfvYA+oOBykPI
	 u/smp7AK0ZpM4MBsXClb2wbZo/9G4A05MpHcvV2s1eSriOq9v1zFl29SNB/PlC0GhEoM8
	 LJBU3egChkB5V2ddAn+nCcpejibbW/b/vfDuB3+dkAsV86HrJ6HYm4lx9Dlz4Qj0CsfZc
	 gSGrPg0S1mRc1eQ5+Dm53M/LHMfD4LVH5rWHA5Av9w0xE1QUFrSLvtMb0ZD8DfHFt+opE
	 vj9hX5GHKAfzqvRjfN6OSj1HMdR/5ssqlAzpu4VNp6xglHh6Kz7cjn5FVhvSMrRAsZA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=temperror header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=PNja0RrK;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=dMvVeWef;
	arc=fail smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5830606A31C
	for <linux-nilfs@vger.kernel.org>; Wed, 28 Oct 2026 22:09:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5830606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=PNja0RrK;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=dMvVeWef
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793225384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
	b=PNja0RrK+GAXFseGHRAPgDcQljq0pWRU5IrNz2yhBUldeqB5xObADIbjyjHyNHrutF7Pt+
	rJoNk3kv9NPLEvl8XKZoimFvycT999RKjoXG01AAR++Ak8kkM30MDhOQrx+KtOHBWo5kfK
	yRocWGrPgLWx6N9WURbn5mAhp5Y0UlA=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-ZIOC_dt9MaCWk2IccF0HyA-1; Wed, 28 Oct 2026 18:09:43 -0400
X-MC-Unique: ZIOC_dt9MaCWk2IccF0HyA-1
X-Mimecast-MFC-AGG-ID: ZIOC_dt9MaCWk2IccF0HyA_1793225383
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-67906c453b8so313557d50.1
        for <linux-nilfs@vger.kernel.org>; Wed, 28 Oct 2026 15:09:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793225383; cv=none;
        d=google.com; s=arc-20260327;
        b=TSskyY3m7NgmBk+JWyUnGd7mpDwdH2tqBshk8ERJWDpsfPublEF92zyL8me8ZVJo6v
         YFaZ2XHSr+3n78Xf+7vkpXLSubO2ABaTORezoUx94eKJB58/HC93oXhK7pqfWG4Rxro1
         nG6/Mon8h+Z0QB7IQ9MJwT6Hr4XK081cueVr3TbiQZ0A7szdx+mLDML14efqGDzoIPaU
         n4+KQIw6DE7xhdAUe8MrejbX1hlZ3p8aoE699sHFOofku5isbbJ+ffptTKAH0/X0q34w
         47ofslRXTHeuhFMLs1O0RFClKwhRT8DSBu8fm5ACcr+Z5Xpa07uvz+5JBS5obab2rhXT
         1E6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
        fh=ME8tCCzkof1gmj7IhEcm254vo8Pu9L/6ff4qr+YNkK8=;
        b=iXavuGA6PrzSU1BvFAjzwQMcoV8NU22fHeJhZlbYj6tp5ZCcaUh1igqcgQvdRHX2yE
         fxrpz8WwfT8gDfUKhWaZwPbNoYV6+RQkeKnY8aj3VnCkyncFaj+rPWW+MMnd0hpn9mKe
         XjhkfboHcHlKybqknS/tipQ/rFRYJWgIufmKAGx1FbIqEnWr+vJmMWQmq++W9yw8YEoK
         jAcqnyl3UdVzM5iMLwVP3cYJssa+nCDKg8FNKcPQZQXt+z1e/XCBtcrNkWbQNg2dT0UJ
         1R33EdHDzUj6COUh+hiagFuxUQI6xcXK/9UGXrfAH51zd2UW27YmSPj3V8N4hTxTWK0B
         hQsw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793225383; x=1793830183; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
        b=dMvVeWefC8P+UdQKNVCTRzDnhWHngZQGob2rSgzwsZSnRN8SAHr7CL96OPYJXufFq7
         zSTFFPllhPr/w76wrseeWsykFIT3XNeylizZvRvScikFw2Vx8ZBVf5aKYuJSSTUPuuch
         XBaTxNgE5Gyy25Odb94BXqgaNMMlvyhAsHvl+cohQ1ckCaDBDm4+NkPEdFeD/j45D4SX
         9JdubWa1Rkola0sqbNiDrUuR0ynjj8Js5euvpFf83x/dOZOzpzImQtYe9Q9exxMiq/qr
         mXS/pEC6VjG6Gc4ktJQ1wDheP9WEZsIfL+MfkoZBHHuqMX4NfKOOS6gRPfYVsrX4HqWa
         L7zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793225383; x=1793830183;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
        b=I06d+t/2Jkcu+WmXRJG7MjL7GCbzrTqLaFV7GHTXFRw3b6zXJsnwlovAlxWS79dj53
         uwmwjePpzycPzUIfMyOBWzxNPD7Wjs6wcCqlj6BFtf/x2rsLP4dPy8U5uESSx1pIb19J
         FZyTezYlFDAZg1dmavefup120kIITfACOleBIKbbKNZqPQncjshMSh/SVzx+jaBZxBlq
         oV/AtbkbEgmgTO+A3IABIR1BCDpKFO7fVNXq0I7u4Nmv/EUR8zVC+1FaMe82P6enGEhP
         /4/SJIVxoCqgUiZ7I++phHHFbTwNXmod8YyNczldeuZLnAsnoaFIRxoHTiKyTSIkm7YZ
         S5NA==
X-Forwarded-Encrypted: i=1; AKwUvBxzYe3acQ+DUv4M5uZrZ3s0K+EQFcnb9NPVBYhYZhq4zkbrvE20c5h6RzZE7jj7/Yd+8XNNGC5Dc+f/WQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIrEsPOMLC57pzFFjYd09fDjI2sEbEvna5KuHZQhBzE04q4ofgQ
	Nn3FHSwafoBpoJjLTB6P0X8rsG+2sFFZZxL2HFvoXGcVRT9qCNGLUuUZZLtpVEBjlYQROXB6nEf
	WPv+tqlA1GK1xrR6TSnkRuprM7/haP0NRCoHRDuplO7FfiHKWJ65dKZKwKbZ5KC6ptayLMXGByj
	CNwpcPAUawUMT9Lm/GL3NORg8uOiL+43ZPILBopik=
X-Gm-Gg: AYBFou2nGdVeMUnwsCSaQ4RK85i+9mrCCII8esEvJIyvsdNhGjpFkve7vzOWACAPVPW
	aGc2Nd26PYw4b+qTs51VcebOt2QCcT3tFeANx9FDPpV7WUjZKcUWdHXedyFdZ+9x0R5Qe0TiZOP
	Wl2BPKZiqDFH2sYJrKfOHW/4V6EeLKs8EpQ7cOS6vawQ3XBg9cRFVfrvd/JgmarqZrvR3Rr7x7l
	nkpNtx5ivyh1+QXrJnliebgTV3liBRh6sEKYrUNMTRo4Q==
X-Received: by 2002:a05:690e:1918:b0:679:ad2f:3fbf with SMTP id 956f58d0204a3-67a8d0047a5mr704871d50.8.1793225382844;
        Wed, 28 Oct 2026 15:09:42 -0700 (PDT)
X-Received: by 2002:a05:690e:1918:b0:679:ad2f:3fbf with SMTP id
 956f58d0204a3-67a8d0047a5mr704846d50.8.1793225382297; Wed, 28 Oct 2026
 15:09:42 -0700 (PDT)
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-21-60743a3dc326@kernel.org>
 <CAHc6FU6z4kX5R3Og8m0dYOHsjFcw+4Btvfe87AGPxy_EWs0E7A@mail.gmail.com> <20261028-zurschaustellen-okkupieren-inkompatibel-d11525ce88b8@brauner>
In-Reply-To: <20261028-zurschaustellen-okkupieren-inkompatibel-d11525ce88b8@brauner>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 28 Oct 2026 23:09:31 +0100
X-Gm-Features: AclHuK9MzobLdiG2EG9M5KT_ibZzYxdrTghiXff6ZlesOE7YSK8Ag_RtXekxyZI
Message-ID: <CAHc6FU6VSAWQ4RJTO_eLnpqN5qvrShbJeT+ADwiA6ohpq8dO4Q@mail.gmail.com>
Subject: Re: [PATCH RFC 21/28] gfs2: don't set SB_RDONLY on withdraw
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ntfs@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 5:02=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> On Fri, Oct 16, 2026 at 02:01:00AM +0200, Andreas Gruenbacher wrote:
> > According to commit d564053f0746 ("GFS2: Clean up freeze code"), the
> > idea of the freeze sysfs file was to make it behave like the FIFREEZE
> > / FITHAW ioctls. This isn't what the code is doing at all.
>
> That's a pre-existing and separate from this series. freeze_store() calls
> freeze_super() and thaw_super() directly with FREEZE_HOLDER_USERSPACE and=
 never
> goes through gfs2_freeze_super() and gfs2_thaw_super(). So it never takes=
 the
> freeze glock. I don't think that's for this series to fix.

I mainly wanted to point out that this behavior isn't intentional.

Thanks,
Andreas

