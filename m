Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808B8395ADD
	for <linux-nilfs@vger.kernel.org>; Sat, 30 May 2026 11:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780142193; cv=none; b=mIQLfnI7gxInIG2anUdVRI6GMoKmaOeBUGlNv4vbJrAYb/GSn4VmgfARW0oUzx3uUUMcgGo3qFmqZgLiBwpDUfJKZ/aMZScSFcuOWR3O+fuT9QWJ4+ou2s8ZkuCMm5zkpAfLrsNmxu6xTppJlU+9xUDoTHieOe3/LICBm/G5U6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780142193; c=relaxed/simple;
	bh=vPVEJ8hKeB3x4itSKrRoGxrDanl75hjdD9tPrOA5xRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K1hBLj36ehA4H1Pgy7tIOg2ben2B6Z8WoUaFJtIgeLPXHWZZkeVWC1/lXl4RYkWez9ZXOSdP7Q/3kHCdJvSIEGLXjAzetDG5O1iUCy9taJi0Pzmgfk3r6fXYk55tNgtO4F64ZMw7/BpnfoLmHzmB+hRyB7F4bw2Ix/iSH7XWTec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RoUlD2JH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uhbzbFJ4; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xYchi01f; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=H+BlV4SD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RoUlD2JH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uhbzbFJ4";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xYchi01f";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="H+BlV4SD"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 90BAF67BA2;
	Sat, 30 May 2026 11:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780142189; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qgjWJcJ7G5mvC2h2qHaT6wrC24x8ub9eqEPbzy641hQ=;
	b=RoUlD2JHMlY0J3CAPb6mCFz5vOgvJRMvVmbhSDxIdF/SgV0LcRQAD1dNaBTo0Xt5bHWkp+
	XtfOmvx9JpDzliYxqO2iVSYm4OAGMSfZ3ayzg7fNry0EDQobsfJDDF2Yl+J9E5XDan6owt
	UhaWbq8l6+lnJdeVRNnnZtuD7NB3rPA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780142189;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qgjWJcJ7G5mvC2h2qHaT6wrC24x8ub9eqEPbzy641hQ=;
	b=uhbzbFJ49n4Pi/hjKnTx495HDaaFatitib2g8EEKq8v3DUab7z2SlbZX4CxesUf8HTXaxG
	SBLEqAJlkNAYEeAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xYchi01f;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=H+BlV4SD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780142188; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qgjWJcJ7G5mvC2h2qHaT6wrC24x8ub9eqEPbzy641hQ=;
	b=xYchi01fgq8uuauTYfs7OO09np5wqEq9JBjz/rHbej4VsQ6+SB3afrbx7aAI4iZwQEKRwJ
	HZoFGivT747hUl8SSb0DYgDRGn24itp0LPntRqo6phLsrwbKN+sz+IkfWA8UwWFMwCTObC
	cAYung/rKeiuOSWU1RPUIzTDxbcC4RI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780142188;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qgjWJcJ7G5mvC2h2qHaT6wrC24x8ub9eqEPbzy641hQ=;
	b=H+BlV4SD7J2Y+EsPut3f4v+62O2ZqHO7pYBslMz1TdU3W8Sd2pR6LDvbLzXSaRXTzb3cQM
	s4R11esjC2AGUkCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 87C43779A7;
	Sat, 30 May 2026 11:56:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2sgcIWzQGmr1SQAAD6G6ig
	(envelope-from <jack@suse.cz>); Sat, 30 May 2026 11:56:28 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2C070A0EBD; Sat, 30 May 2026 13:56:24 +0200 (CEST)
Date: Sat, 30 May 2026 13:56:24 +0200
From: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	linux-nilfs@vger.kernel.org
Subject: Re: [PATCH v2 27/34] nilfs2: Convert nilfs_btnode_submit_block to
 bh_submit()
Message-ID: <u2p2cohss4orirs3y3w3xs7ktb4qs5bccrmqrj6i42robb2q56@5qucpltebprl>
References: <20260528173150.1093780-1-willy@infradead.org>
 <20260528173150.1093780-28-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528173150.1093780-28-willy@infradead.org>
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 90BAF67BA2
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[8];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,infradead.org,vger.kernel.org,dubeyko.com,gmail.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,infradead.org:email,suse.cz:dkim,suse.cz:email,dubeyko.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.51

On Thu 28-05-26 18:31:40, Matthew Wilcox (Oracle) wrote:
> Avoid an extra indirect function call and changing the buffer refcount
> by using bh_submit() instead of submit_bh().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
> Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Cc: linux-nilfs@vger.kernel.org

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/nilfs2/btnode.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
> index 2e553d698d0f..680e4009a30d 100644
> --- a/fs/nilfs2/btnode.c
> +++ b/fs/nilfs2/btnode.c
> @@ -134,9 +134,7 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
>  	}
>  	set_buffer_mapped(bh);
>  	bh->b_blocknr = pblocknr; /* set block address for read */
> -	bh->b_end_io = end_buffer_read_sync;
> -	get_bh(bh);
> -	submit_bh(opf, bh);
> +	bh_submit(bh, opf, bh_end_read);
>  	bh->b_blocknr = blocknr; /* set back to the given block address */
>  	*submit_ptr = pblocknr;
>  	err = 0;
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
