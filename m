Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604CD24A07C
	for <linux-nilfs@vger.kernel.org>; Wed, 27 May 2026 17:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779903780; cv=pass; b=S9RhFhUvKEowylrZqSMB1UsYabPfAZYxB4s+qX3pg3ZSlm8MA6yDc7s2laqI1O8eBga4dnZlTb6ZBDLCy4xpj8EmGQIAx+7BuX04JLQz8VRs6RknAosVXTHn/U82Tq+GWXkqiQSsgcx6IUun9mwhykaPDfbvQohiq3wYKRkxaJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779903780; c=relaxed/simple;
	bh=GBIPC2mOXO+C8mP0OPNZVgrMcvb8lRAc39IWp2TURbA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n5l1ZTTOZIhtj+WrZTCY9KwiSDVEksSZd+TevQLQHck46Q0xkTfvlde0jCalyJ7E7ePfdDwZ2XwrTH9QwX27fBUu//wt8AyvTuYM6xTiZhCihDHRcMdVBCwPTyx8ZRboN03ZUD9r0YNaQOvaEOAsxyeFY0tuo8B7ymzzMQJwXSw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o0PXxfLw; arc=pass smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o0PXxfLw"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5a877510541so13034490e87.2
        for <linux-nilfs@vger.kernel.org>; Wed, 27 May 2026 10:42:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779903778; cv=none;
        d=google.com; s=arc-20240605;
        b=Op37Uge1bhJD6pLM6kW+r7IxmeEn6rTLHYisYMgV1hsaG9BNk8fmwycg8YZDnkFQQJ
         R+EDlP7Sj16aMcUF6m7A9vyW7mQYUd2cROYFyY2vWye7Z9NWoPudT72X9nXZA/7lgrW1
         akf8vQ8hCYa9A0Hs2d2wYfTefvEF/0qLuuDH0gQWPkNGbgUpL3lBgY/NAJhxSUjOjmLn
         hXvKDmnJbOaQgwmwjrwDY9t99CaUhkbFhqSh/D11Jv2L8lSLoaNXiBLRBI5un5BVHSxy
         fUe+hetG5dwhxk9eUgy57+vFKbLosOGPmbgh5+LPfK2XOpSVMgctNtz866yTIlNlUsmm
         2ONw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fdSLAensyefgAJdHATus0kj3/VI6wqV5LI7xg1TKSH8=;
        fh=qryO1uu9DIEPra+WhdxodTFLGNSOo6fH3P9PV5guhp8=;
        b=QmmxrXYax0a/oMiar6qyR4FLw3OyYdTJTnPneBbznRXXsKl+lAI0Ov1JT27poZSlrZ
         G5U4MnTZyNeHGsGhk/LMS05jZLAVpVsWnYH3lly3LcC/ZU2EPAZBv4vZX1xtk3K1XNPl
         jNQR8kwJ/HBp53tpXgVWO/EdLZZ+Hwhfa5Mmf1Fh3S/u7CzD5RyrFZL9UYUJQkjuR/2K
         jmBcyuv/OMSwde8X+6xITpQCybPrdwtQyJOguq8XHY4mbxKNWycryoaNRq9THrIWBQQr
         qhxivTRFRUgDYSR2Z8eQ3J17ZUhrAdgzXOgPRJQG65EHyfp+XilaiK0rNRFpNPSeraxw
         i+yw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779903778; x=1780508578; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fdSLAensyefgAJdHATus0kj3/VI6wqV5LI7xg1TKSH8=;
        b=o0PXxfLwmC5rwT5bUN42DK7zJMRjxnbCMKUi/5HtJphnzjr86oUbgD9wfq5CJqo+SQ
         LsWmR1gKvzU/PuLiBZzx2pYZqL7umsrs7FlwmDIDjcqUkBspdVLFYRvUgKdEfBlKXj3l
         jRQ0Kv2sQWalJGxeKTdj0XXh+4gPfYQhu9xAA+3J4cFJM8j8zM4gkXzETndeBWBal9Sz
         G+da+DMVWGzaxnWtvlXcr9QqiEVNIvwqYcys2OhFVnLdx4t+9gKTxn7uCRqRLjDIP6Ru
         c4RzvywTTUmlMH+0TMyBTx5VBQxEaVN8sQn3JNPJDt9qa7UC0/0503wHdLvMFC0Alq63
         Jj4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779903778; x=1780508578;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fdSLAensyefgAJdHATus0kj3/VI6wqV5LI7xg1TKSH8=;
        b=qQ3l8KAp6fuPR7fnsxpkxBX0ZHJSwFt5AgxDVdbFAzEIlTG3LEQHxT+SQVta16aoGk
         iI6Y4oTh6I0uoR6lxZjULIeV6DEGStUheQMhHDOCN2zxsgIrL2jKyoc3foesLnUW9Knz
         FQ5LApfrnK8BEDnmtXI+UJXxv8XP4v4eShzUOwuS62plEVsiBUDCf+wGy22KiuL8Qpn9
         CZ6VH9Vj/Oy11yUrBDo7agUsCZhznfc/69YKbsK35kwmx490iRUHYdD1xSIVd8W9i6VU
         aNV6jmIEGUgaaHAu+xW7pcdrl1C4xxlQxE7vFZbeEih09aOOMbYUt/ObskGkifc+6EEK
         RwtA==
X-Forwarded-Encrypted: i=1; AFNElJ8+70xmy32ZgY9bRSF0G2b7PCuHQ/kz+z1U/qntTLXfM8J9uE+PEa6wafcq6C1DA7QXSA8bqN2pUum2TQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1dr27OVlBV4ekBBsBT0qAtK8s316TDPocFITqrPkTUwUrGPGH
	+d4MBwWhE36Zifw/PEXAMNB//gvpSD2biLFDV6Vk+AWXll90yXJiZmR+SXvog3qrnifa+qZqHZ8
	GAJIGORxfR/GEvb5xrSwHOkDfyaYpXeo=
X-Gm-Gg: Acq92OEia6JugE7KLuZyc1akhuGSBDkdAQRFJGvG01VnkbwD+N3EkQco874dezBxmJc
	umPbvrYrGbKWv5cLaJSrWkTrVkTaJ3r2Zp0SoWH/nZo0pryFiviuCHPAGXhubcB84CoGMbiTaSQ
	Z0GxE6tRgO+H+rTJ7MNF7CIbeUHhaBP6Dq5Yj9QjtgwdTE1SRngoW5D22v/Vzxk3RO0Vq1m7tP0
	JVAut3MMbCrt7qGf5bj8CyqaLopkDRUtLjGLEWGL+56NdmO2arofGRCHnEWFtgEShDEhpVEn3tW
	umszdkWE0o4+m6jRGc8=
X-Received: by 2002:ac2:4c4e:0:b0:5a8:89d6:93c3 with SMTP id
 2adb3069b0e04-5aa323bc5dbmr6759557e87.21.1779903777308; Wed, 27 May 2026
 10:42:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260525171931.4144395-1-willy@infradead.org> <20260525171931.4144395-28-willy@infradead.org>
 <e078ab852f15f720e609b3691c1e61bd1eaeccc5.camel@ibm.com>
In-Reply-To: <e078ab852f15f720e609b3691c1e61bd1eaeccc5.camel@ibm.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 28 May 2026 02:42:40 +0900
X-Gm-Features: AVHnY4Io1qpGXQE2Cpsjzt5vJ_ty_bhsQeG5fEt-UPP6TXngdbNNmO9hpPezYZk
Message-ID: <CAKFNMomQOg0v6kRc2J_TrGE8h8xO3MYMXjoZqDdM+JR8dUJBqw@mail.gmail.com>
Subject: Re: [PATCH 27/34] nilfs2: Convert nilfs_btnode_submit_block to bh_submit()
To: "willy@infradead.org" <willy@infradead.org>
Cc: Viacheslav Dubeyko <slava.dubeyko@ibm.com>, "jack@suse.cz" <jack@suse.cz>, 
	"linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, "brauner@kernel.org" <brauner@kernel.org>, 
	"hch@infradead.org" <hch@infradead.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 27, 2026 at 2:52=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> On Mon, 2026-05-25 at 18:19 +0100, Matthew Wilcox (Oracle) wrote:
> > Avoid an extra indirect function call by using bh_submit() instead of
> > submit_bh().
> >
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Cc: linux-nilfs@vger.kernel.org
> > ---
> >  fs/nilfs2/btnode.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
> > index 2e553d698d0f..0a4b61498eff 100644
> > --- a/fs/nilfs2/btnode.c
> > +++ b/fs/nilfs2/btnode.c
> > @@ -134,9 +134,8 @@ int nilfs_btnode_submit_block(struct address_space =
*btnc, __u64 blocknr,
> >       }
> >       set_buffer_mapped(bh);
> >       bh->b_blocknr =3D pblocknr; /* set block address for read */
> > -     bh->b_end_io =3D end_buffer_read_sync;
> >       get_bh(bh);
> > -     submit_bh(opf, bh);
> > +     bh_submit(bh, opf, bh_end_read);
> >       bh->b_blocknr =3D blocknr; /* set back to the given block address=
 */
> >       *submit_ptr =3D pblocknr;
> >       err =3D 0;
>
> Looks good.
>
> Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
>
> Thanks,
> Slava.

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Thanks,
Ryusuke Konishi
