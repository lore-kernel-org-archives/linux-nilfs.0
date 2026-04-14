Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EDC2D5C91;
	Tue, 14 Apr 2026 00:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776126625; cv=none; b=KV1r23UewgJbt9FwlRodgjKwnhRCCW+rEwNftRwhBA+tfdfHFxwf5cxxQN2LaPKqSbo6CZYAhRRCrc3MloqG36OXoIDkp1J1N7y1Js37H1DXWeQ6vKhMZ+AG+xzcR0OhMQlcdpT5yDMgtMR3d3cnxG7FMuT+gXih93bjq65IzeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776126625; c=relaxed/simple;
	bh=TVMumpbIvEDyGcor/SaIdy6Q7fF+T/kDf2N1Z7Z0LVE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=YWJs8ot2ob+Zh7GYgYxHQKOYyN5doNENIdKS5fgApX1HRJE+8VxPOly3REny3BAfxrk1KdPQL4RkIxLXme7KGl1NX8MFYtEN6f0brwcHmQkqkJIRdKMlyO9V0vefvbOu2bVyHqt1Mn0EqcrdwyRomKh+sMYzs3w12avh3T8FBnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lrbzlWFh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lrbzlWFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FA4C2BCAF;
	Tue, 14 Apr 2026 00:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776126624;
	bh=TVMumpbIvEDyGcor/SaIdy6Q7fF+T/kDf2N1Z7Z0LVE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=lrbzlWFhK5oUbCW5fgkyixZtX5VI6ATkwzHnPcUMMOrbyp3Iqlvuox1bivN9NSM/S
	 84hL5N60hXhFkITzhamtlGdcqjYI8P78SQamTxtudYJ/LFGgKR/OSs+XhgRuHCdmT1
	 zktNu2iOPNLkSP6uF9sU3tdn1gh/2emQxmb+2+SC2dCaIBSNtiV7h6K75l+toNFpYT
	 r0OcmDBYJA3wHq47U4wFZcBjxm+qUeXy8Friv8ytj9tet74PkpjdACyK5Mxsnppr1y
	 jWnLtiErwBKspCczQP8NDl6HBFVbJUOdCRbxAzm8Hqi3BCJdq6NMLdsPw7P/q30lcd
	 OiuR23Ei+gBAg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02CC23809A0B;
	Tue, 14 Apr 2026 00:29:57 +0000 (UTC)
Subject: Re: [GIT PULL] nilfs2 changes for 7.1-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <527a5bdc86b866f96a9ceab4aae7180e12f74624.camel@dubeyko.com>
References: <527a5bdc86b866f96a9ceab4aae7180e12f74624.camel@dubeyko.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <527a5bdc86b866f96a9ceab4aae7180e12f74624.camel@dubeyko.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vdubeyko/nilfs2.git tags/nilfs2-v7.1-tag1
X-PR-Tracked-Commit-Id: be3e5d10643d3be1cbac9d9939f220a99253f980
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f2729827aefffe333e9d92ffd49bef4e35c2c22d
Message-Id: <177612659545.618768.13516780487256546283.pr-tracker-bot@kernel.org>
Date: Tue, 14 Apr 2026 00:29:55 +0000
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: torvalds@linux-foundation.org, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, konishi.ryusuke@gmail.com, Kartikey406@gmail.com, Slava.Dubeyko@ibm.com
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 10 Apr 2026 15:09:55 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/vdubeyko/nilfs2.git tags/nilfs2-v7.1-tag1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f2729827aefffe333e9d92ffd49bef4e35c2c22d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
