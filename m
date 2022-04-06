From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH 07/27] btrfs: use bdev_max_active_zones instead of open
 coding it
Date: Wed, 6 Apr 2022 09:56:17 +0000
Message-ID: <PH0PR04MB74169FBB31E68E76E34DDAC59BE79@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-8-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <xen-devel-bounces@lists.xenproject.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649238982; x=1680774982;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=JIKHihNGnbEQ3W7dNONvT0Zo0ig8aB4rhGiUnglEBT2abQ5Pww5HRzwr
   NK3cZbEOwYe0EsJGM14rQRLxhHQ5K/x5NnZfESKClC8s2/ldZIxuOcQS3
   kuY3wsVSIBxSanDOb8On07AyWGe+ZuOgdyae39XQe3MPZdRW6qfxlpniH
   1fRgeb3UtGQLIy6wHdA4eDw34KwrUxgwAWkCx97swHWTddelxFfc+u8PF
   a3oTcAo8VpjIAuJC9K/ANFV9q5HQsupkk5XEaLX54Lnfyth3QHItDy48a
   EHvuAlCqkueYNIkBNKoxHJO5UfK283hOPDuXfgDWbd442wvsLC739oAij
   A==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=h54PSavZiCLPvRz23Tg4lVZ4eo4TKNMgHAWOAetI02cemxA+lChC4jRXXc8PjhI9PpOfpk4p+MbkbZh9C5rjse+BNktIEqyQrd9A+SZwSDKo/qziD0BGPaKZXMgxzonamG8DYo93OQ1hSVvzQSjS+8JMtRvaZ5G9kcajf+Hcwbk=
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "nbd@other.debian.org" <nbd@other.debian.org>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, linux-nvme@lists.infradead.o

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=

