Received: from server57.webgo24.de (server57.webgo24.de [185.30.32.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718FC2C0F9C
	for <linux-nilfs@vger.kernel.org>; Tue,  4 Nov 2025 16:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.30.32.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762274627; cv=none; b=avtojQrk/SG73GBwb2Rp86Njiy+iLpXQ2xe+kxHEomzTxacBtMJWVEHFS9q327Tpm5HQiWzYky527axLg7Nnk6cZp3BPsCS+PxZB3vkh2TDwzYI6QfqGZLNHJ162CXvQ1BR47uWZFLR09xGeDiS6qU/qOJZKj+c2XcnF0IWHLV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762274627; c=relaxed/simple;
	bh=eCP3nYOJ/a7jawXlJ8ck9CSXbxFuqiAmrX+xwBRMKLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O1bqCYJiBVPGeXctQyA15NyZ/el1xFpnTzv5TXPHNgqxz9Ljb0Dle+u2tVulEQcGOOI5s6L8szL4ZhlZ4tKqHdTIDs7aaCIpyclZdSufpzx07tcuFptQDypMj76r/IHAMOTtAKR+BlyFVkmhX1ZmYTDj4flj5f1ncaJ2+y/q5Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmerlin.de; spf=pass smtp.mailfrom=gmerlin.de; dkim=pass (2048-bit key) header.d=gmerlin.de header.i=@gmerlin.de header.b=OcMZaFen; arc=none smtp.client-ip=185.30.32.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmerlin.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmerlin.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmerlin.de header.i=@gmerlin.de header.b="OcMZaFen"
Received: from merari.gmerlin.de (unknown [195.52.48.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by server57.webgo24.de (Postfix) with ESMTPSA id 2810256A068C;
	Tue,  4 Nov 2025 17:43:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmerlin.de; s=dkim;
	t=1762274622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eCP3nYOJ/a7jawXlJ8ck9CSXbxFuqiAmrX+xwBRMKLU=;
	b=OcMZaFenjTwzPpbn3NNvYUOuhl2BERjBFbuuEs2LkyH7j9x95I/SuamGee3W1m1ECiQ8b4
	cAwRfl89g8dgayC48RHg9r9/3K5Z3Wx//RGExB6f08FVjQms+Kab1Fgui4EM5vw6GfQxrv
	+LdRahnlFYczGYh8MYFO3GVuIf/VnzUJ6eDRKm1O0jSEttgOv6xYs9VWzjz8k2jZo3nGFf
	Wpzae9U5yNa8qMVtF4qNdu2S3zuhcubs1yy9UYXEdICt35nLtFm4R8RGM4SBRKxIfXdQBU
	WVz1OsIb4LZp/orkRYx/dIQw+9ZIGCy9dyhxtOpBYVi2OU/gdTcYCfqz9hOLWA==
Received: from localhost (merari.gmerlin.de [local])
	by merari.gmerlin.de (OpenSMTPD) with ESMTPA id 66e1c6da;
	Tue, 4 Nov 2025 16:43:41 +0000 (UTC)
Date: Tue, 4 Nov 2025 17:43:41 +0100
From: Christopher Zimmermann <christopher@gmerlin.de>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org
Subject: Re: nilfs_readdir: bad page in #
Message-ID: <aQotPahwPm-SjA4k@merari.gmerlin.de>
References: <aPJNYX4UtFfUo8DX@merari.gmerlin.de>
 <CAKFNMonRtuknO7G6p-eOuY+WgSQQGsYOWrDdbO2Zh1mBsGp3RA@mail.gmail.com>
 <aQoHEXBY9tusAkQ9@merari.gmerlin.de>
 <CAKFNMonYLKSikthtoGP9z6Loetu0LxrUsGC6vMSAwaCPE6muqQ@mail.gmail.com>
 <aQokBe0xUtcitVnj@merari.gmerlin.de>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aQokBe0xUtcitVnj@merari.gmerlin.de>

On Tue, Nov 04, 2025 at 05:04:18PM +0100, Christopher Zimmermann wrote:

… and it hit again. This time not only .xsession-error, but two inodes:

Nov 04 17:30:52 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): nilfs_readdir: bad page in #23280
Nov 04 17:30:57 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): nilfs_bmap_lookup_contig: broken bmap (inode number=112670)
Nov 04 17:31:07 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): nilfs_bmap_lookup_contig: broken bmap (inode number=112670)
Nov 04 17:34:44 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): nilfs_bmap_lookup_contig: broken bmap (inode number=112670)
Nov 04 17:34:53 merari.gmerlin.de kernel: NILFS error (device nvme0n1p5): nilfs_bmap_lookup_contig: broken bmap (inode number=126553)

find ~/ -inum 112670 -o -inum 126553
/home/madroach/.mozilla/firefox/jlon54e9.vanilla/storage/default/https+++web.whatsapp.com/idb/3166453069wcaw.sqlite-wal
/home/madroach/.xsession-errors.old

Well, restoring backups is mostly routine now :)


Christopher
