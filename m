From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH 16/17] nilfs2: remove cruft in
 nilfs_alloc_seg_bio
Date: Tue, 26 Jan 2021 19:17:39 +0000
Message-ID: <BYAPR04MB49655561B914F4157914AE7186BC9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210126145247.1964410-1-hch@lst.de>
 <20210126145247.1964410-17-hch@lst.de>
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
 bh=MNBteCCasQ58cOiyvvoKF7ZhXhfgS0KrHj5nbUsP/jk=; b=XVLNO/ugQuPevdvUbBTnG90xuw
 1kDKAV+5JuRJHij/LJHzoP2YeCUy65xZMfLSJ/pASVnuiN2R3nTFLsRdlTn+ar9B15OX8za2Ly1pd
 7k1LtnVc39iJ/GhjlMb+ImE4J5etuO+rOlaQceFVztGEuHayIi/eZgff7g3FBSVc6bL8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:Message-ID
 :Date:Subject:CC:To:From:Sender:Reply-To:Content-ID:Content-Description:
 Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
 In-Reply-To:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
 List-Owner:List-Archive; bh=MNBteCCasQ58cOiyvvoKF7ZhXhfgS0KrHj5nbUsP/jk=; b=K
 5r8FY2iaDGnJjqw/LSbOwl1d/UKLWaAIYis1epRVX+U1VrLiTTn7qef6VLrX1C4W7zRFX8YiTl1x1
 9BgLPujuV0ND+k0y9AKrE2w1p8gGlbDYpc9rbgBDdcUX6siINV+sKifheWP48CIG7EX4zd2ytoN5B
 wDKePfA3LW2pb4DM=;
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
 d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
 t=1611688668; x=1643224668;
 h=from:to:cc:subject:date:message-id:references:
 content-transfer-encoding:mime-version;
 bh=MNBteCCasQ58cOiyvvoKF7ZhXhfgS0KrHj5nbUsP/jk=;
 b=LHiTN8EKkGSRjy3RmwbXq02AVzGVkDG5xCWfExm16MlV/Gu01mgcS988
 hh/VXT7sC46H2EXm86gNsinwcfL1DgoWGAj2AmrxjvO08jHVragIF7EJ5
 0BHFIcf93A4awverhG3fhSMLxSblZsoDFGQI6k8Fa+IGES4CW2Wa3K+Zl
 vFu5gIwQ91wU0o7ztA6lXXZIFxz/gsnjCEXBURbhEjGvYmAm+a/5oIv5w
 /0o2si1vUtd9MQ253zGN3fJgCTWFKwmvQDQZhKwVh+UXU8hKj+7fJqwOB
 My67486T+Cig1/3/mCsCDVhFP4u8B8UuKZs0hstXF26MSjvL1AiW0h1AP Q==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNBteCCasQ58cOiyvvoKF7ZhXhfgS0KrHj5nbUsP/jk=;
 b=SQdFN1zLANhCr1XsqkXnbh6sy4/70F0JXqH3QZ6804+ZVih/Jg8ohzLqEigtlsRf7JKG7ke/6TyEQUGaE3GhnYl/DUMwDC/4S7t6GCW2IM/vkAhS5F/IK1UCIUyhkvf/E4kAsDdZaS9qIy+bsrMDXh1tXHybB64D1L/OJj1fikM=
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

On 1/26/21 7:27 AM, Christoph Hellwig wrote:
> bio_alloc never returns NULL when it can sleep.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
Looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
