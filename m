Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC7A149C7B;
	Sat,  4 Jan 2025 09:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735981884; cv=none; b=qdLqtDxnTpPLfMFce9LfsLxmziiFbmz5bfnlfyXGrtTtxsMlcyp0iL9s6xE5O7YbisX+zNGWoROkOtGyl7n+PgQLQTmPIc8DBOPNo/EByG6Ux42Wkp/ITAfczO5TEW+JxuvFM9nDl/mrXZGNLD3xthseM0oQL4CjY1lBp8ycY6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735981884; c=relaxed/simple;
	bh=F5hxa229mm2emWXssEaQjuuhAwKyEgCJ8aNxtfV6GNY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oa0Xi6H5c9yvNjI3zsKWKHgu3hOAdSlmk4IFnlZpRLsqfEiKC1c5jhxVZFPTQAxG1p+bPky4hUtmEnjDj+Iy+TLJAdxSCaBKflMyQwsXrGsJa0UDHQosvc+S1RWCwUr3Fxj6JWpAHjVHunmFgzfNPTI1CTTQPHpfErkyklaXOJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rrQI4ruh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rrQI4ruh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9FDC4CED1;
	Sat,  4 Jan 2025 09:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735981884;
	bh=F5hxa229mm2emWXssEaQjuuhAwKyEgCJ8aNxtfV6GNY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rrQI4ruhBAPRMDyHEPdHYUctjVWuU6b4FKk7S4fzqdIdLy10nQ5CY3odyWTWN22to
	 ZJzhFTY6CVwgI7IucjmyXMxIRwosNxIG69PcHYoyyosrk+Y82f2hiGkjmEIl79Yv3O
	 DV2DKnLeFNJJ25RcfoxstKqj1rxb9YpkZCtBxy5jMpBCWyeC46H8Yl1HkcsMuf7nsK
	 OFNlfJ3Xkr/yFwgmKK60e4OaMxG3ikKftFjZOta69tSOGjPfFPQYB4TPHuwv32pV4Q
	 s3hPpRJy6vkndY/a78EON8N7nwRKSLQIbh/BYUW7O59rSUbO9G8QDsOdk90fFQ79aZ
	 8ivw17zc5ckng==
Date: Sat, 4 Jan 2025 10:11:19 +0100
From: Christian Brauner <brauner@kernel.org>
To: syzbot <syzbot+5b9d613904b2f185f2fe@syzkaller.appspotmail.com>
Cc: jack@suse.cz, jfs-discussion@lists.sourceforge.net, 
	konishi.ryusuke@gmail.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, shaggy@kernel.org, syzkaller-bugs@googlegroups.com, 
	viro@zeniv.linux.org.uk
Subject: Re: [syzbot] [jfs?] [nilfs?] WARNING in mnt_ns_release
Message-ID: <20250104-vokabel-nimmersatt-8534deaf69ff@brauner>
References: <676a3d1b.050a0220.2f3838.014f.GAE@google.com>
 <677030ff.050a0220.2f3838.0499.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <677030ff.050a0220.2f3838.0499.GAE@google.com>

On Sat, Dec 28, 2024 at 09:10:23AM -0800, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    8155b4ef3466 Add linux-next specific files for 20241220

This is already fixed in -next. Please report if this happens again.
