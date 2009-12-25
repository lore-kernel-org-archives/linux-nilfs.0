From: lakshmi pathi <lakshmipathi.g@gmail.com>
Subject: Re: [Jfs-discussion] benchmark results
Date: Fri, 25 Dec 2009 18:49:19 +0530
Message-ID: <ae2f51270912250519p22aebc0di4faec9e96e8c1707@mail.gmail.com>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
	 <19251.26403.762180.228181@tree.ty.sabi.co.uk>
	 <20091224212756.GM21594@thunk.org>
	 <alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de>
Mime-Version: 1.0
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:in-reply-to:references
         :date:message-id:subject:from:to:cc:content-type;
        bh=SIzMLM3rTC3FUnrezoHWK4qTo+FghuS/F+STwwwMPdo=;
        b=iX5+e9d5u+9vT1egZiRnqUNh+Kre+wHVC8RYH5a8CrxcbP9B7zQHmWpcbhSupXQpXz
         QFPszC8ktnqnzoTCdMrjqO1naba/XFa2pEfT0TtJ9bcDwuOgIlBekZAj/5P5kWTx0EVk
         ZeWkvrCZ8hL22mtS2pfjzAxch0eLmkE6f2CiE=
In-Reply-To: <alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Kujau <lists@nerdbynature.de>
Cc: tytso@mit.edu, jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org, Peter Grandi <pg_jf2@jf2.for.sabi.co.uk>, ext-users <ext3-users@redhat.com>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

I'm a file system testing newbie, I have a  question/doubt,please let
me know if i'm wrong.

Do you think a tool, which uses output from "hdparm" command,to get
hard drives maximum  performance and compares it specific file system
(say for example,"ext4 provides xx throughput against max. device
throughput yy" ) would be more meaningful.

Does using hdparm (or other device throughput related tools) for
benchmarking will be useful?

Thanks.

-- 
Cheers,
Lakshmipathi.G
www.giis.co.in
