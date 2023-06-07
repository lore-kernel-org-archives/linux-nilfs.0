From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 17/31] block: add a sb_open_mode helper
Date: Wed, 7 Jun 2023 14:30:03 +0200
Message-ID: <6c9d0bb0-ec67-0d40-9017-0cd9267f23c4@suse.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-18-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
 From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=6awWd81MfbQpPECmTEMQsvwsJnzU0bGaP6n4z8ueT+o=; b=P+c+N+ZuTQnu0OQVKPpXaL/1q0
 PV/XqhKcrZgmYw2/goO4rSHsLlmzhsbgtJfzjc1z09Lcq0o1aTsxXWcDgjMZZKbWuPLMMq8f7IGAX
 UhBpJpkkGNsE4Yula+YeIHL26uTLFUsiCeCwgawUxxyEYwGJByWvLX1y7ENwfkocLTVQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:
 Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=6awWd81MfbQpPECmTEMQsvwsJnzU0bGaP6n4z8ueT+o=; b=djd9rZmRLoSdLesh1ijLHVIDVG
 HuJKyeCXOVe9XXvyC57xI7MxZV6bv8AuAPuS7OG7MU1i+PtxOrnR1vry9hebyZyx/tfWyyTSpwe+8
 8eHmcPxLFX1yBDzdpCJUzyxn25IVkfQHhpKAWpQsKxJVvmta8r1XQnAWRSYxAyg6sir4=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
 t=1686141003; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=6awWd81MfbQpPECmTEMQsvwsJnzU0bGaP6n4z8ueT+o=;
 b=o6WC3BuTLL9OO8DdyBhJYmvOn/cp9vADoKFzPsAr0RP/r8bQecDsCmXoqw9heD81sUEORn
 gKgDvsR/JHpiUeyd8QwMbjKMcycA8o1Zlgo58T8tPF5Mo4UB1SwKujcqqI8pPELo8Gwrn9
 cSpSgIe8zihh7U4pq74OJvGBxyVPI7U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
 s=susede2_ed25519; t=1686141003;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=6awWd81MfbQpPECmTEMQsvwsJnzU0bGaP6n4z8ueT+o=;
 b=TXDqVthNZi6seMbjS6wxpowzv9W/n8Z0FerCL6qlCgHqla7KkeoDrJ8qOT7OA2E2CE8TeL
 BytBOFX89JhkztCQ==
Content-Language: en-US
In-Reply-To: <20230606073950.225178-18-hch@lst.de>
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
> Add a helper to return the open flags for blkdev_get_by* for passed in
> super block flags instead of open coding the logic in many places.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   fs/btrfs/super.c       |  5 +----
>   fs/nilfs2/super.c      |  7 ++-----
>   fs/super.c             | 15 ++++-----------
>   include/linux/blkdev.h |  7 +++++++
>   4 files changed, 14 insertions(+), 20 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
