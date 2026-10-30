Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793389710;
	b=MyUV7COMlcTcnELf8GueEILFeAafxux11riU4sLwUDecMVW3gVv6I4sbNzy9UV9rYyjE
	 ExTpJhaT7U2lpGsDhOkLjTI3XbD8isRUoXSlSeJ9/UjVZkUw8bDYdlSl9fDyKIZ1k+d16
	 p7+3rF4fXvUmQN1MYqsAJJFyd2VaBEQdpnS0s16vEUAy/CgZvb3ND2KnkL5x76O7PuKT4
	 bRER1P7DYVfNZJDkv4BdpzFmM6Qj45LDP/iDLvhL1maNgYwiI+1aFGC7dSSjOiI39MeZ1
	 hsYWo/qyqi+s9342gDhtkOFwhyDv2WgmVVp0K0bFFeBFFURRPseGqPK7F9kx80oKhNA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793389710;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=B3QeQKv83CCubBRhLwLfDBWq4r5yqUeetrN4Gz6lflQ=;
	b=46ojJe0bk/Jgxu0Dw2iFCI5SJR5rE6LmkR2NaT9vgFSXcz6ypThT2RfI2D5iKb8gdskO
	 ZDZOGpYwi1Lywdz6KaeTdnvPbMygH1Gu1jpNRzXY/FCGsb9f6NaUIThuXbVkloT2IX8C2
	 XsarQUIUzsaXvOFSnSVWjCtcmzwqptkax94COMv1lqrfjau0lvVshQJUnuJeUu9P84F+O
	 ZnH0voqd0z7YP3w8OIbtMHXpEBZvXB/BifzibIK4NMc2WrHQFmWh9HNGe29QTdGUsaFyS
	 YbEBY0p+wsb38tKS/Hu/SIEd6vHa+6Uw2lOLOGVWBaZrMIBWum6jABeJ5z1XHaG/GgQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="wyv/v7L8";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAE2606A31C
	for <linux-nilfs@vger.kernel.org>; Fri, 30 Oct 2026 19:48:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFAE2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wyv/v7L8
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48afcd7ba9bso786821f8f.3
        for <linux-nilfs@vger.kernel.org>; Fri, 30 Oct 2026 12:48:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793389708; cv=none;
        d=google.com; s=arc-20260327;
        b=Q11HO7iRuxmcp8VMUP8vqe72e/Ek8YRp3sco5oaWxZWS7+IQW0i8cxlINdxTWJ0xsO
         Z+SMr6PtEJ+afsxNjm3FCEYhkJdLLkz3Js43aqUvv082tVtpZvOW+7Ov41CQq7mH5MVV
         eH/1PmHQKF01SXU/g+D10OA5DsknKFY2h6RSzKMiGgxWTM4zUuPkWpNPLwQMk9RHdrha
         riN+Q4kkO8AzzGwr7EQj8tnpCEalClkr9pbixbAqM5jkdYbv67c32sLNSfDguQRvL9eH
         RZ98gPappccRs9nG7sLkhwMChnl8XNKyi8OGg3DkQV+JlCWKGwfqrT7PpCYIAJww43RG
         jt1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=B3QeQKv83CCubBRhLwLfDBWq4r5yqUeetrN4Gz6lflQ=;
        fh=+0EJXv+pQ/B9rIP4BVYet6Vf9hXRf3r4PUYZUqMtJrk=;
        b=WEKc79akvw8+vpzVYf3GL7ejFuvoLXMdd1lDPscKJG9Eii175W0lgZgRd8tx8QEECk
         qTDyS0TzsCEM7Iz3evNubtb7UhpEwd6fnC3Lr4yvMw3nkn7LPQk4JbMlZ4+/MyAdGe2Q
         T7Tw8NBZm5LZJqylidLwbWzB+ZG0oR5ATEj6brBP/lqHLncPtvvhe133zqu5802OaMHU
         Gvw8iPgfwBsDoqHXoL1FfHG95qY122SkCz2rGVOvIT1ZRIpWaMM9CgiC09P9Vnk93iYy
         /qf8woITAv4UKSJIXkZJg2mf72eSj2Ev8/XXbVi2clZXA6wNuRqkJs+BnmM+E608moHM
         PMNA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793389708; x=1793994508; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=B3QeQKv83CCubBRhLwLfDBWq4r5yqUeetrN4Gz6lflQ=;
        b=wyv/v7L8ZjnHsyc20OjjJOPmD/d8wZkqutlwDLWfoawPlVGaLkb+9+1Q4rDqm0kyyr
         lbSR15f762gdfiaSH5Q7eEU9n6kF6PrrymY/LNTU9ZS2K3cEw4P7hxyB3qy3qk2K3HX2
         9EACw1yTy6dG+Th59oeBPohq82am5cg3DuP5ilBO2nTZwcaEXu/Qokyz/TBYdnp8BIec
         9WJho9V8nkW9owQOoX+dF9K+f+xSf4u195/2QTDbn5vRjTcZjNCpDHIMZM1Dd5YXUJWX
         VvuQq7SrYbYvRUp5v66RyLaybHGnVGnuRLAkTqvqY0/1OiP7Wkf58D4Sf0ROqP8yLS2I
         GfAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793389708; x=1793994508;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B3QeQKv83CCubBRhLwLfDBWq4r5yqUeetrN4Gz6lflQ=;
        b=qpVCLgv2lAbstjA8ckeGo9L14aAWiavSr7XHb+RyWTXZDg7tipqFzfApEajYqO5tHg
         OurhMGi9nNujzAA7Kybo59d/qXfhumuj2LBh9kdrVlBZnAKAOT8qQH+g0sY3PqYyzSj/
         Hnjg0oQQQdAvziZjrlmo2TLO0MS8scPRVx9vuwPTcr8jKhZtiQnjVHk8rrpaGVT8ACdz
         icjw0Dv/ooUdZ1Xg2QrR3VdnX433z+QkicbXZk+kAoh3RLkIBuhLgBfxsi9H2lcLMeQz
         A1sOEUwPZRThZW7CdTUIPXo6cUaWGWLiE7U9nWL71iNLoWQyKIV26b7mEhJ1vWNED9Y5
         QuPg==
X-Forwarded-Encrypted: i=1; AKwUvBww/OXMPjeltgYGBvkIKo2qtmALONHl9rHcHCzHNN86OakT/kdKbv1H58pUjFhD8berKvLu8i5aVnIMHA==@vger.kernel.org
X-Gm-Message-State: AFq9FYKYpNTmc50ijtZj5HRUzZucsqF9viyIJg7vgdQHgrpXGhPHBYH7
	oDfEwVwTc580IIVo1ZKN1+jbJE4g4cBF8ZnlZU8RXJK2jHm/MYNXyenHkZ4OeuX/6bFGMAcFCso
	GKwn7pjRi3kebPqbgn1s/XTo1ScEROaU=
X-Gm-Gg: AYBFou2UydVFrxKLNJjPLDiWb3dHwzsK/NND8SGB5/ZtDYOQOoLsM7ToJChgOMUZHkv
	q/d4W44XIMbqOwLdXIeLgd7/X+xShPfr0tINHBp/OW7R2g6F9tf8TDldIIj/kXxG8f2LZRpX19B
	gpRgpvnrT4HJBtG2EHHMzvqc0CbhLNVIcqqO/G+zeV0yl+DIiwd5YZBeoh5rPfFlfZBklQzPf97
	vL9j9Xrsu6y90WTY5rzCNp1ONMCNvJada/1XKs2tff0XZp5ur32b/ydStGzZv8RV/UWKTkLApgL
	ERm/ZGvfPrqV2ZvclYNpT8fEx18TbDCsDERt5iuYl4xfP+ZHsA2YU227o/ix1RvSZxM5dcjkf6a
	w3wpmnXostIEQbu88BfLMVA7Igwmzw1vMyRgrTVELSOamLkPvuaOklj7QEBAnz4Wm03EH89bKwO
	ueCUyihL7yP1AA1yidgw==
X-Received: by 2002:a05:6000:40ca:b0:48c:5304:5e50 with SMTP id
 ffacd0b85a97d-48e6e2620d8mr8708785f8f.0.1793389707952; Fri, 30 Oct 2026
 12:48:27 -0700 (PDT)
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261027215326.2693300-1-joannelkoong@gmail.com>
In-Reply-To: <20261027215326.2693300-1-joannelkoong@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 30 Oct 2026 12:48:15 -0700
X-Gm-Features: AclHuK9oCK5VP76Wbek63tch4M8ewVUH28c6PHPAdmsJkgtv-kMhmrFiNwyHte4
Message-ID: <CAJnrk1bqPCy8ryVjCsUWR2+4jkNE8rJJU2bUFsO3Q7nznsF7xA@mail.gmail.com>
Subject: Re: [PATCH 0/5] iomap: remaining patches for iomap_iter_next conversion
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	"Darrick J . Wong" <djwong@kernel.org>, changfengnan@bytedance.com, kbusch@kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	"Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
	Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, libaokun@linux.alibaba.com, bfoster@redhat.com, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	linux-nilfs@vger.kernel.org, fuse-devel@lists.linux.dev, 
	Zhang Yi <yi.zhang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27, 2026 at 2:58=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> These patches are being sent out now in case anyone wants to look at the
> preparatory patches or patch 4. This series applies cleanly to both curre=
nt
> mainline and next-20261027. If anything conflicts by the time you pick it=
 up
> at the end of the merge window, I'll rebase and resend.
>

I pulled in Linus's latest tree (commit abf8c33470f7) and the series
still applies cleanly with no conflicts. It also applies cleanly on
top of next-20261030, which includes the remaining btrfs, ntfs, exfat,
ext2, and gfs2 changes that haven't been merged yet. There shouldn't
be any conflicts between this series and anything else going in this
window.

Thanks,
Joanne
