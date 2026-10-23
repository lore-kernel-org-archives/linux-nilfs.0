Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792718027;
	b=3wsf+XYYLlzko7Up3plySzkP6WB+RDWIz0G5agBzr1qFo32ERPhDktioHjoDRKtKJ1Ru
	 n/BCZE9Jq89R60BDw7CoW9o1vvRpyRMLMVHTtiUX212SrUlyRcS1RtIeo5cOIjVR+Je3z
	 R+bQrEVIG+Bd+Am0WADJXgCZ8aSVSRFAGRdM6xPLzB5cDlYVlBM2hP0VNA0m1fO1KuxBl
	 FRCszdpYsuXa+FkiHwjIO0wH2kFBdRkDn155CT2fxtV/s2PfIfvfJPYJZpq6dxb6qJsK1
	 D8Hl3zNg0o4/SQ7ipiWtM08K072JkMI7MK2xXmDGrKCqfNlTmqkdtPKuTXecoWgLGwg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792718027;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=tG1huFZNxVbEJ8XFnOVD6N3fEf7gVxHcg8lll9mK/BQ=;
	b=ebQSzrYzYI8S7Hz3T9MsyLsM+VgVgOXrQj5Gbs+Ic4UtScvVeWteM52is0eoG55CN5zI
	 5/VWW+5nTSiJsZBmFbr5W3Q+qgG2HwCLisKYCUOxgluDXJ5UMxJ09sds0mmrrQgTrBdgR
	 E+rXJw3RNraikee5RtCq3YGSHQ00UcomEJjQ9psBdxQ0rr+YzVj7xNuNnuWIDVPc6CiuS
	 5mjURq855nvtJdQV05PUNZ1ndZtq5b5b91tN/jgp0LuKTN6ushcIyU4q04eNrA81JswUM
	 IPx5CbVo0cOYEBLZ6URY7quYp+2Lj8S29Tt5DhXdKeqs6i+PQYhQ12MK6m0NgR8zy0A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=jddypwW7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F787606A31B
	for <linux-nilfs@vger.kernel.org>; Fri, 23 Oct 2026 01:13:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F787606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=jddypwW7
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48e09aa5264so170075f8f.2
        for <linux-nilfs@vger.kernel.org>; Thu, 22 Oct 2026 18:13:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792718025; cv=none;
        d=google.com; s=arc-20260327;
        b=k8zhpwUvhnd3RihIGlLNdxv1DsCX8by/5VvtTOhorOw7YJhZKin5cuarAAIZcgYoIk
         sn18pswUd6lygGnG02q9EeKTkaHunx8/SqAv4+fWRrwZ/UOMmKtf3ciMHP8HlR7Drugy
         X41b5HySZqdQhrwYirtyKVA7cM/lkw3X7gn9LVvSlP/fMOd6vBwWUuNDRr1ueqvaHLP6
         p1t0IMMi05vLY0rMn7zzuch8DCSvthY9lKAixqBUA4jkgc03X/E5lB60w6WImXcnlDR1
         ckf75lEJxCSG1F61FEAL1WlxXHiB5amhjn3JCidMLW1rKMyKXIuD1830uDT7ah2efINR
         pi6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tG1huFZNxVbEJ8XFnOVD6N3fEf7gVxHcg8lll9mK/BQ=;
        fh=KJGEjTzwYu5KL5jw/nXlBvFqM9l+0EvrhkpAyuNGCGs=;
        b=P9kCl59tQ1jsY3TW3y2Q3W4/ZDtoLGm/JyD/5vImNIwDxhEYd7mvuf0qdQk8hFGXWB
         z6jR/3c/hsSYOOBhjeZrZZatP9sTD82ay2zKtOEzvjyxbWkZvu/zfdAiiHd0rqdy/7za
         0AmvH6oLYM7amfjXFVLwhkkFw1P7jTNIKPUYE7/Qc/Nta8aJgjg2z2tIpcrfsUkrYmgL
         FFBTcWI1o5HDr+fk8txYd23Khyx+zMa7daJGOcVyohztviutLvnfn3LKtc5NGnCF/Xak
         KqB1kHI0D3Bpwumu5K7C9kf08m8j8A6pliRQezwZAPxNHOS7Rg+C0FUarjUII5VTn9Kz
         1K7Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792718025; x=1793322825; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tG1huFZNxVbEJ8XFnOVD6N3fEf7gVxHcg8lll9mK/BQ=;
        b=jddypwW7JUppD2JCsVIJJhFrqBIKxP5XvFnlAq43nR1XVfMHjgZMwn/lLuua44C1ey
         Qban6YbojUdjUd3LZfTfgiJsiEaEqxPMbpnFR0EdlASZvyUxv2VWoJm5hSwLWBb/pNW6
         WvcDvmfZ1Ph80Z6riulc3F21Tqj/QaiqQcPNLDwSuK8TsA1ZB4sSvi1qFoPOIvpW+xPz
         R5/7+YuVUE3HvQaMaPuEHs3nFv1rI+G0Sd8Ppnmnjc1wdTWcLJavNXwBCMqeAILgyld7
         xvDipUVyeRx/PEypeHCX+zrnjXxg7CqWtm9O+oGhHG64bLKLdpBfvCkCKfF3qY+/bNf9
         58qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792718025; x=1793322825;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tG1huFZNxVbEJ8XFnOVD6N3fEf7gVxHcg8lll9mK/BQ=;
        b=IcA4fUIlLCdvVlt3CfIy1AMVeMDQq5WdFcXbpWw1cX/8pOf5vQP+ACZ3NJx/m5dwFP
         m45RpC/XyJqSkRUK5Rssuo7Apq1cIeOvqLm8PMHtsp3lZv6f3a8ep5Splsf+E+EK4XAa
         sflO8qr5shUpsthzMBdYVcJYp8uauojiYhIa9tp466JuUD0ENTIB+brDwUNM/uDce44V
         jLrTXZ2EvnMdr+SmQs9PcnQZMLkDQOoByBiBjaSGRbXsB+EwuMI1nksFRyR6QpguLmXA
         PQpCJJsCC9ahJrQaDtQ46q3G3uShWIowIrWXS2QLO7YWtGYBkoAv9sgSNIqsgb92TykM
         igEw==
X-Forwarded-Encrypted: i=1; AKwUvBw9b/EBzoPaFqN0rNDnYClRzWdl5vm7kJS++HUrsJI3Y05B/8oscjeQupyGtuP4tNSQ2GuDjrozwfwcIQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYL30ggrOG07xNB+xXDFFMaVXqsJJY0p7uagjBSASOUqMMsVt/rU
	1NHnHSXKfI0lfgZFOKW3w+db197YZ99D6j6WxDzKTU6dcr1wUiV3HXIxOnQw71FgBeVrHXoGP4u
	ekQ8HoQQMPJnlJYJVzBjoFk2Q2CKS+iw=
X-Gm-Gg: AYBFou1iOZqrYCTqNoiblbPyu8NnRbd73IzBKSXm9opRJltqMJii6/PlPL8Y5btYei5
	5pJ6KcEV/yPa//SOQ4RN2A7tH6UkJM3hHjlAy6N2sTTkezkBmgSeoW63ag3oroqRb8iuD0fMzeH
	A+5BWuAwEKr7TqhWMfcEQRK2QNJynorSZdMvWlFM+/ksyNLBXBP6JtYyQIKD49ITCdcOZWJxBf+
	CfhyyTQ9mFWs1uN92i8HXPfe8O7nUlEwMu1tBpIVrlh6LsWsPqo9uWBcVWmnspiXJak8QAraF42
	qJLEkcJSmwy8QSrXv1MrIktqq1SwXkWN2y57/8DhwuaiPKfBeZW1oDb5g199UVMs71lGetZD7eH
	yPEWcgR3Sp6dNO8JykFs43WT+kBrFi6PIglUP6g==
X-Received: by 2002:a5d:5e8b:0:b0:48a:f404:695e with SMTP id
 ffacd0b85a97d-48e385bd508mr813127f8f.50.1792718025240; Thu, 22 Oct 2026
 18:13:45 -0700 (PDT)
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261022220637.89697-1-breno3011alves@gmail.com>
In-Reply-To: <20261022220637.89697-1-breno3011alves@gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 23 Oct 2026 10:13:28 +0900
X-Gm-Features: AclHuK-pRUO26_pnOdG0dntPiPDuOPrxpOIYxFOQTtHB_TJBkclZoTcflgnjzSY
Message-ID: <CAKFNMomoPV87KM94eYMHNz9WG9CuAHOWVEgPbsEBUZi55jhHpg@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: remove two dead '#if 0' blocks
To: Breno Rodrigues Alves <breno3011alves@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2026 at 7:06=E2=80=AFAM Breno Rodrigues Alves wrote:
>
> Remove two blocks of code that have been disabled with '#if 0' since
> the initial nilfs2 import:
>
>   - inode.c: the code that would have read i_file_acl and i_dir_acl
>     from the on-disk inode.  nilfs2 has never implemented ACLs, and
>     the i_file_acl/i_dir_acl fields do not exist in struct
>     nilfs_inode_info, so this block has never been compiled.
>
>   - super.c: the classic ext2 "maximal mount count reached" check.
>     nilfs2 reads and rewrites s_max_mnt_count for on-disk
>     compatibility, but the check itself was never enabled.  Removing
>     the disabled branch does not change the on-disk format or the
>     behaviour of the driver.
>
> No functional changes.
>
> Signed-off-by: Breno Rodrigues Alves <breno3011alves@gmail.com>
> ---

Hi Breno,

The same patch proposal was previously made and the changes have already
been merged into mainline in the current merge window:

https://lore.kernel.org/all/20260907-nilfs2-dead-code-cleanup-v2-1-fa1ab5b0=
abd6@gmail.com/

Before submitting a patch, please make sure to check the latest mainline
master branch, the linux-next tree, and mailing list history.

Thanks,
Ryusuke Konishi

>  fs/nilfs2/inode.c | 5 -----
>  fs/nilfs2/super.c | 4 ----
>  2 files changed, 9 deletions(-)
>
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index 34e609606..c5b0e9f27 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -422,11 +422,6 @@ int nilfs_read_inode_common(struct inode *inode,
>
>         inode->i_blocks =3D le64_to_cpu(raw_inode->i_blocks);
>         ii->i_flags =3D le32_to_cpu(raw_inode->i_flags);
> -#if 0
> -       ii->i_file_acl =3D le32_to_cpu(raw_inode->i_file_acl);
> -       ii->i_dir_acl =3D S_ISREG(inode->i_mode) ?
> -               0 : le32_to_cpu(raw_inode->i_dir_acl);
> -#endif
>         ii->i_dir_start_lookup =3D 0;
>         inode->i_generation =3D le32_to_cpu(raw_inode->i_generation);
>
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index 893a504cb..d0faae49c 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -826,10 +826,6 @@ static int nilfs_setup_super(struct super_block *sb,=
 int is_mount)
>
>         if (nilfs->ns_mount_state & NILFS_ERROR_FS) {
>                 nilfs_warn(sb, "mounting fs with errors");
> -#if 0
> -       } else if (max_mnt_count >=3D 0 && mnt_count >=3D max_mnt_count) =
{
> -               nilfs_warn(sb, "maximal mount count reached");
> -#endif
>         }
>         if (!max_mnt_count)
>                 sbp[0]->s_max_mnt_count =3D cpu_to_le16(NILFS_DFL_MAX_MNT=
_COUNT);
> --
> 2.56.0
>
