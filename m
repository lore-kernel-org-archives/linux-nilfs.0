Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B1C34C9A3;
	Tue, 16 Jun 2026 07:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781593694; cv=none; b=EcCGv78EYTBNEiPI1k5UkssFrkN32xYAOhagmhnbtyFP7lwvE0QJIGPPa3M4/eObOly7o3rE8rey02Se2xlNZMFmJHeb/MYG+7JhtfbT7qCDAvjfKzpHqx69DybdvaFlnxaW9SZHyvsZa9Xblb0KQpFgH6EcBXPTAdp4gSFYhvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781593694; c=relaxed/simple;
	bh=OmDSjqGEod3goMUKnNIW9SIEZYpDPhqmxeuDjIeAKmU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=uAq6b947dYpvp7/Fd11goIZMe5p8YB+jxZuYH+l/mQh9RgPA6dub3lZ/Jr+MiGBtrigvPBlDSNCqgBU8CgNaD09g1bHTHGQ8p/OiPAYvmF2QFZrqRWbptYBxLrUlzgJex/3GJO7wNjEO5anect7EbeyryUw2kG9Cxrol3vHM8GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y4xrhBUz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y4xrhBUz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6FD1F000E9;
	Tue, 16 Jun 2026 07:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781593692;
	bh=G8c2lNItnVzY2uUCvO5dsP5EXXZGx/4UKb5rshFmSSM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Y4xrhBUzfLfunAzK/nMUCJZEPa+43wONaNleUKLGEv2dseYpDWdoxnEOl6c5i7Lst
	 svgh7KF4pk9jLb85SkT28lrHe46PxiK7Q9ZEyeQNgOVIdpG1XaxlUYdFqSVzs8vlb5
	 tZv6hGcy9/JOpPUXC36GP2E7aNN0N/yR9tm/WzHsWX95KXK4kQHysdpFzAzehBG6g1
	 oqU08vxbmvPkb/aujk/MToXMatYkCD5PMFHfU3/8Zm9iO9iZcb+y4Dv8/2bChq5eIZ
	 Fy//joZYji0FmaQT0Z6S8Gs546mTA21/alRCFxK5oBtOLcZPhwg+5MdvyOgpdSZ3Pm
	 5wRues4r+3b5w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93935383BF5B;
	Tue, 16 Jun 2026 07:08:08 +0000 (UTC)
Subject: Re: [GIT PULL] nilfs2 changes for 7.2-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <6865b4242f6352ef0b2b40a9cf7a85d12464279e.camel@dubeyko.com>
References: <6865b4242f6352ef0b2b40a9cf7a85d12464279e.camel@dubeyko.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <6865b4242f6352ef0b2b40a9cf7a85d12464279e.camel@dubeyko.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vdubeyko/nilfs2.git tags/nilfs2-v7.2-tag1
X-PR-Tracked-Commit-Id: e5925f33e4fa9ee313d481557607adce8e30ed2e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6f60a6033c7dfd02ba8d94111965189c9a7866d4
Message-Id: <178159368711.494683.18281555054767974263.pr-tracker-bot@kernel.org>
Date: Tue, 16 Jun 2026 07:08:07 +0000
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: torvalds@linux-foundation.org, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, konishi.ryusuke@gmail.com, kartikey406@gmail.com, shuangpeng.kernel@gmail.com, zenghongling@kylinos.cn, Slava.Dubeyko@ibm.com
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 15 Jun 2026 22:54:56 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/vdubeyko/nilfs2.git tags/nilfs2-v7.2-tag1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6f60a6033c7dfd02ba8d94111965189c9a7866d4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
