Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B6F3AB5BB
	for <linux-nilfs@vger.kernel.org>; Sat, 30 May 2026 11:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780142228; cv=none; b=SJ2I4ijyCq2Pvcr7+dEewcDEWy0zYGHofH3brxe9DSyJQn4xE80bopKqEORfyHvJ8VQ2NbdIM1a3kHMhD1sOe/CqiDd6JQoHmjX1dpooQg69R2wmAvYo8MdUvHtZQe/BflOdJ4OaZN5cfgCXQzdJbIR3cjVLy7dM6y26ugjLrZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780142228; c=relaxed/simple;
	bh=SjNnDqka+sLItlhn68+ImrLz4augRn5SJesxT7zpZ18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rN3adsSYPNqCWdKppNNogG0qe9FKLAgbSkueMgD3mwlYei4l3ODEQIBLmi3GvrYVkmBpQcfmbc2MhiLZawxDsQ2qVF06jEcmta2a/4W0GD/2uk1RfhtaE3J3v+NC0bIOUxxByfwA8d2wcTU1apX/LuW4FHWhCOlh0IMkbYY9WPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MEWS+2Jb; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wFG28gVy; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tlaf+8WQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=WBScVYKZ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MEWS+2Jb";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wFG28gVy";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tlaf+8WQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="WBScVYKZ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E6CE767BA9;
	Sat, 30 May 2026 11:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780142226; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l9V2ZWnu9qpxlC81Gzv2iXJCv4rALtSiCFUT/860zzU=;
	b=MEWS+2JbTpGqpQ9vMgRkFJqnYRDMaIT+xR+fl5un15OmxOZY5Wy0L6N4pYL98L8uflnCqQ
	5E5cHU8tNLsZJ+OT6Z4iItaoJRXAbldjWrZ9vIe6MsEVXAuozlbnBPjrAvbmy036OH+RQr
	FXVSl8AMR1qjsfdSfdrF30du7XK+0iU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780142226;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l9V2ZWnu9qpxlC81Gzv2iXJCv4rALtSiCFUT/860zzU=;
	b=wFG28gVy6kYxQxPVey9pIIpvVg26hab8Wc3nL6/+DXZ5jjXuZIHklgTyFvauqB2lAOHGGx
	RsvN5jMy1L9tczCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780142225; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l9V2ZWnu9qpxlC81Gzv2iXJCv4rALtSiCFUT/860zzU=;
	b=tlaf+8WQF+khw5MZg8Be9W4W55AmSseTqrrVuWs1TGqqJHxYHBUc6KVPZ1RCtUhoA5r0BB
	OLauvREV6IbwIclIDn9r6wj6XK5x5p+6uZiiCj1gOyCLGlY4Lxvvln2s1o1LnotG1CkPZE
	wVyTfCyyCp0Pb/S/AwUZEYUSCQ4p04g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780142225;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l9V2ZWnu9qpxlC81Gzv2iXJCv4rALtSiCFUT/860zzU=;
	b=WBScVYKZF+VRPBp/O6NfHY+qWo2qPL3DvnF/CB22wvhSyRE6+k19XyR9wQZSJl6KG8BkDS
	qtMN5QzAP3RQQfCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DDB81779A7;
	Sat, 30 May 2026 11:57:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jyQgNpHQGmqWSgAAD6G6ig
	(envelope-from <jack@suse.cz>); Sat, 30 May 2026 11:57:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9AFA4A0EBD; Sat, 30 May 2026 13:56:57 +0200 (CEST)
Date: Sat, 30 May 2026 13:56:57 +0200
From: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	linux-nilfs@vger.kernel.org
Subject: Re: [PATCH v2 29/34] nilfs2: Convert nilfs_mdt_submit_block to
 bh_submit()
Message-ID: <peqwiia3a43koxfgeltigew5vkp6rj3f7iehoqqgphzg6mwkb7@77vq7yegbtme>
References: <20260528173150.1093780-1-willy@infradead.org>
 <20260528173150.1093780-30-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528173150.1093780-30-willy@infradead.org>
X-Spam-Level: 
X-Spam-Score: -2.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,infradead.org,vger.kernel.org,dubeyko.com,gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,infradead.org:email,suse.cz:email,dubeyko.com:email,imap1.dmz-prg2.suse.org:helo]

On Thu 28-05-26 18:31:42, Matthew Wilcox (Oracle) wrote:
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
>  fs/nilfs2/mdt.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
> index 09adb40c65e5..2a435349fd21 100644
> --- a/fs/nilfs2/mdt.c
> +++ b/fs/nilfs2/mdt.c
> @@ -148,9 +148,7 @@ nilfs_mdt_submit_block(struct inode *inode, unsigned long blkoff, blk_opf_t opf,
>  	}
>  	map_bh(bh, inode->i_sb, (sector_t)blknum);
>  
> -	bh->b_end_io = end_buffer_read_sync;
> -	get_bh(bh);
> -	submit_bh(opf, bh);
> +	bh_submit(bh, opf, bh_end_read);
>  	ret = 0;
>  
>  	trace_nilfs2_mdt_submit_block(inode, inode->i_ino, blkoff,
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
