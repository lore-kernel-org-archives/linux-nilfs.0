Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562AA22E3E7
	for <linux-nilfs@vger.kernel.org>; Thu, 15 Jan 2026 18:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768501071; cv=pass; b=EQeUBjvi/lkz1ywtt6uAss8Gop/oW0blnMqf5vjZVwuV+djH+ZhPXHGMoV8JOkWOlWen70hTgcAjiz0wMSTRBTXTo6nMyIQwUosyWYkiNqcKmhSsedqrOblQMWVABhHCd4sUoWBq0lae1EnYUqEequtkkK5xbxI/Ka8BJlVUJBk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768501071; c=relaxed/simple;
	bh=lrPbqnzgCOvE5NgsFSOuHcaOEuIUQeGDqGbHFIodw8A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OoMMpfUBDwJsG/wWD0LwySsEknxAG3RgdMuHMQ6J1nuii09Xe/zPiZ89BkJk+0DZudxG0yB24qHiHFxP9ZIpUq/gy9SIJiwIlfXPEBSoWP+r11s/+76pXl05U1bil6YOyG1cSputAzro6XbIRmlYRYEWDSliMeyFiPrSP2KTZqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JRqy9Oiq; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JRqy9Oiq"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-64b7a38f07eso1739014a12.0
        for <linux-nilfs@vger.kernel.org>; Thu, 15 Jan 2026 10:17:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768501067; cv=none;
        d=google.com; s=arc-20240605;
        b=h/sHSHarDajkWH9qcv4VV+pPcXjGL0kw14TVNLJEQUd1VMQ8d/1c3vDNHZoyenvQxd
         DJjXuG8x9pGvHXdTnBocJYD9zcCYwh85l/gdv8n9G3uX/VsiK/MPkIyQNzrIFS4z/8A2
         ORP62RN1DpK1d9Bq2/utzBIgHVlwE0Cxlmy3XFVfRPF92G6Y8y3ANY6pUXnwLUbaDUN9
         RY7DIvXGazl9zmRBh4clcTLvR0c6baru6PB8RInd2YY2kGf+tBohJGWpolXB1yRVjjhU
         issUPfDeCpjOkMd4asMD+0x3Z8uWAkhQj8XRcl60PmI0kgFOjIq8BfFih2lsNlsa3gQv
         WD8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lrPbqnzgCOvE5NgsFSOuHcaOEuIUQeGDqGbHFIodw8A=;
        fh=BhPMpCwa089anddCnWnRk7CAgd3OTO8ZoIF4LCBR5ts=;
        b=hujrmi97D/B79ezB55UvA0Y1V2YYLrAZEpx+2TUFICRNCOGh7twLPLX3ssHy4R55Ix
         5b9ZWgJH/mmAN4Mxp3nu6ECrYo8NoDsfkyuszTPIJscCaF4uD3srzwnzqHQpcN6uRE1V
         f9+zFDfHBRIm5874NFEyw+vJCV95rq/i5TCHK6zkXudyX2yuNrFCEMQQQr7OH55d2xtl
         7LQrW0HuV8xtWVEg/eI5/dL2LpSYCipsxN15sAteNSOqMoEnUkTaulXPXZV0LSjk4Toj
         7n4rlwBSuvaRuExar9QcHVbnDv4iTcQYXXLo+q+sUtSWPYeGQFop13+prcJ3nGz/0tMc
         ECPQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768501067; x=1769105867; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrPbqnzgCOvE5NgsFSOuHcaOEuIUQeGDqGbHFIodw8A=;
        b=JRqy9OiqbHt3NQq3XCkGStTAlcxglCMEMq+vkPdztBR4c+MkrffxyXlppZJ7bL4sv3
         +FXHo4WCeS6ifCEJXW+UdjZqdayxLi0mNMYJfj32IOulawR+3uE9C6Ut2x3X5eVTlY8+
         6iRo29sMNevgrrtfjtiRzEF0k4plHYlK2kgxZb4KZPdGjfbpVgT/wXn6hxIwTOtPADbq
         2v6VOk25RJEEoHnf4r5a+RfNediJCsI/4TTnPiMJgJQLHdyofqjBzPnr34u+fCoLT989
         FV5CVbIQ4AFknrnsxqTVaClS78Bq+9klbvidUC90tZ/EK9JmXeohHKVG3ipODkA8GlnY
         LSvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768501067; x=1769105867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lrPbqnzgCOvE5NgsFSOuHcaOEuIUQeGDqGbHFIodw8A=;
        b=mAxB+Y3c4gM17Httuqhu06vvYv+Q12NWlf9CnlRwCRGVmLoRsbKVHwQXvwzeDRYSiM
         QSDfiXbu9p9Ku2WBeGjptro1MJSpdW03ah7esJfgXOzzJCEFn6edaErC1ilt6ND0jDmH
         IlcpPsqv11mg9VoXDnQFzRTh473HUPzxo5kkG41OnQtelFRmbuwxQhvfuxHNky9K9RbM
         MfS8MLyYVlfa9OMzZMVzCUyX9CfxcLLsTNU3PlbtbUry5yQE5GMD46ARdcvOnGTZNU4I
         yLaNe87VvznmRY0DqhUmzqwVRgLJWL3nnHNE9izr36zymnZ1explXno/jUH0U/7mQ/CH
         12PA==
X-Forwarded-Encrypted: i=1; AJvYcCUGYLbTFyBtuZEUcMBJf5QBRKMzALOii0y7dcz+BF8YhNS/31VBD/g29Q0c1LPwNACeDJhMKomQi8rzEw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxcIqkvSYzaujo1KiUWvw5zarw6H0Yg7Aeyu+Pvd/mamMaRf8ea
	kfvvtzGRu/mYe8T6HJXVmEKJHgCaLR7FoJNnBmpB4heC1plNL857RaNXWY39xwTU6p+23bT6Qo8
	PBucUDP9PrPOMqkLHyF3hy9W6HEsaIVk=
X-Gm-Gg: AY/fxX4t+FV2ieVBIrhB8VpWkzlfNcTmZhCZ137I3lYUku0kkpZTQlgMPYZ/M198vRP
	/U9NEN/BQFifXrsU7b1E3IMrCGuQOivEnuRUoKfzqDWy1eimos5dKBKd4OqXwr34AZAecx9aV90
	lxkkExPhHSD0F9vI27aWznzM9Ucdh1TD/HedZbt7T/Pzq6P6wWsbgOClbFOsiH5rP2kkUmKti8K
	wAa3iMd0BL9WblyHsqkes6QJEr+R+8BFElaTkROuMHWrLpP0we2vwfLUpTHG4O+G5ipdfQwVqij
	PicMM2vqj/h8xBBNMX0EijiJDDlKqA==
X-Received: by 2002:a05:6402:510f:b0:64b:7eba:39ed with SMTP id
 4fb4d7f45d1cf-654525ccad4mr346097a12.13.1768501066374; Thu, 15 Jan 2026
 10:17:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
In-Reply-To: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 15 Jan 2026 19:17:35 +0100
X-Gm-Features: AZwV_QjhT3ZtgvkbHJB7796GEklGCbcNDL5CeRwrn_YYeN3X8FqPO-3_iRnRORw
Message-ID: <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
	Andreas Gruenbacher <agruenba@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, 
	devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026 at 6:48=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> In recent years, a number of filesystems that can't present stable
> filehandles have grown struct export_operations. They've mostly done
> this for local use-cases (enabling open_by_handle_at() and the like).
> Unfortunately, having export_operations is generally sufficient to make
> a filesystem be considered exportable via nfsd, but that requires that
> the server present stable filehandles.

Where does the term "stable file handles" come from? and what does it mean?
Why not "persistent handles", which is described in NFS and SMB specs?

Not to mention that EXPORT_OP_PERSISTENT_HANDLES was Acked
by both Christoph and Christian:

https://lore.kernel.org/linux-fsdevel/20260115-rundgang-leihgabe-12018e93c0=
0c@brauner/

Am I missing anything?

Thanks,
Amir.
