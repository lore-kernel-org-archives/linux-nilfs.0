From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH] nilfs2: only call unlock_new_inode() if I_NEW
Date: Mon, 27 Jul 2020 09:50:00 -0700
Message-ID: <20200727165000.GH1138@sol.localdomain>
References: <20200628070152.820311-1-ebiggers@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595868602;
        bh=22XFLIm9G+RbCnMxSWD699xCqAJWa1TDuzMcG089LAY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jhtp3RJWFY+48yj4sM2R/8F9nVBtUNZeL6wdQkMMwq6Qn9msZ1jhhJldtc/KzwB3r
         oL4hDwrm9HsYibBd2P9mYuo9CUsVJqsx18KaqVYviEWqF5wYXahBpNvyUuS36Wb3Ec
         KcW844ZuH3X238JwAk/fFR+WhlSsK+I24mqDsZEs=
Content-Disposition: inline
In-Reply-To: <20200628070152.820311-1-ebiggers@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, Jun 28, 2020 at 12:01:52AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> unlock_new_inode() is only meant to be called after a new inode has
> already been inserted into the hash table.  But nilfs_new_inode() can
> call it even before it has inserted the inode, triggering the WARNING in
> unlock_new_inode().  Fix this by only calling unlock_new_inode() if the
> inode has the I_NEW flag set, indicating that it's in the table.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Ping.  Ryusuke, any interest in taking this patch?

- Eric
