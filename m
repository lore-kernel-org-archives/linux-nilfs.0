Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CF73BE635
	for <linux-nilfs@vger.kernel.org>; Tue, 26 May 2026 09:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779788156; cv=none; b=rOC4zVkQbxClaH7KWVe+nr2ZkNT5VQIKgg6y/Bf7G5guBmHnDZLvRAWTSuvbcKc1TZ5m2wH3R6Lcv1MsXvz32QWQbw0VI2VuZz66fEDuQxr7MTUCgRBclJrnU1SDaNNk+ZhhMzJOiExnd/f04RGQ4n93NN8ZbaLrWLj1Kk730eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779788156; c=relaxed/simple;
	bh=sjU7RHyInlH9mxFug2LKz+GK48Ojh7vR1sjgQ2TiRGM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NtDAhr0et50KorfErspu91sdhMlhMo9R7jmjw0AzIGyNGVota2EtmDkfHZhaeB0l2rsanjdIyBMi9VpSXu0SJvHmA2nzq6QNJ1qxpuSDqrNAJ5SnCzrO/63WmTFHRKOXrRQKCUokbSGvw3YY7raLo/GByCvpVTH47GyxHtsv9G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=seiq+CXn; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="seiq+CXn"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-452169ae568so6677370f8f.3
        for <linux-nilfs@vger.kernel.org>; Tue, 26 May 2026 02:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779788154; x=1780392954; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2bHfAVXmh3q3FWdhM0EExqsSxnDVRJkOcr0NBrLZ8n4=;
        b=seiq+CXni9aIGbLGM0VXkKywgsa47MjhfAeycLy7TY/OhjQlRKHdvx00QtlkzFePb0
         94cFvPmHHU26vJWePAZj2+oA9GlBflkrO2GbNq1VpcTR9q7MzohCl2Dd1X6Ng7rQil8y
         HdVIbj3NgV4BzluSo9r4qPLEaCSRDsKBiEkYgwXEJJdERZJsBJDWjY3UA7NIhDpqnege
         QtFQRzkX7QvdA9XHnI+h01j8LEiDgfS4JPMni7ZC4le0GIdAHwnucmFIdvGFq9b/9vZV
         EsuUHym5brztgaVyeivqdcarrbd8S4BvVUFDB/IExFltz22m1SxB6Dwhzw0ror8XE253
         I70A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779788154; x=1780392954;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2bHfAVXmh3q3FWdhM0EExqsSxnDVRJkOcr0NBrLZ8n4=;
        b=T55kq8piJXF91iWo7V3N7b9NNFSg8fGATR/eW9+DDr37pn4T7q5AosUM8tmWTbxxqu
         MLVaI/Ym46joX8hADIKVTbMSlsW3kUM+di/Gf5tJXW6DNAozDwGy9rABOFiV2619hUxx
         OpixYgEOUWju6j3rITt0XeH67F4nwMFzh3XfEYqIsl10JTeepiu4X+qPrI9OsV85y8Nc
         exiC1Tlz7UaCSvZ+zRW5q6PwKYcigr8sapsodnKXOu6va5677OKHJIbn6Lx6pwCk2F6j
         gUYsfwki5w/UZXLHjYw0IIvdfDeqqzaebyzQurY8mIMXh9yf0EvQMLpiufCztcuzEnJu
         X4UA==
X-Forwarded-Encrypted: i=1; AFNElJ+8qNVsqsmYFfwE760kO9P7Y0g3rCDxTSTTpo/LSweReJtHXsS4IOfSmBbntGfVsKw5cSqmKUSzu3loww==@vger.kernel.org
X-Gm-Message-State: AOJu0YzoakCRKH8Bj4cUNlPmia5l88LpgL90lXox7/aYVCJUSO0QrV3y
	QTHXz3wFdxlXg967dbZuhnLfKjGKOoujAb0CafUjNhubRsnU3RqeuP6g
X-Gm-Gg: Acq92OGc8sgrq2kwSPUzxLcSBtBjeY4KGroUQoDIEApWbMluy7tRhJVNxGC+toHQaKG
	nwpjffOowwFkxwzk7s01cpvaJ2RkQhrkctIRNDDTd3hJ2wcCWA4GmLYmZAfxHRuVJnvtMs+XzGB
	YnhGwNIuhFLT5KBFdK7fwP4GJxCX1Anb8EGM++lhO13chHLunYY3uWDNiZg8iKslKLZxY6eDxFX
	EJsZStzFcpqsgXM5Na9SJU7QzzVauq+39OCMTZHiR0rBDhupmjoLGJNvcGzVRLxg9JCNMyu6AkT
	XZMHMHkURyxZtu9XWkeHUjEkMHKJbfI4i2T6cMf8uQQWZnUSj8ljJa+croy6GPTUqn7hrApt7tb
	DeTKiZa0AAMaqrFN23kUA5eSGDUWpf7P4B7BrxzE5b7uFvvz+rGGPPgnahKgu/tVg2qi8H/wyCf
	ud8hwN2BLhmkLVKxWAu8MkeRIXiIYbWlmoJSpQgWD9y/73FJjEWGYAozFM01lqkNLcTzcwqduve
	RI=
X-Received: by 2002:a05:6000:4b07:b0:43c:cf25:f29a with SMTP id ffacd0b85a97d-45eb3689049mr28173297f8f.8.1779788153530;
        Tue, 26 May 2026 02:35:53 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d64eb1sm38023448f8f.32.2026.05.26.02.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 02:35:53 -0700 (PDT)
Date: Tue, 26 May 2026 10:35:51 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker
 <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, Ryusuke
 Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko
 <slava@dubeyko.com>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker
 <anna@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, Jeff Layton
 <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Olga Kornievskaia
 <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey
 <tom@talpey.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, Theodore
 Ts'o <tytso@mit.edu>, Miklos Szeredi <miklos@szeredi.hu>, Andreas Hindborg
 <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, Kees Cook
 <kees@kernel.org>, "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org,
 linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/17] jbd2: replace __get_free_pages() with kmalloc()
Message-ID: <20260526103551.0a05ec07@pumpkin>
In-Reply-To: <ahSNFmwAA17pMy6o@casper.infradead.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
	<20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>
	<2omm5gmnv2khshoxkrag5rusd3qzrsqyjgsef2syxgryrtg6vq@ao7oabqwebgo>
	<20260525182134.04045610@pumpkin>
	<ahSNFmwAA17pMy6o@casper.infradead.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 25 May 2026 18:55:34 +0100
Matthew Wilcox <willy@infradead.org> wrote:

> On Mon, May 25, 2026 at 06:21:34PM +0100, David Laight wrote:
> > Would kvalloc() be more appropriate here?  
> 
> no
> 
> > Does __get_free_pages() return physically contiguous memory?  
> 
> yes
> 

Thankyou
