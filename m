Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831863EAC76;
	Mon, 13 Jul 2026 09:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783936747; cv=none; b=siUjZOl3WbsiX5JL/U0b+3ZpsdaHY5bX/w61h681BZ/APQzBhlSkx/0YNS63Xwj/CAK8JA6kIRIqw1sE3LHAtoDVlcTqxi4ihehAq7LUsexYlcm0DJH5YIM42D2aMfAYYjtg5eIY2sOpgDmWG2qI6jSafkdzUN1wGBP9f9XsjkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783936747; c=relaxed/simple;
	bh=YlBUt7nswou5vInVDSmKtqY9HvPOSjwm7fdwyXD7ni0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BNVQXCijAn3ESbV65SiHnbCv9SoZnj7sXffsyeibZsvmgvaJQjyyCGwdqMxofsEM9rmRPJkefTCaZEcebqQchJNRluqvHWCS3Ij15C5iF901d2c+m6TUeIMfe7rOlsy5PGa8GM2hnZrr7wMrGGTD5GFxAhXlslvAEka6tsdQlqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 05AEC68BFE; Mon, 13 Jul 2026 11:58:58 +0200 (CEST)
Date: Mon, 13 Jul 2026 11:58:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Christoph Hellwig <hch@lst.de>, David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yangtao Li <frank.li@vivo.com>, Dave Kleikamp <shaggy@kernel.org>,
	Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, ocfs2-devel@lists.linux.dev
Subject: Re: removing the remaining blockdev_direct_IO users
Message-ID: <20260713095857.GB10501@lst.de>
References: <20260710050744.GA6720@lst.de> <fea4c4f25afb7711d1e8fbe6ca5ab654ec522186.camel@dubeyko.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fea4c4f25afb7711d1e8fbe6ca5ab654ec522186.camel@dubeyko.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 10, 2026 at 09:51:09AM -0700, Viacheslav Dubeyko wrote:
> On Fri, 2026-07-10 at 07:07 +0200, Christoph Hellwig wrote:
> > Hi all,
> > 
> > we have 7 users of blockdev_direct_IO and one of the lower-level
> > __blockdev_direct_IO left, and I'd really like to get rid of them.
> > 
> > The filesystems are affs, fat, hfs, hfsplus, jfs, nilfs2, udf and
> > ocfs2,
> > and you are the relevant maintainers.  In 7.2 exfat converted
> > entirely
> > to iomap, which would be a really good example for a "simple" file
> > system.  Another options especially for the file systems supporting
> > foreign formats would be to just drop direct I/O support and reduce
> > the support burden.
> 
> I like the idea. I think we can try to switch HFS/HFS+ and NILFS2 on
> iomap approach. Do you have some initial patches for this? Which
> particular commit(s) converted the exfat to iomap? It will be good to
> take a deeper look into this conversion to estimate the complexity of
> HFS/HFS+, NILFS2 modifications.

Almost all commits in fs/exfat/ in 7.2-rc1, starting with
623f0aa1eca5c2a94ca1e4e5de719d062eac3b6c

