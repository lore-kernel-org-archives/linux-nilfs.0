Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BEA3CE483
	for <linux-nilfs@vger.kernel.org>; Fri,  5 Jun 2026 08:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780648417; cv=none; b=fiUrA2t0TJlBQUP0LJkJJq73HBcs1wtokG0oEKz4zuPHbYB0+cuxiv5Gg9WtG7kQP5O/nvGuZ5c8l3mFNA6XachNteYNgkKeHTxRhvem0SL4NV2fVxJpuTG9jL2rr38u5vKV7ssi8a5vyqUMyST88rcbIgUhdIBwZV7nm6e6Q90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780648417; c=relaxed/simple;
	bh=dw5ZX2TWY6dZxDUNc60ak9mge7y/ImiGMvgzZEHUi2g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=utsahC5U0hmV5Zl7UsE0RljSA9eBEtx0wU8DqSn3rLwzLz53m8VEdhkf8uvS9P+qJLVtKYQylxZRLheABQpEEB8tYjhhjTx+v3SZA5bIVrLHw/5LIsfCj+UN7fIxq00DYLllkyHnjjEdABoRA/0Bhag+E8vg5oND8FGEaxtt6ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nJz4tggM; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nJz4tggM"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-45ee6d32402so884454f8f.1
        for <linux-nilfs@vger.kernel.org>; Fri, 05 Jun 2026 01:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780648415; x=1781253215; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h7EXbRC8R67rHvzXFjU33E64Dl9gsGtZbMHZP+ijZ/c=;
        b=nJz4tggMJJD7crGEEgG150BuCI8vKJ39zcU6sPIXnQqpOh7nrSB5H0g8Uk6bs7bU5e
         irOPuMEs+7bFgcZ1MKCW9XicfTmJn7qi30DdQswOHtDQY9Pnpmi8ccgZUCQhX+epmpR9
         +zKonV1LwtyIGTavv/CNMmYONEUKzAgFZd6xTR6k9OJ+Z3+BZ3byc3lbePTS3O8R+BSi
         +94kTl+PiY1gxjGIwvqH+uotLZuLb8/FDRtxg8KUwfgn1zT0X4AvJcmGdJtjk5JUt0fG
         L+5Xul89jRKKwtZJwBAIvpVC5zOqrMhNs4ueqEMxS2KyOoKOLWI2lcDD6F3eruBZ8tPG
         X0QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780648415; x=1781253215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h7EXbRC8R67rHvzXFjU33E64Dl9gsGtZbMHZP+ijZ/c=;
        b=UN+W3zrsPOVdc1jmDv/ay+oIpj6d9uFWK02zTGKzBNaXqnREtxgLOszkN/X6u60+m/
         FToi0SX14iWFopu1lbAZGqGULMfiMyB8AGlroUQXGI5cyocmayFeftBYwZMh8kX85Csw
         hDPNE1iWOpkkFooKQIPXZcsIjlMuEPK2hO1Z5aPQfgEzXkApZ3km+/TGwoQeSb7OuYHs
         NkjlPsWrIkETOy8okKuWcPyEyS/L/vNQ9gDnDt8LiHCJ932tBFnYxp9Hs14EbJJShTC4
         dR6j6+zo8wmQe8EAOQxWXBZHTIC81XrFv0APkwTaNKsxPp35UD7aPH+b58wtEPaidgDa
         9hPw==
X-Forwarded-Encrypted: i=1; AFNElJ+HJJCN7CWlZeZA2hx6twTVB5+aC+E1L+YvPpBGvRhl1pz83qQLbSgca7Qa9Rd5jurpK7by+zLA45+Vdw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9z4qv/AobB4oWtoo8Z+8e0XDznrDrXC4CUMr8PktW5Ug/QiDH
	3kqVhHV8tVH6fDtoz7tfdUMkXe9AZff6b5fQ+iObmSOf+ljc81MIeGom
X-Gm-Gg: Acq92OE7VBhglJpUphroUW7Y6FLw7/FWMaf76RPNZ1ljr8im+TeWfAQ6ANS33Xt0WT4
	ZlHK6i4C4M+UxMi8EbCtdraq28iMlAxaem+DnYCi/9H9fHsHuTRnFEIZDxJ9WGAAUJEwPzaP80u
	jDol+AbM8HZJWZ7muQwG8ij/SpURXUkYuOcm4IV5qMbRPKZC7YTtTZBA256uogQnaWJR1NaFoE2
	FnV4/v4R/Mymjrq9KrAL+Xee89Fl0Thcd52/tkX716yRJd/mPu+nc/PzLmTw4zkbI1fR2CEPD/8
	ejWtTbfkgTJEFEPtmeUOd4pUQLqIOnUonfsaQgE8m6X4dYqGztdJGMR8Y5o7nAAPkRsPjgkTny4
	e7xoF1dIwFRojWk2bAkYeYU6xlDMq11pBSEk7PnKG9tlycjva2B6hgajKyhi6akLAJxAZl9DS/Q
	16+p50O0FiouVnFCpQGxYJLaMYS1N04NPlWA6pUUeNwOtBCBfF5JLD//VCxwMf1g6WkeMOojA=
X-Received: by 2002:a05:6000:1288:b0:45e:ed7e:f8f8 with SMTP id ffacd0b85a97d-460304f07b8mr2783510f8f.8.1780648414528;
        Fri, 05 Jun 2026 01:33:34 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2e4004sm24140153f8f.9.2026.06.05.01.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 01:33:34 -0700 (PDT)
Date: Fri, 5 Jun 2026 09:33:32 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>
Cc: Mike Rapoport <rppt@kernel.org>, Jan Kara <jack@suse.com>, Mark Fasheh
 <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph Qi
 <joseph.qi@linux.alibaba.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>, Trond Myklebust
 <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck Lever
 <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, NeilBrown
 <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo
 <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
 <jack@suse.cz>, Dave Kleikamp <shaggy@kernel.org>, Miklos Szeredi
 <miklos@szeredi.hu>, Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao
 <leitao@debian.org>, Kees Cook <kees@kernel.org>, "Tigran A. Aivazian"
 <aivazian.tigran@gmail.com>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, ocfs2-devel@lists.linux.dev,
 linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org,
 jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH 10/17] jbd2: replace __get_free_pages() with kmalloc()
Message-ID: <20260605093332.7b067876@pumpkin>
In-Reply-To: <ximvn6jwgtam665a4droqkp73o55kwvd5uukyidwjesmysobth@oe7rigpsjfkz>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
	<20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>
	<yfzx3jgzwesernofl7mzixa2mhjfii5v3o7yapghtmozixrpfu@6bsh7iixyiov>
	<aiEX4UTxEnBTjVKo@kernel.org>
	<ximvn6jwgtam665a4droqkp73o55kwvd5uukyidwjesmysobth@oe7rigpsjfkz>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 4 Jun 2026 10:05:52 -0400
"Theodore Tso" <tytso@mit.edu> wrote:

...
> I suppose we could do it with kmalloc() with some flags which to
> prevent forced reclaim / compaction, and if that fails, then fall back
> to vmalloc().  Is there a better way?

There is already kvalloc().
I'm not sure how hard that tries to get kmalloc() to succeed.

-- David

> 
> Thanks,
> 
> 					- Ted
> 

