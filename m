From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: [PATCH] nilfs2: only call unlock_new_inode() if I_NEW
Date: Tue, 28 Jul 2020 01:59:43 +0900
Message-ID: <CAKFNMo=ZMHP2_14f8g6AxT7WR7Y_0qDXcq7hhqQLsxTgKE5vdw@mail.gmail.com>
References: <20200628070152.820311-1-ebiggers@kernel.org> <20200727165000.GH1138@sol.localdomain>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=khppo+jLs5IKVg2WuNWXQuRn+S2GoJzKfqbAxy/nNiY=;
        b=oux8HQ9ZJE0ipaTs9n4SlEY/8I4Cssg4G2BaFvd1iGGaD2ZUJKZJeoirsGmVqN9Q1g
         LggBxRc8tAFSWrS8OC/qjr/52h1mqqRyddm006T3Ue2T0s8IHfVWriH5Hi2LWm4F3rZ5
         FgQHf3Ydv6qwr84pnVnwnGDL01QAqeYwkOF9X3AYCIkUrc8451qzNiOynvuiXIy4Cy7y
         nrWrKc3pkzViTxqOGT7f2KmMAEa5bO2mbMDXiLlig+6IHOXroWXhkPtxB/A6jhp1doPM
         XDVSTvug5Y4B1hiQiRP6T8uNotD9wt2v3QIX88H4G6XpN7O2vrpbVd4rz3VpZlByFuZ2
         GGkA==
In-Reply-To: <20200727165000.GH1138@sol.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

Yeah, I sent this to Andrew a little while ago:

  https://lkml.org/lkml/2020/7/27/976

Thanks,
Ryusuke Konishi

On Tue, Jul 28, 2020 at 1:50 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Sun, Jun 28, 2020 at 12:01:52AM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> >
> > unlock_new_inode() is only meant to be called after a new inode has
> > already been inserted into the hash table.  But nilfs_new_inode() can
> > call it even before it has inserted the inode, triggering the WARNING in
> > unlock_new_inode().  Fix this by only calling unlock_new_inode() if the
> > inode has the I_NEW flag set, indicating that it's in the table.
> >
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
>
> Ping.  Ryusuke, any interest in taking this patch?
>
> - Eric
