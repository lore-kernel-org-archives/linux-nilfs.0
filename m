From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH 01/17] zonefs: use bio_alloc in
 zonefs_file_dio_append
Date: Tue, 26 Jan 2021 19:09:29 +0000
Message-ID: <BYAPR04MB496552BD237A2B9388B82CFC86BC9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210126145247.1964410-1-hch@lst.de>
 <20210126145247.1964410-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=MIME-Version:Content-Transfer-Encoding:Content-Type
 :References:Message-ID:Date:Subject:CC:To:From:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:In-Reply-To:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=YGNmnRINIpG1Ldktirw1F7YWnEoLOxBb3VspVRYqkeo=; b=mxgYEmQFmcAXEd3zTudUhXvA4S
 JNQR43sooHmmGMIf/eeSP+H6Smzp6KNoMGBPCZ4qQXUb+UHRmC2abOH9/fnQonAD4552cFiYCMwjJ
 YusreQQCBe/DtkfIZ2KCZuPZbmCdRW1lFX44+eBDuHnzCM0hv0/RUfqPaZ9gv8uYePOg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:Message-ID
 :Date:Subject:CC:To:From:Sender:Reply-To:Content-ID:Content-Description:
 Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
 In-Reply-To:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
 List-Owner:List-Archive; bh=YGNmnRINIpG1Ldktirw1F7YWnEoLOxBb3VspVRYqkeo=; b=L
 AZ6c1RQfzYreNVznJg6eA75oP7sgHbT6dM293km3mGe0y2MBYBWqLk1myTH3U7mWsh2xC10OQYB2E
 jQs1cgmLzHKVNj6QWEN6nu3FwuDknH1dTGulIfyDjzSZzoBjQPccFLuoJIKXZryZdYKxc7EqOf5jr
 Fijtu+AYO0DcwoPQ=;
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
 d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
 t=1611688185; x=1643224185;
 h=from:to:cc:subject:date:message-id:references:
 content-transfer-encoding:mime-version;
 bh=YGNmnRINIpG1Ldktirw1F7YWnEoLOxBb3VspVRYqkeo=;
 b=G0KdycByav1K1FKAF37RwSRplkHmLczB8JPke5Xda9UR+tZYqiyUyWv0
 bh1BZCGmUZHdaRcNvLFLcbZSxEnXL4ll+2YlXs2q+C05qvspTBsbtBk5n
 pAOBFoOn3wl6TbloTsEIs5mVd8Lu2wLr48fSHo44gQQk5tNo5Ckv77oks
 MIySldyvsf9xHoZR4zAr1wkWAm7OIUJrozMB3anpC8OttJilAKped0fDE
 UWhqgMId2pWG66gOeTqJAefCsY57PSTKrOXuGFw1YWPP7sRGvWzN1OBqm
 VXS69H3MUYD18db70+4I0aQATCTx1pB5ckM8rjfBXXmjU4H5B7KNmsLgu w==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YGNmnRINIpG1Ldktirw1F7YWnEoLOxBb3VspVRYqkeo=;
 b=Ksy6ELnealbnBgmT8mPoeUlKa40k/AUv0nJviygP8ikh51UA2gOxdGE2iw++0XMwttPnw26xXO90biaop2t+Da84ywfdyKIAlR3a1nlcxE4qQBdLHbIy9we3LP6Bj5dUnAjgEde5i3yoOQytXca+YN18Qarp9VZX9BeBO0hl2EE=
Content-Language: en-US
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, Naohiro Aota <Naohiro.Aota@wdc.com>, "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, Josef Bacik <josef@toxicpanda.com>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, Coly Li <colyli@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, David Sterba <dsterba@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Andrew Morton <akpm@linux-foundation.org>, Philipp Reisner <philipp.reisner@linbit.com>, "linux-f2fs-devel@lists.sourceforge.net" <linux-f2fs-deve>

On 1/26/21 7:01 AM, Christoph Hellwig wrote:
> Use bio_alloc instead of open coding it.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Ha Ha I was going send out a patch for this :P.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
