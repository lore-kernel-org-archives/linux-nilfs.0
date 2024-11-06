Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4AB191F89;
	Wed,  6 Nov 2024 06:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730874876; cv=none; b=n4Ka3mt0W8QTt41b2KL+tZUrGXLbIxZvfScQynGAzqdfxD32jsNgoDk+jzIuSF/0vlLvq1cA2iL+4xuX/ktggoGIKQrsmBNK0RQhP3TsBJqXy+M1f83sVB0Sfq3wBsxrNHbnH3a/c8fyvDiqhorP4oWCKuUoz8fk+8XSeUt2I/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730874876; c=relaxed/simple;
	bh=aiIt6g4a5lyagB3+YDLezIbtzJW/GBeS2kN7mBoFm0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lMBwwpZWcYgqK1ZzwpMrUJE8kNkqpInvcu71CX3TVZLD3JlPdV+xcVcY0Rbds3w24UhHpqcSk2vQFbzxaSk3cMLLg8/vg4xNBpC7yw46DrL6xlUobbfLU8wgUdxoj7Ynjs1sGRsXNCpSD4NZeFqWi5RiYzu6B3COJwgLS99RJXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7u49xqi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7u49xqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1836CC4CECD;
	Wed,  6 Nov 2024 06:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730874875;
	bh=aiIt6g4a5lyagB3+YDLezIbtzJW/GBeS2kN7mBoFm0I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k7u49xqiYIRCopmZcuBXZMaHrimeqvjznh1apHCnuHJz0w3JJfbHYYX64Fy6zuavi
	 WTle0LKvDCGgdbwcGYCxnafpf3D4QERV0NjDmSAPDmGxmi+z88Sc+Z96pTAmEtm64T
	 0RBR69741bf6n/PbeC8TKpo199+Qndg+RVh60IDk=
Date: Wed, 6 Nov 2024 07:34:17 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	syzbot+d6ca2daf692c7a82f959@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: FAILED: Patch "nilfs2: fix kernel bug due to missing clearing of
 checked flag" failed to apply to v6.6-stable tree
Message-ID: <2024110608-shut-strenuous-04c8@gregkh>
References: <20241106020945.172057-1-sashal@kernel.org>
 <CAKFNMomd0cxe-hP0CoNH7ERvrPCDhz22sRs=8086-j3H=OqOxg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKFNMomd0cxe-hP0CoNH7ERvrPCDhz22sRs=8086-j3H=OqOxg@mail.gmail.com>

On Wed, Nov 06, 2024 at 03:21:39PM +0900, Ryusuke Konishi wrote:
> Hi Sasha
> 
> About 6 hours ago, I posted an adjusted patch to the list (and to
> Greg) that allows for backporting of this patch to 6.6-stable and
> earlier.
> 
> The patch is titled  "[PATCH 4.19 5.4 5.10 5.15 6.1 6.6] nilfs2: fix
> kernel bug due to missing clearing of checked flag".
> 
> (or https://lkml.kernel.org/r/20241105235654.15044-1-konishi.ryusuke@gmail.com )
> 
> Normally, Greg would pick up the adjusted patch and apply it, and it
> would be backported without any problems, but if the backport of the
> adjusted patch I requested has been rejected, I would like to ask for
> your confirmation.
> 
> If it is a misunderstanding, I will wait for Greg's work, but is the
> process different from usual?

I got it now, thanks!

greg k-h
