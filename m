Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795087958;
	b=D7yZjz0zCPGrh/haXapw2JX+90FHZ47X6nMCSj7N6F8Q0gBIeJI4FMXiuXGbWFOIqxd0
	 xGYLZRoO+AIYLVMFNbLNrlk0ne5JJtsKNYByDpliPCWGfUazvR4Q2AlrSL7ARMzrDyNYc
	 1eBb7DQiUkJQWZHvv/2Ey5vC7UmvRpiYszyFBnh47NoUveQXc4QEwgf2F9cAZ+4lGiS5c
	 2TmCr3XcHWW4fMiGpv4NkzL9pojOg4lEn5yCAPD5b6QPss8eFiql0X9d0k9Jq+F/0vKrV
	 1bDzPyw7kMqR8qqrkIaX6PXvOsR3EgzQl1QxK0tqBwaAs8k8sarQHVamLo9RAHIHRUA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795087958;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=PqBQ8j5ygsguL5tPhl5xpRoxskIlciQDD0VXnehK40g=;
	b=syXImKgw1BwjOyZEW147WP72XkOReupiD8FfcOXgOpe8VPZw2NZuE8u3DDSuc1FT7PmL
	 jWm2oNVFGUMzbLBPwjMvEM0ZGT1b9Xs0PmBK3Es3ykbLLAEQxv0CMxIrCILAgxjREPMgM
	 AcLDFD2xiBzCIt9zMt2T4gTds5ZN/JaftoaH4ywtGSmG5NtfBIvXTN1cREILVtVAKDAp7
	 7V7p+rlnCRgjPqYxqYpY4z5KvaJzcJdRhcdpAsT8+u1FHpQ7cxOGnrXbFfvgYCxvHhYRQ
	 oh0Mlx5r9iOcDK7vYPH/LVPgy0cmGxiI/sE7j8jTpk3LxDSBb50qNvl1S8/A8tOCJuQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fNfO73QZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991B5606A320
	for <linux-nilfs@vger.kernel.org>; Thu, 19 Nov 2026 11:32:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 991B5606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fNfO73QZ
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-4a358881793so1101995f8f.0
        for <linux-nilfs@vger.kernel.org>; Thu, 19 Nov 2026 03:32:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795087956; cv=none;
        d=google.com; s=arc-20260327;
        b=G5JHopEM1GOPPt3hTyr1jG7g0yAHbF+xryd+6LW+PtHkuhkUqNjObkgpUzjfjSeP48
         uTdl2km2y1sclZYVJP0qt4Ej4/UPtYK2vLsMCs3LPfJqVxar06rEMf8bZzWOmJfCO/kV
         eSAit6PZ/c7bzdn+yyaXEPV7Vl52yPVXtvm4HXcqgFM2fyRj+yRYve0vYT6nvjekf3NW
         6jfJA2H6XHT6+P0K/5fcbRqZuwB0u3ZpGGnn5N0rV6K0OI6H8TWAuRNeKvyVLHqrGwWh
         YlwfLWPXjGR67iWm8C4DzxDzqjpPCWStwZ4+1GZwzWz+zBYmALFNI4poxriTCNpGAHHB
         E18w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PqBQ8j5ygsguL5tPhl5xpRoxskIlciQDD0VXnehK40g=;
        fh=OKTHB8lYcqpX1L1r5O6npU8QxldPFEYM2Awpkea3bO8=;
        b=mJJNhqB6UFQ+0896oISBCVX3ZLkvwJ7rGSQms6EZruqqcSE7O+18z0vtEYVjnDUVxB
         4JpEePU9R3CmUxkssKOHGoZboS+YJ7leAJgCaFcdhB5OAaKpzLD2r/hCC1ey/BZ5WLpc
         c+K1u5M6M9v2F8MMOnyKXORp6tT0xOsP3EMI4yFDXXpU42884n8vSpiuWnl/Fo7INgZ+
         CKYrZ2464g+4mCufaDNRouI8ORTZgjA2qI5urLSEHXxxraKXr/l59i3F75/MNDAmNxMX
         izB6yN/NaXGyZGKwvD6K5/6cNEPxbic9R6xF7YHIbGKW8YNRSk3Hf+jz9x2KHuvodRM4
         CzTw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795087956; x=1795692756; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PqBQ8j5ygsguL5tPhl5xpRoxskIlciQDD0VXnehK40g=;
        b=fNfO73QZJNoZ+XEhmoiwmwEY94XJGkZrWOXhwbDw/SPHak3wDpxNxQRXeAyzayyqCA
         3fEI6BDKfHOF/Ks2BQdHBAyCWQR9cw3PxjKTx9adbpUbxkM2DWd6mxB8M4zV/7ZiJFY6
         clTHMnQSgwuPtH6nN/uO0BTmY6RS8Od4MhiqLNV3fI5nBpqKOX/CkP+muNNY5iOxSX3Q
         zYjlOcTPG7AVjXgkBHdOOrZMn4VBu2qQo3Na8Az7DPjQ40FT8MN4PIk1erKtw8Jqrd8c
         n46OloxRlj3YF3mIbF1B0DCgu1AMSYrb4IxSaQdq1ajEWzoxpyzYW1mAj8UctCOt9TjF
         2cQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795087956; x=1795692756;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PqBQ8j5ygsguL5tPhl5xpRoxskIlciQDD0VXnehK40g=;
        b=oh2RA+NjJLIBMwB8ue+QYOKAfUXxxP0oJJNht22GySByaThDUK4lW90OglPWYRG15h
         6Kbt/ZSN4EL4ocMjxaMqPE7QaC1jQL7dbI+SpTmCuJ3tkB0W8VnQ0G1IhHRbo2EsNJQ2
         35okKo7a1gzLTkUh+FSVHEXd16lgzafGCIfVpUxPHiLF4zz7hFZOpwTnPiT66H3Fzay5
         7WVPVrtwlPyFVqtvHkllFjggIcRXQ5Fe9G1R5IiUqnyPVNZnF3pJOjsSI+C+tvZtGwFp
         VyvZTIV2ozXQd76+9cUUfxzSzXnP6FmoeHTrkGoLVVxKG6Qj35P1GX7VNoyBvLZJyacR
         swdA==
X-Forwarded-Encrypted: i=1; AL+hErEt1ZTMR3sFsLDS1sgC37aHneSMhZx4nbkwef/Tij0eJ+y+5WBzb0D5X9vUqNBRT1WIDX1IgXEQVDYSSA==@vger.kernel.org
X-Gm-Message-State: APuU4Z/Hi6dTluk7gc5kvBdAd33oUTOLwpdqLirlycarkWDotO0IqXmW
	NHRLtiiEL7PrSMBiaZWq50YkWhLfnow+nTHiDC62NC4CBSdXXevwRhxBs69zhNd6S6fQFgAXtkk
	IUZQIIWLTXx1xMf7pidDxPnWEJj2seWA=
X-Gm-Gg: AZFdTZc0/Y4VavqQjyXX2W6BGT+J/A6adlM1+EIERtqlL+5zxwXDG0UNXJ6mEOW5V0Q
	Tsds8x0GMM27GVkgsDbtzk9l2lQCQbOxoy3848qkyA7SbrVFvvxEJ8Yxt/i59VmP0CuKfIvff7S
	Z1d396snmZ4Xft15rtvhJBK+IrR4tuI1dcsm5VEdQKi1SbNQW158EWT4klQ/vZaXbFGngRoujch
	De9Ks7Rg33PWch9wYUxVWyZrf57s6erxS2vlt5K8yg86j9fXcmGd0epTMsYz5y7LlhX8weCznDL
	9h+THFd0i/ZfWek/CsUmCZ1EQusfE1l/7v4vR4qa++TIWQv7ovQYtQzpx1V0tdQQaMKjvmeWEMN
	Wgk1YFCfnKdPplhE2ZzAcbZn9NH6jTYaz7z2QSA==
X-Received: by 2002:a05:6000:1a8d:b0:4a2:ee0f:4fa3 with SMTP id
 ffacd0b85a97d-4a6346da8e3mr12327577f8f.8.1795087955515; Thu, 19 Nov 2026
 03:32:35 -0800 (PST)
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119083809.3918948-1-wangjianjian3@huawei.com>
In-Reply-To: <20261119083809.3918948-1-wangjianjian3@huawei.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 19 Nov 2026 20:32:18 +0900
X-Gm-Features: Aa3M54q-qbnIylYgW06-OCQcTpgBi_nSmO8VbFNgUXfiWR79HSmNF3XDH0gkvvk
Message-ID: <CAKFNMokeofZ8NU+nbn+FnYHNuQi5JJKhC_oS5+=bH-vhgrOUJg@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: fix leak of gc inodes on error
To: Wang Jianjian <wangjianjian3@huawei.com>
Cc: slava@dubeyko.com, linux-nilfs@vger.kernel.org, fengaojigui88@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 5:41=E2=80=AFPM Wang Jianjian wrote:
>
> Zhengzheng reported below syz problems:
>
> NILFS (loop5): disposed unprocessed dirty file(s) when stopping log write=
r
> VFS: Busy inodes after unmount of loop5 (nilfs2)
>
> The reproducer called ioctl clean_segments on a corrupted image. It's
> first argument is { ino =3D 8, cno =3D 0xffffffffffffffff, vd_vblocknr =
=3D 34,
> vd_period =3D [0x30000000000000, 0x10), vd_blocknr =3D 6, vd_offset =3D
> 7,...}.
>
> nilfs_ioctl_clean_segments
>   nilfs_ioctl_move_blocks // gc iget 8, get one inode reference
>   nilfs_clean_segments
>     nilfs->ns_gc_inodes move to sci->sc_gc_inodes
>     nilfs_segctor_construct
>       nilfs_segctor_do_construct
>         nilfs_segctor_assign
>           nilfs_segctor_update_payload_blocknr
>             nilfs_bmap_assign
>               nilfs_btree_assign_gc
>                 nilfs_dat_move
>                   // since there is no dat entry for vblknr 34
>                   // (entry->de_blocknr =3D=3D 0), return -EINVAL
>                   // fs will be remounted to readonly
>    // clean segments loop will be break because readonly fs
>    nilfs_remove_all_gcinodes
>         // since nilfs->ns_gc_inodes empty, it
>         // clean nothing
>
> ioctl_clean_segment will get one extra reference of inode 8 and when
> segments construct do GC move vblock 34 and do bmap assign, it lookup
> DAT table and get de_blocknr =3D 0, so it return -EINVAL. And since
> nilfs->ns_gc_inodes is empty, nilfs_remove_all_gcinodes will do nothing
> and the extra inode reference won't be released.
>
> To fix this, splice sci->sc_gc_inodes back to nilfs->ns_gc_inodes when
> got error.
>
> Note that, when normal files add to nilfs dirty list by
> nilfs_set_file_dirty, it will got one reference and when
> nilfs_bmap_assign got error, nilfs_segctor_do_construct() also doesn't
> put the inode, but as a last resort, nilfs_segctor_destroy will do
> it(however, it doesn't clean sci->sc_gc_inodes).
>
> Fixes: 7942b919f7321 ("nilfs2: ioctl operations")
> Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
> Reported-by: fengaojigui88@gmail.com
> Closes: https://lore.kernel.org/linux-nilfs/CAO-4RZ2=3D4okHYZ-xCkpV-ekj-a=
SqKLnYGOsRM9A2dD8R4Ozzeg@mail.gmail.com/T/#u
> ---
>  fs/nilfs2/segment.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index af0c3560444f..ea56a26041e8 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2588,6 +2588,7 @@ int nilfs_clean_segments(struct super_block *sb, st=
ruct nilfs_argv *argv,
>   out_unlock:
>         sci->sc_freesegs =3D NULL;
>         sci->sc_nfreesegs =3D 0;
> +       list_splice_tail_init(&sci->sc_gc_inodes, &nilfs->ns_gc_inodes);
>         nilfs_mdt_clear_shadow_map(nilfs->ns_dat);
>   bail_unlock:
>         nilfs_transaction_unlock(sb);
> --
> 2.34.1

Hi Wang Jianjian,

Thank you for the patch.

Previously, once GC entered the loop, it would retry until it
succeeded, so the sc_gc_inodes list was always emptied by
nilfs_remove_written_gcinodes().

However, since commit ce5a5ad1a833 ("nilfs2: fix infinite loop in
nilfs_clean_segments()"), an escape path was added for when filesystem
corruption is detected, which broke that assumption.  This issue
really should have been addressed back then.

Ideally, the GC inodes on the sc_gc_inodes list should be discarded in
this error path.  Also, since the cleanup handling on GC failure still
looks somewhat questionable, we may eventually want to split the error
path clearly.  However, as this works as a workaround, I plan to
accept it as is unless additional testing reveals any issues.

I will run follow-up tests, revisit the GC error handling logic, and
then forward it to Viacheslav.

Thanks,
Ryusuke Konishi
