Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E5F39DBE9
	for <linux-nilfs@vger.kernel.org>; Sat, 30 May 2026 11:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780142209; cv=none; b=b+/EHpjdB2Icip04TkaQKJbq9WG3E0BG5Vk1gyN8HDaLhhjs9h0qpCh6++mgHFDTjmKt4TLcoEqF8AeRcWbB4ZM85/yEPbp5eejtkyfvsO2UpPNFAeBtlFyXPMCvmXE9ag0F1c5AIHC7XwRVhK899y7g+9Z7c3eVaZIiZ/BWl0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780142209; c=relaxed/simple;
	bh=cZQj7NOiwxEBbM7XFcDKWuUsbnCId3BLFqhGhy2dre8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KFFit91pwXGyjRMoJgbXkeqyvzPUnM89/yAwtTHfBc5Tu4rr/4Gf/DzjIh/7TwtEpwPPs6OYqF4HryEHct+AxIERovf7fNJC6EOA0dHIH2KBczxhK28Y7V0yw/IBmfBj3ZqEdr2whoBK7z03WjKJYrdF+tsiwj9eLPI1MeyyQbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=VjKLoHAk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=02z7YnUK; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=VjKLoHAk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=02z7YnUK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="VjKLoHAk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="02z7YnUK";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="VjKLoHAk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="02z7YnUK"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 446DB6B8CF;
	Sat, 30 May 2026 11:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780142206; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pjHoNESbJx7CTd/P8Rp+GYKS1y4e6jvCqJdV0Fl54DY=;
	b=VjKLoHAk6MJ8+GKLh0ncBVqmM5tc4OZGqT2DdVJNY/YjGBa4Yhi56IyHarbu0A9B3rfpOs
	rgZupt71sjdF1ByMk86sDz2b5E/ON6aoRLIO/CFDIC5DUuMqDV/DV5skPergVURFAYx2V6
	ArQOwusc7y+04WqPXAIs/E+QOThx+Ak=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780142206;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pjHoNESbJx7CTd/P8Rp+GYKS1y4e6jvCqJdV0Fl54DY=;
	b=02z7YnUKfTZYFDH6BjGGzbrJE6J7NuMpyLFkyFOQ1M8eSkppgwMOE9V/XznWX5oB3XuPkP
	c+H00+NpZOyi4GBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VjKLoHAk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=02z7YnUK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780142206; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pjHoNESbJx7CTd/P8Rp+GYKS1y4e6jvCqJdV0Fl54DY=;
	b=VjKLoHAk6MJ8+GKLh0ncBVqmM5tc4OZGqT2DdVJNY/YjGBa4Yhi56IyHarbu0A9B3rfpOs
	rgZupt71sjdF1ByMk86sDz2b5E/ON6aoRLIO/CFDIC5DUuMqDV/DV5skPergVURFAYx2V6
	ArQOwusc7y+04WqPXAIs/E+QOThx+Ak=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780142206;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pjHoNESbJx7CTd/P8Rp+GYKS1y4e6jvCqJdV0Fl54DY=;
	b=02z7YnUKfTZYFDH6BjGGzbrJE6J7NuMpyLFkyFOQ1M8eSkppgwMOE9V/XznWX5oB3XuPkP
	c+H00+NpZOyi4GBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3BAF9779A7;
	Sat, 30 May 2026 11:56:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fXCPDn7QGmqHSgAAD6G6ig
	(envelope-from <jack@suse.cz>); Sat, 30 May 2026 11:56:46 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EF501A0EBD; Sat, 30 May 2026 13:56:41 +0200 (CEST)
Date: Sat, 30 May 2026 13:56:41 +0200
From: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	linux-nilfs@vger.kernel.org
Subject: Re: [PATCH v2 28/34] nilfs2: Convert nilfs_gccache_submit_read_data
 to bh_submit()
Message-ID: <bmdqf2ffghn7eda5icbhfv77hiwokal3ol7m5mpyaasxeh57ou@ztbry5hhr43h>
References: <20260528173150.1093780-1-willy@infradead.org>
 <20260528173150.1093780-29-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528173150.1093780-29-willy@infradead.org>
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 446DB6B8CF
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email,suse.cz:dkim,dubeyko.com:email]

On Thu 28-05-26 18:31:41, Matthew Wilcox (Oracle) wrote:
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
>  fs/nilfs2/gcinode.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
> index 62d4c1b787e9..85379ac23ae2 100644
> --- a/fs/nilfs2/gcinode.c
> +++ b/fs/nilfs2/gcinode.c
> @@ -83,9 +83,7 @@ int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
>  	if (!buffer_mapped(bh))
>  		set_buffer_mapped(bh);
>  	bh->b_blocknr = pbn;
> -	bh->b_end_io = end_buffer_read_sync;
> -	get_bh(bh);
> -	submit_bh(REQ_OP_READ, bh);
> +	bh_submit(bh, REQ_OP_READ, bh_end_read);
>  	if (vbn)
>  		bh->b_blocknr = vbn;
>   out:
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
