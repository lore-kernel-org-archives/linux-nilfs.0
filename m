Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC413DB31A
	for <linux-nilfs@vger.kernel.org>; Mon, 19 Oct 2026 06:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792390494; cv=none; b=ARm0oSmv1ddFEbrdurGSwoCCVStxv5C5s9aLIAvU6UHz43D4NfGrkFiBA39Ga+U2UBLhls8TOKSXD4dz7I8N4IwwfPCtfdA1OFsa191JFouxMJj7nEm+M0+kDrA7V8qIi+NdxcNIsU9puDBdQCycXZO6oauJiNOgtccBisNSQFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792390494; c=relaxed/simple;
	bh=hLviHrUQcnY9d6Hs59o7A7DhG6hJV3vxIcScsJNeYyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CDYP8HL8qyuh1lnz7lSpnoLFVjI+grYm+P155hpQSna2Xz8Y95PclxJbaCKCaMLFV+qTiI8OURf0A3clr6Z/6wyEO1MhHT2TEE/zjJr+3e9k2MZRhQM33Sy4CPJ6lHhSe5b1ASF7kNZy3crIVDUtlq42wRel5ZHqq3TLC9bUOqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b15sAq9N; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b15sAq9N"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-ccc6b11a19aso597100a12.0
        for <linux-nilfs@vger.kernel.org>; Sun, 18 Oct 2026 23:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792390492; x=1792995292; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CH7/2Pn88Czop2CrZPadAXkcJAGF4wsEW/e1YNB1cxQ=;
        b=b15sAq9NWihv6GFpfqSH5HJ3jmNXepVPacRSjllpONskWo3VoEK4Itgk5hQGhDqVUm
         OWiPBYy0UhE40WYO7DWnLZlZpp1Jwz4eqeXN2NSXpBe447i3vO6tMCc7g3awQB10u3Jj
         jTYX/R96bQphJx/b/em2D3HoMpomNXcg8xaw48nYpVKInNkwqKttKW2Y5t+OgBhBj5Fy
         EbpmE93ZISJExcTC6ZjYcexazX0RFzhEETQCXjJaWpZSM11D4gqsKPPoT80kk/2BPyfp
         49Q5kSYl++unHpMs6blx4qxYak19NowZTS7eZvDPax0vG4/9RmoFI/cMVEqXRgNQ7P5Q
         Zvog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792390492; x=1792995292;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CH7/2Pn88Czop2CrZPadAXkcJAGF4wsEW/e1YNB1cxQ=;
        b=S1oqeGrVA/e4lhGSPdhRRw+N/vA7CJl/CmjY3ZciG61u3w63W3SPnRud32ektDagcX
         ziF3DfW536TBQEUwIRTpvJQgw4Ug1Xhf1xF8mrfgKolmZbJzmgauYkqsQ+VhlWY6zQ8u
         9ucor03i2qSCasfmVbZRgFrS1EsOpTqr3qXn2w9wPlF63xPCh6qyPe9/2mO1rwQMd5dG
         pi0fLC2m8YGfyFb1HPqeYT1Cel1HMx+8KgctWg2xa21gQgve9de0L+CdwkItOLBGKoIQ
         WIhJhZQxdH/KoWR5fYQlm5bp+qs+QY1YDtMYG0iCYqvxrCCCKwy7Ko3mh1CNkNISozKi
         ojpQ==
X-Forwarded-Encrypted: i=1; AKwUvByu7f6fva168ivWvVxBvGY7JclSRCCPqVf2zAiouNcJSOB57RZnZqQJapu4aO7nt2va4H2kRIQvrA058w==@vger.kernel.org
X-Gm-Message-State: AFq9FYLjoM+mZbygiV1sd+dCJ8PfrRQdp5DRQdm77NDzkznc71l0gb2R
	/6b5+BWHl78PGMmWg/BgLaO/9nJwlBlmpyvym93+5SWZde+YAOF5RTZX
X-Gm-Gg: AYBFou2DinYsMhNTpV4JWSwn/Gjdj/+tzYCiUhvdPgZ3bhLmRFgMQuc33dHu/44X0mN
	SnviowE5C9vcB+TOrEvWjcW5rcfV7/yOXSX+HuOSPzhwglvK/A791QV5GELJoFjYL9gi8Cc50TZ
	qGTjvGijjFyc3Hi04ACknQYIAXn4iAJMIMkxglxIMZFdnot5odBzyRUc7VNW/d2eKAf4bO7q94X
	MhC9spLg8WX0yk5PzcFe/BUEd+0y/Ecrqu7/r5lwY7vrvqcFSrqtv6nQ+fGcGy6+v9XQMY2+r7a
	B9lAtxMcsgoli5qXif6E4hI5Gj7uM8BErBoysl7Bius/q7qi84yptUJEi2vIf1AhrRykc/6byx2
	4pf9JNSuBaV8UQC8YvFN8CtRUTxOZP46MpRTLiGEoZ8wz73tLTspXYMpP8VJBNwJPOFzol/+WR0
	86i4Gkio652PkxolU1sqS1aQezv+cQUd4R5WpyYkyMTPi79qSSjKaxx5NCBG6c
X-Received: by 2002:a17:90b:3851:b0:3ab:c80:9362 with SMTP id 98e67ed59e1d1-3aceeea8f3amr5078332a91.35.1792390492104;
        Sun, 18 Oct 2026 23:14:52 -0700 (PDT)
Received: from localhost ([27.122.242.71])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac94794dd9sm19035101a91.12.2026.10.18.23.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 23:14:51 -0700 (PDT)
Date: Mon, 19 Oct 2026 15:14:46 +0900
From: Hyunchul Lee <hyc.lee@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
	ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	exfat@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev,
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
	linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 14/28] ntfs: don't set SB_RDONLY after filesystem
 errors
Message-ID: <atW1VhJXAIvtYPfd@hyunchul-PC02>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-14-60743a3dc326@kernel.org>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-14-60743a3dc326@kernel.org>

Hi Christian,

> diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
> index 4066bacabe37..12ad2ce938ba 100644
> --- a/fs/ntfs/super.c
> +++ b/fs/ntfs/super.c
> @@ -269,6 +269,8 @@ static int ntfs_reconfigure(struct fs_context *fc)
>  
>  	ntfs_debug("Entering with remount");
>  
> +	/* Mark the volume dirty first if an error made it read-only. */
> +	flush_work(&vol->error_work);
>  	sync_filesystem(sb);
>  

    if (sb_rdonly(sb) && !(fc->sb_flags & SB_RDONLY)) {
        ....
	return -EROFS;

Before this patch, SB_RDONLY is set, so remount,rw returned -EROFS. With
this patch, sb_rdonly(sb) is false, so remount,rw skips the check and
return success even though writes are rejected with -EROFS.

I think that the condition should be test NVolErrors(), for example

    if ((sb_rdonly(sb) || NVolErrors(vol)) &&
        !(fc->sb_flags & SB_RDONLY)) {

-- 
Thanks,
Hyunchul
