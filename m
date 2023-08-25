From: Dave Chinner via Linux-f2fs-devel
 <linux-f2fs-devel@lists.sourceforge.net>
Subject: Re: [PATCH 28/29] xfs: support nowait semantics for
 xc_ctx_lock in xlog_cil_commit()
Date: Sat, 26 Aug 2023 07:59:43 +1000
Message-ID: <ZOkkT5Ai7wyMGcWC@dread.disaster.area>
References: <20230825135431.1317785-1-hao.xu@linux.dev>
 <20230825135431.1317785-29-hao.xu@linux.dev>
Reply-To: Dave Chinner <david@fromorbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
 Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=wCmT1oESbAYhZeNNKJ5ShtRN4csCjH3Kne0S41EAnjg=; b=e1ZZqgLDlY4WzKPP9aHdco8noC
 S2KHKPD+YE70mBWnbb/DVCyKPrahISmJW8UZov2OrlghI9oWnT6bKDWuz+aJFRbQpvnTkxfzcXRKg
 u8iMGKcbuIEkGxdg51iA/5WUkV7DHJHFrBUiz1lkXP8/Iz/S5xEbzh5r7KJv+4C9ye78=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=wCmT1oESbAYhZeNNKJ5ShtRN4csCjH3Kne0S41EAnjg=; b=huU8X0FMjTklA7gyI8e4crV2MS
 /HK5ACvUgk70c/bvjy4ThPtNe1aKcr9CM6Wnk9f9YGzwT3nUmedmlU4X9pyePhyHng822hggrL+fy
 M7s1PZREzsadUoHNIYQHML+8UD8LKLoh0obtLO2WIfXGERzFXzKRt3lJmgOkZvHLS6ek=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1693000786; x=1693605586;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=wCmT1oESbAYhZeNNKJ5ShtRN4csCjH3Kne0S41EAnjg=;
 b=41e5WqQODP0hmu8CXJSYnJoxP9CYCTQIjvtSx0suLjuCd2LQoihd/jLrKiko4xwooZ
 7dYHeAbwy4v/acegR7zM2t87koKR6b9HdwUQM9+1khEZHSlP6Ay9Gyi1BnTTJyQ+N1sf
 Tihv+CPf4TPS3j/ZySi0TL4gDqhyuMZ+nJxTaDnexRh6Pcmjy8aRHLfP/t/1vg9xEN/C
 0OJKzvJcUqwLuYg4eu+OPeBIRa0lo/YObVmgzaCCijZ7OHy87LLvHUMM6er4JE4Dhtu4
 AWYpsvb+nGYnjp1AziAY3+XfPWUVf+GXDgs/Cvrt+UTpnf3nupIw3K4PynKsZ49o3GsI
 BY9g==
Content-Disposition: inline
In-Reply-To: <20230825135431.1317785-29-hao.xu@linux.dev>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Hao Xu <hao.xu@linux.dev>
Cc: Wanpeng Li <wanpengli@tencent.com>, "Darrick J . Wong" <djwong@kernel.org>, Dominique Martinet <asmadeus@codewreck.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>, linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org, codalist@coda.cs.cmu.edu, cluster-devel@redhat.com, linux-cachefs@redhat.com, linux-ext4@vger.kernel.org, devel@lists.orangefs.org, linux-cifs@vger.kernel.org, ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-block@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, netdev@vger.kernel.org, samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org

On Fri, Aug 25, 2023 at 09:54:30PM +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Apply trylock logic for xc_ctx_lock in xlog_cil_commit() in nowait
> case and error out -EAGAIN for xlog_cil_commit().

Again, fundamentally broken. Any error from xlog_cil_commit() will
result in a filesystem shutdown as we cannot back out from failure
with dirty log items gracefully at this point.

-Dave.

-- 
Dave Chinner
david@fromorbit.com
