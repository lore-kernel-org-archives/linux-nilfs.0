From: patchwork-bot+f2fs@kernel.org
Subject: Re: [f2fs-dev] [PATCH v2 00/89] fs: new accessors for inode->i_ctime
Date: Mon, 04 Sep 2023 18:11:08 +0000
Message-ID: <169385106881.19669.3510550425397118597.git-patchwork-notify@kernel.org>
References: <20230705185812.579118-1-jlayton@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <ecryptfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693851069;
        bh=XLoa47KxRcps38wwidPhLGQHNoTClCg5nlSU2UvnxSI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XZUD/xT7QAeS9CwkDxlRqT/gRWQx0TmxhnpK0eSpl5TdmWje1tq2yvGH+3vZ2+BCT
         jCeZ3PliMwtj4PI/YG14pbxznaZzZiLpm9dwOITxs9QimCVLsdgcY+tXdL8VHHo6Xo
         yN1Gfw9YZmIyD8m43UuRL17+XTyHWk7a5WXn6oF5ggWXw6RS9S101xrDjQsPd+ZkCx
         1CnWWAtQSCxTFtksNwHsJ+bzmvgeWVNV2ZHBFMah4WlUviOzbSHDkb9JT06sfaty1l
         sU4YI09Bt9xI2xASG0RHXL6Mglihp9xk051QekITKNbwSi+f4qbVFzWkXoKrsHAJfp
         TL/wsjYXrOQBg==
In-Reply-To: <20230705185812.579118-1-jlayton@kernel.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jeff Layton <jlayton@kernel.org>
Cc: jk@ozlabs.org, arnd@arndb.de, mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com, gregkh@linuxfoundation.org, arve@android.com, tkjos@android.com, maco@android.com, joel@joelfernandes.org, brauner@kernel.org, cmllamas@google.com, surenb@google.com, dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca, leon@kernel.org, bwarrum@linux.ibm.com, rituagar@linux.ibm.com, ericvh@kernel.org, lucho@ionkov.net, asmadeus@codewreck.org, linux_oss@crudebyte.com, dsterba@suse.com, dhowells@redhat.com, marc.dionne@auristor.com, viro@zeniv.linux.org.uk, raven@themaw.net, luisbg@kernel.org, salah.triki@gmail.com, aivazian.tigran@gmail.com, ebiederm@xmission.com, kees

Hello:

This series was applied to jaegeuk/f2fs.git (dev)
by Christian Brauner <brauner@kernel.org>:

On Wed,  5 Jul 2023 14:58:09 -0400 you wrote:
> v2:
> - prepend patches to add missing ctime updates
> - add simple_rename_timestamp helper function
> - rename ctime accessor functions as inode_get_ctime/inode_set_ctime_*
> - drop individual inode_ctime_set_{sec,nsec} helpers
> 
> I've been working on a patchset to change how the inode->i_ctime is
> accessed in order to give us conditional, high-res timestamps for the
> ctime and mtime. struct timespec64 has unused bits in it that we can use
> to implement this. In order to do that however, we need to wrap all
> accesses of inode->i_ctime to ensure that bits used as flags are
> appropriately handled.
> 
> [...]

Here is the summary with links:
  - [f2fs-dev,v2,07/92] fs: add ctime accessors infrastructure
    https://git.kernel.org/jaegeuk/f2fs/c/9b6304c1d537
  - [f2fs-dev,v2,08/92] fs: new helper: simple_rename_timestamp
    https://git.kernel.org/jaegeuk/f2fs/c/0c4767923ed6
  - [f2fs-dev,v2,92/92] fs: rename i_ctime field to __i_ctime
    https://git.kernel.org/jaegeuk/f2fs/c/13bc24457850

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


