Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8B03EDADB
	for <linux-nilfs@vger.kernel.org>; Tue, 17 Mar 2026 16:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766315; cv=pass; b=fauWPNxIM5fgfe8QbdkSsmP47mnYLcOHC/5TmK8swmci0sq8XC95tGkjYsvJP5TsUDTTVbHLUZdory96iahMAaY4TMwiOWQaoASLkidEYmq/J4cVXHOxDc9xfM6faqXCG5V6PTfVonzYfd7lomibq6Aob69AU53D04UgjMZDAFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766315; c=relaxed/simple;
	bh=QjWdESiTg4lyD1OinTpqmJGY5QvJKv+79DRHKnFK8HA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WRe8+q4Oin/EYtk4GwqMqc3sWsMFwO0sck6twm2OvShaw3BOi1RSE5DsmRjyFpk8K+iaKa+KhG0zbQqdEneopEIK0TnBFilcK/sg85oeoI1S/YAIxt0x3zMeKiGRQlzQTYnQpN1CtgqkWkUgITVP6BzrgIoZoQlXAGUNTpwySTM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kBAQ8QZ4; arc=pass smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kBAQ8QZ4"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5a12c310e8aso6278813e87.3
        for <linux-nilfs@vger.kernel.org>; Tue, 17 Mar 2026 09:51:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773766312; cv=none;
        d=google.com; s=arc-20240605;
        b=lOpN6Zus+rUAHq03Yl4utub01JPhPBO5GduIYa2m0e8EIxuHIo1F1OjvyPhTxCVbLx
         J02aE1o0PADKeSP2+Vz9aYY+tsYMBXaZukkVE0fYcBflOCeYqpXGp1tay+fmL9GscPsx
         ZL75NsbT4K13poBpfo7SdoHLU9FvSvdpVgTD593dPE/jn9stg3FsQMIkVZmbUIc5f8A/
         YiIyrL039A025vCsHReIxJbeFCpkZ6qLDaifx/KpNQSt5yHG1nWzUaYUskMDaPABi6i3
         7dIypZOSOwaSzyYIzvn5s9DWoCaZwBeiPkqjk02zYNvd60dSA0lNe1cFoowQOdUSltZc
         kJJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lurC4R0z5Aw1T04iR0BaP1zN3FpMdWTHhxF+K+rr4/8=;
        fh=Bh1yceuNVh1SDjZHIRKEqBiaNuGxEGEqKxX3gfUcrfM=;
        b=GJh9kCjmw6Lw/g68+/n3bSEZVwFEJDwM5CvmQ7rux7/zFbA79o/9LPT5hBncbCoFac
         P3PNO9l6hhzHGqHN6TFQNLV5UaYYGhdJcGvrbbi6X+Jy8Aj5TDVDjkoZSPm21uQsnJqX
         NUm1gzW1TYmF2AqZwFRGITwsFIZpoI7I5RKN5rC4AoXI57kgau34KjaaU+POe3b60R0V
         zYySr74BnwHb+8QSydyp4+JhsUr9P7eQn6rhcxjb0KRZuelKNuPejDrk2VoCoo6fn5Xv
         jqtCEk3jgnO8VmMtp97A7lWkSjaDBC8hAOmFg21G5X18o3ykG2oZ2sdAkYw50d581Wtg
         OtZg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773766312; x=1774371112; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lurC4R0z5Aw1T04iR0BaP1zN3FpMdWTHhxF+K+rr4/8=;
        b=kBAQ8QZ4kxD2nN9Oq4d1LW0+Wt2eGcjGs6sdVfC3TxPTEkspvV3Oa1zci9MPckgkxX
         j3yFqt55jG8ryWeWZmdajhk8FO4fJBnhGakrjb/u/xXwjz1iy6Fh9zARZsNXkrnvZstQ
         s1RSoshRlINbjzfGFWZrhmCyJ9dV5tFd795SkVV2VF66bO3+69AjrwNLxC2IfxJVPUrv
         6gbWPMWHXUuyEPeTo0dmqd7UtiPPDvht+ckrIQIX0gwWHCp4bKmcP+ybQdeNmgDJ30jk
         ENz4KSFEX57lcV/ftuj8kKbiW5SbQU0PjFAYTlh1cHpMZzBxLmwtVBxER5qgl+JFlEC0
         Jscw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773766312; x=1774371112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lurC4R0z5Aw1T04iR0BaP1zN3FpMdWTHhxF+K+rr4/8=;
        b=XrqOV0VoxNFV3a8kWRVj7qh9yhoPXVVciK+96Xl9jYx5tb/8UuSVyqf1kOzHwtNHeq
         8bf558u7s1sA2R0BEPU8XJZLFaBq90w0V6szGaXVB+UXcBXBfHOQPyA1WugEDyknd+HM
         3LfnGwVU8B1cuQKnuKGdBlR1a/eS830u6x9MHtNWZK8CnMxlbIf8Q9CsdZ+eLNlAizwQ
         y8drlepS8gFFCQUnVZr8IihkOouCRlBWlk6gHvZWhgFyJBlVIrw3G3UKribRbMSSQ6XA
         urjSbKHgFGj/80ooSk756yU73UUU6hTmuEWOOAfvbQuzd8Kz1aXsW6Hu/elZ2qldKJ1H
         0ppA==
X-Forwarded-Encrypted: i=1; AJvYcCXIKU3EDkK4eMGFAQMnqa83Yx5nBSlYbvaXnD+AD20J8jE1KQ1E0Mxa+HidPpU5rHESXLTiR46UIqIkqg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzfnW5AWPsyPqg2nFnfNVGbcge3ITLaBUoVGXSy5BHyMT1Se3D/
	Qr1ru1ZTuff8F8ogn/RP+38Fjyf4ISgi3l1FOSQ2bsD99+zRPhP1fNlHesYdhD/c1MsFxYlZQPt
	8qJ8MnAsEi+TDlyfEk/V4CxqM9Ayjx49QNgxREqQ=
X-Gm-Gg: ATEYQzzUYLW+8QRcE7RceW7Fno0d5Xme6A5S/RmJNvHpGv14Pl/hRevMh92qS+5nJ4L
	jcL7o9sFOvg6hlsvE/le0dbE9Xe2nugTohGORcoqu6meizPzU/S8NqjylIV+Q3Qn0LJIxEI78sW
	CHOm8J+OCK8cpK8rzeF4bbf3NIqJk9PN16cqcLrT4jAbfon32i4pMXum0c0IB3YiQKQbKEwLu6y
	pwNOZZkA52dji3UHv8JlNhYbvcsfv0HJ3LfqsP5rkak8+UHbzzCwgGylF1d64RlukEnnM60Zy99
	AtB0e/d2BCCBCNCemxo=
X-Received: by 2002:a19:5213:0:b0:5a1:2f18:5e19 with SMTP id
 2adb3069b0e04-5a2796adf0bmr59773e87.22.1773766311554; Tue, 17 Mar 2026
 09:51:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <tencent_5E9ECE1B9E4B941B182565BAC2BB48336408@qq.com> <20260317151506.881298-1-kartikey406@gmail.com>
In-Reply-To: <20260317151506.881298-1-kartikey406@gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 18 Mar 2026 01:51:34 +0900
X-Gm-Features: AaiRm52a2pHz3sbh6FDZvq5WilwKhUZRGW7P9_olpU2SmLt6iJbXYVHi1Zn63RE
Message-ID: <CAKFNMonq5CyQPWB6FeDT04LQ_rkL-KLDx7oQjBqThRH09FRgMA@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: no longer save to shadow map if the num of
 members is too small
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: eadavis@qq.com, linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	slava@dubeyko.com, syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Deepanshu and Edward,

On Wed, Mar 18, 2026 at 12:15=E2=80=AFAM Deepanshu Kartikey wrote:
>
> Hi Edward,
>
> On Mon, 17 Mar 2026, Edward Adam Davis wrote:
>
> > The value of argv0.v_nmembs passed from userspace is 0. This prevents
> > nilfs_iget_for_gc() from being called to initialize the gcinode during
> > the execution of nilfs_ioctl_move_blocks(). Consequently, this triggers
> > a null-ptr-deref involving ii->i_assoc_inode within the subsequent call
> > sequence: nilfs_clean_segments()->nilfs_mdt_save_to_shadow_map() [1].
>
> This analysis is incorrect. The null-ptr-deref is not caused by
> nilfs_iget_for_gc() not being called. The real problem is that
> ns_dat->i_assoc_inode (the DAT inode's btree node cache) is never
> initialized at mount time.
>
> > A check for argv[0].v_nmembs has been added to nilfs_clean_segments()
> > to prevent this potential null-ptr-deref of ii->i_assoc_inode.
>
> This fixes the symptom but not the root cause. Also note that in
> the original syzkaller reproducer:
>
>     argv[0].v_nmembs =3D 0xd =3D 13 > 0
>
> Your check would NOT prevent the crash with the original reproducer.
>
> The correct fix is to initialize the btnode cache eagerly in
> nilfs_dat_read() at mount time, since i_assoc_inode is only
> initialized lazily during btree operations. When
> NILFS_IOCTL_CLEAN_SEGMENTS is called before any btree operation
> has occurred, i_assoc_inode is NULL.
>
> I have already submitted this fix and syzbot confirmed it as fixed:
>
> https://lore.kernel.org/all/20260317090109.878401-1-kartikey406@gmail.com=
/T/
>
> Regards,
> Deepanshu Kartikey

Deepanshu's suggestion seems close to the answer, but I think there's
a slight leap in the root cause analysis.

When nilfs_dat_read() is in a b-tree configuration, it normally calls
nilfs_attach_btree_node_cache() via nilfs_read_inode_common() ->
nilfs_bmap_read() -> nilfs_btree_init().

Therefore, the problem seems to be one of the following two:
(1) nilfs_mdt_save_to_shadow_map(), called from a GC ioctl specifying
the dat, calls nilfs_copy_dirty_pages() assuming a b-tree node cache
exists, regardless of whether the DAT is direct mapping or b-tree
mapping.
(The DAT mapping method switching is not considered.)

(2) The DAT is in b-tree mapping mode, but nilfs_btree_init() is not
being called because the i_mode of the DAT inode is corrupt.

Both appear to be potential bugs, but their fixes are different.
Have you determined which of these is causing this bug?

Regards,
Ryusuke Konishi
