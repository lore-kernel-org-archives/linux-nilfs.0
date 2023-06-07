From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 24/31] rnbd-srv: replace sess->open_flags
 with a "bool readonly"
Date: Wed, 7 Jun 2023 15:07:53 +0200
Message-ID: <69e78359-0fb6-2c31-9d17-9d1e84e97da8@suse.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-25-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
 From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=WYR6E+7CZ66zHJYLJjKOaLzPM1Za0GV1ZkeQn6/iILE=; b=NupnNzw99ECZC0A5lXaB2E7Q67
 YY7zn3aLled4L94i3Zg7Rv7IZ0UEXYtXuqwUB02zGpCLNzLgSGN4guiWZBWPsLQDJgAZpk+Zg5vup
 NO9sRlfG+jYIouD0urXp7AKc4Cjp5tDpVK4tXxUHXJ2qQwhSDvaN49JgXYX74vtDKJkc=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:
 Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=WYR6E+7CZ66zHJYLJjKOaLzPM1Za0GV1ZkeQn6/iILE=; b=ct+D1s1PfKhNfCx0lwr2au14Ah
 XV/BGc1Yosz7Q99FoObe0e89DOo5K2XpRRPouCP09/F8C/NceZ98UfW0Bqh469JvkvgVO4/0Y+WSF
 gJbeXCFWNoGpgk2PpoCgJS8R6Nzx6Mge4hdhJYTvRzEnAjeeUcW+S+e53+1Y67k3ARXE=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
 t=1686143273; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=WYR6E+7CZ66zHJYLJjKOaLzPM1Za0GV1ZkeQn6/iILE=;
 b=ssiTa2zohPfH5pK3Hpp4pFjmGEPTu9BvzTV4Hxc9Hy4aHW+aBIBg03o+H106+SGtAaa+Ib
 NJTzrhCdz+kX2DErhr9voa5MelMACD+q+7OUiJtlNffoiHdZVV5haMOb20VKY2C1N2qipc
 ykw9WMEI79WfMD6Adbvi5wNHysTCTZs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
 s=susede2_ed25519; t=1686143273;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=WYR6E+7CZ66zHJYLJjKOaLzPM1Za0GV1ZkeQn6/iILE=;
 b=NSNEBOoPb7S7vfhhAb7lPvwrcKEwo3g8fFbxqxSrF/BThS2UHNKlcSo7I+k3KCBt2dHv2r
 vaNFJQBGNxYbW1Ag==
Content-Language: en-US
In-Reply-To: <20230606073950.225178-25-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org, Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>, dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>, Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>, linux-pm@vger.kernel.org, linux-um@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Christian Brauner <brauner@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.

On 6/6/23 09:39, Christoph Hellwig wrote:
> Stop passing the fmode_t around and just use a simple bool to track if
> an export is read-only.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/block/rnbd/rnbd-srv-sysfs.c |  3 +--
>   drivers/block/rnbd/rnbd-srv.c       | 15 +++++++--------
>   drivers/block/rnbd/rnbd-srv.h       |  2 +-
>   3 files changed, 9 insertions(+), 11 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
